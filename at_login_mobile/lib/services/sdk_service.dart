import 'package:at_onboarding_flutter/at_onboarding_flutter.dart';
import 'package:at_login_mobile/services/at_fields.dart';
import 'package:at_login_mobile/utils/app_constants.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_commons/at_commons.dart';

class SDKService {
  static final KeyChainManager _keyChainManager = KeyChainManager.getInstance();
  Map<String, AtClientService> atClientServiceMap = {};
  List<String> atSignsList = [];
  String currentAtsign;
  List<AtKey> scanKeys = [];
  String lastOnboardedAtsign;
  Map<String, bool> monitorConnectionMap = {};

  static final SDKService _singleton = SDKService._internal();
  SDKService._internal();

  factory SDKService() {
    return _singleton;
  }

  ///Returns [atsign]'s atClient instance.
  ///If [atsign] is null then it will be current @sign.
  AtClientImpl _getAtClientForAtsign({String atsign}) {
    atsign ??= currentAtsign;
    if (atClientServiceMap.containsKey(atsign)) {
      return atClientServiceMap[atsign].atClient;
    }
    return null;
  }

  ///Returns new `AtClientPreference` with syncStrategy as `ONDEMAND`.
  Future<AtClientPreference> getAtClientPreference() async {
    final appDocumentDirectory =
        await path_provider.getApplicationSupportDirectory();
    String path = appDocumentDirectory.path;
    var atClientPreference = AtClientPreference()
      ..isLocalStoreRequired = true
      ..commitLogPath = path
      ..namespace = AppConstants.appNamespace
      ..syncStrategy = SyncStrategy.ONDEMAND
      ..rootDomain = AppConstants.rootDomain
      ..syncRegex = AppConstants.syncRegex
      ..hiveStoragePath = path;
    return atClientPreference;
  }

  ///Fetches atsign from device keychain.
  Future<String> getAtSign() async {
    return await _keyChainManager.getAtSign();
  }

  ///Deletes the [atsign] from device storage.
  Future<void> deleteAtSign(String atsign) async {
    await _keyChainManager.deleteAtSignFromKeychain(atsign);
    atClientServiceMap.remove(atsign);
    monitorConnectionMap.remove(atsign);
    if (atsign == currentAtsign) currentAtsign = null;
    if (atsign == lastOnboardedAtsign) lastOnboardedAtsign = null;
    atSignsList.remove(atsign);
  }

  ///Returns list of atsigns stored in device storage.
  Future<List<String>> getAtsignList() async {
    atSignsList = await _keyChainManager.getAtSignListFromKeychain();
    return atSignsList ?? [];
  }

  ///Makes [atsign] as primary in device storage and returns `true` for successful change.
  Future<bool> makeAtSignPrimary(String atsign) async {
    return await _keyChainManager.makeAtSignPrimary(atsign);
  }

  ///Returns `AtValue` for [atKey].
  Future<AtValue> get(AtKey atKey) async {
    AtValue atValue;
    bool validKey = _isValidKey(atKey);
    atKey.sharedWith = validKey ? atKey.sharedWith : null;
    atKey.metadata.isPublic = !validKey ? true : atKey.metadata.isPublic;

    var atKeyCopy = AtKey()
      ..key = atKey.key
      ..isRef = atKey.isRef
      ..metadata = atKey.metadata
      ..sharedBy = atKey.sharedBy
      ..sharedWith = atKey.sharedWith
      ..namespace = atKey.namespace;
    if (atKeyCopy.namespace == AppConstants.personaNameSpace) {
      atKeyCopy.metadata.namespaceAware = false;
      atKeyCopy..key += '.${AppConstants.personaNameSpace}';
    }
    atValue = await _getAtClientForAtsign()?.get(atKeyCopy);

    if (atKeyCopy.namespace == AppConstants.personaNameSpace) {
      await delete(atKeyCopy);
      atKey.metadata.namespaceAware = true;
      await put(atKey, atValue.value);
      atValue = await _getAtClientForAtsign()?.get(atKey);
    }
    if (isValid(atValue.value) && validKey) return atValue;
    //cached keys cannot be updated
    return AtValue();
  }

  ///Returns `true` on updating [atKey] with [value] for current @sign.
  Future<bool> put(AtKey atKey, dynamic value) async {
    return await _getAtClientForAtsign()?.put(atKey, value);
  }

  ///Returns `true` on deleting [atKey] for current @sign.
  Future<bool> delete(AtKey atKey) async {
    return await _getAtClientForAtsign()?.delete(atKey);
  }

  ///Returns List<AtKey> for the current @sign.
  Future<List<AtKey>> getAtKeys([bool isCurrentAtsign, String sharedBy]) async {
    var regex = AppConstants.syncRegex;
    scanKeys = await _getAtClientForAtsign()
        ?.getAtKeys(sharedBy: sharedBy, regex: regex);
    scanKeys.retainWhere((scanKey) => !scanKey.metadata.isCached);
    return scanKeys;
  }

  ///Starts monitor for current @sign and accepts a [responseCallback].
  Future<bool> startMonitor(Function responseCallback) async {
    currentAtsign = await getAtSign();
    var exist = monitorConnectionMap.containsKey(currentAtsign);
    if (exist) {
      return true;
    }
    String privateKey =
        await _getAtClientForAtsign().getPrivateKey(currentAtsign);
    _getAtClientForAtsign().startMonitor(privateKey, responseCallback);
    monitorConnectionMap.putIfAbsent(currentAtsign, () => true);
    return true;
  }

  ///Returns List<AtSign> along with it's primary status from device storge.
  Future<List<AtSign>> getAtsignsWithStatus() async {
    Map<String, bool> atSignsWithState =
        await _keyChainManager.getAtsignsWithStatus();
    List<AtSign> atsignsList = [];
    atSignsWithState.forEach((atsign, status) {
      var atsignObj = AtSign(name: atsign, isLastAccessed: status);
      atsignObj..isOnboarded = isOnboarded(atsign);
      status
          ? atsignsList.insert(0, atsignObj..isOnboarded = true)
          : atsignsList.add(atsignObj);
    });
    return atsignsList;
  }

  ///Resets [atsigns] list from device storage.
  Future<void> resetAtsigns(List atsigns) async {
    for (String atsign in atsigns) {
      await _keyChainManager.resetAtSignFromKeychain(atsign);
      atClientServiceMap.remove(atsign);
      monitorConnectionMap.remove(atsign);
    }
    this.currentAtsign = null;
    this.lastOnboardedAtsign = null;
    this.atSignsList = [];
  }

  ///Returns `true` if [atsign] is onboarded in the app.
  bool isOnboarded(String atsign) {
    return atClientServiceMap.containsKey(atsign);
  }

  sync() async {
    await _getAtClientForAtsign().getSyncManager().sync();
  }

  ///Returns `true` if [value] is a non empty string.
  bool isValid(var value) {
    var result = value == null || value == '' || value == 'null';
    return !result;
  }

  bool _isValidKey(AtKey atKey) {
    return (!atKey.key.contains(RegExp(AppConstants.ignoreKeys)));
  }

  ///Returns null if [atsign] is null else the formatted [atsign].
  ///[atsign] must be non-null.
  String formatAtSign(String atsign) {
    if (atsign == null) {
      return null;
    }
    atsign = atsign.trim().toLowerCase().replaceAll(' ', '');
    atsign = !atsign.startsWith('@') ? '@' + atsign : atsign;
    return atsign;
  }
}
