import 'dart:convert';
import 'dart:core';

import 'package:at_client/src/util/encryption_util.dart';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_commons/at_commons.dart';
import 'package:at_demo_data/at_demo_data.dart' as at_demo_data;
import 'package:at_server_status/at_server_status.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class Service {
  static final Service _singleton = Service._internal();

  Service._internal();

  factory Service.getInstance() {
    return _singleton;
  }

  late AtClientService atClientServiceInstance;
  late AtClientImpl atClientInstance;
  Map<String, AtClientService> atClientServiceMap = {};
  String? _atsign;

  String get atSign => _atsign!;

  Future<void> _sync() async {
    await _getAtClientForAtsign().getSyncManager().sync();
  }

  AtClientImpl _getAtClientForAtsign({String? atsign}) {
    return _getClientServiceForAtSign(atsign).atClient;
  }

  AtClientService _getClientServiceForAtSign(String? atsign) {
    return atClientServiceMap[atsign ?? _atsign] ?? AtClientService();
  }

  Future<AtClientPreference> _getAtClientPreference({String? cramSecret}) async {
    final appDocumentDirectory = await path_provider.getApplicationSupportDirectory();
    String path = appDocumentDirectory.path;
    var _atClientPreference = AtClientPreference()
      ..isLocalStoreRequired = true
      ..commitLogPath = path
      ..cramSecret = cramSecret
      ..namespace = 'login'
      ..syncStrategy = SyncStrategy.IMMEDIATE
      ..rootDomain = 'vip.ve.atsign.zone'
      ..hiveStoragePath = path;
    return _atClientPreference;
  }

  Future<ServerStatus> _checkAtSignStatus(String atsign) async {
    var atStatusImpl = AtStatusImpl(rootUrl: 'vip.ve.atsign.zone');
    var status = await atStatusImpl.get(atsign);
    return status.serverStatus;
  }

  Future<bool> onboard({required String atsign}) async {
    atClientServiceInstance = _getClientServiceForAtSign(atsign);
    var atClientPreference = await _getAtClientPreference();
    var result = await atClientServiceInstance.onboard(
        atClientPreference: atClientPreference, atsign: atsign);
    _atsign = atsign;
    atClientServiceMap.putIfAbsent(_atsign!, () => atClientServiceInstance);
    _sync();
    return result;
  }

  /// Returns `false` if fails in authenticating [atsign] with [cramSecret]/[privateKey].
  Future<bool> authenticate(
    String atsign, {
    String? privateKey,
    String? jsonData,
    String? decryptKey,
  }) async {
    var atsignStatus = await _checkAtSignStatus(atsign);
    if (atsignStatus != ServerStatus.teapot && atsignStatus != ServerStatus.activated) {
      throw atsignStatus;
    }
    var atClientPreference = await _getAtClientPreference();
    var result = await atClientServiceInstance.authenticate(atsign, atClientPreference,
        jsonData: jsonData, decryptKey: decryptKey);
    _atsign = atsign;
    atClientServiceMap.putIfAbsent(_atsign!, () => atClientServiceInstance);
    await _sync();
    return result;
  }

  String encryptKeyPairs(String atsign) {
    return jsonEncode({
      BackupKeyConstants.AES_PKAM_PUBLIC_KEY: EncryptionUtil.encryptValue(
        at_demo_data.pkamPublicKeyMap[atsign],
        at_demo_data.aesKeyMap[atsign],
      ),
      BackupKeyConstants.AES_PKAM_PRIVATE_KEY: EncryptionUtil.encryptValue(
        at_demo_data.pkamPrivateKeyMap[atsign],
        at_demo_data.aesKeyMap[atsign],
      ),
      BackupKeyConstants.AES_ENCRYPTION_PUBLIC_KEY: EncryptionUtil.encryptValue(
        at_demo_data.encryptionPublicKeyMap[atsign],
        at_demo_data.aesKeyMap[atsign],
      ),
      BackupKeyConstants.AES_ENCRYPTION_PRIVATE_KEY: EncryptionUtil.encryptValue(
        at_demo_data.encryptionPrivateKeyMap[atsign],
        at_demo_data.aesKeyMap[atsign],
      ),
    });
  }

  Future<String> get(AtKey atKey) {
    return _getAtClientForAtsign().get(atKey).then((result) => result.value);
  }

  Future<bool> put(AtKey atKey, String value) {
    return _getAtClientForAtsign().put(atKey, value);
  }

  Future<bool> delete(AtKey atKey) {
    return _getAtClientForAtsign().delete(atKey);
  }

  Future<List<AtKey>> getAtKeys({String? sharedBy}) {
    return _getAtClientForAtsign().getAtKeys(regex: 'login', sharedBy: sharedBy);
  }
}

class BackupKeyConstants {
  static const String AES_PKAM_PUBLIC_KEY = 'aesPkamPublicKey';
  static const String AES_PKAM_PRIVATE_KEY = 'aesPkamPrivateKey';
  static const String AES_ENCRYPTION_PUBLIC_KEY = 'aesEncryptPublicKey';
  static const String AES_ENCRYPTION_PRIVATE_KEY = 'aesEncryptPrivateKey';
}
