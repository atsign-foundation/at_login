import 'dart:convert';
import 'package:at_login_mobile/domain/at_notification.dart';
import 'package:at_login_mobile/services/at_me_utils.dart';
import 'package:at_login_mobile/services/notification_service.dart';
import 'package:at_login_mobile/services/sdk_service.dart';
import 'package:at_utils/at_logger.dart';
import 'package:flutter/material.dart';
import '../utils/app_constants.dart';
import 'at_enum.dart';
import 'state_management.dart';
import 'user.dart';
import 'package:at_commons/at_commons.dart' as at_commons;
import 'package:base2e15/base2e15.dart';

class AtLoginService {
  static final AtLoginService _singleton = AtLoginService._internal();

  AtLoginService._internal();
  final AtSignLogger _logger = AtSignLogger('AtLoginService');
  String currentAtSign;

  final SDKService _sdkService = SDKService();

  factory AtLoginService.getInstance() {
    return _singleton;
  }
  StateContainerState _container;
  User _user;
  List<at_commons.AtKey> scanKeys = [];
  List<String> atSignsList = [];

  Map<dynamic, dynamic> _tempObject = {};

  ///Creates user's profile.
  ///
  ///Throws [assertionError] if user or atsign is null.
  Future<void> createProfile(BuildContext context, Function successCallBack,
      Function errorCallBack) async {
    _container = StateContainer.of(context);
    _user = _container.user;
    _sdkService.currentAtsign = _user.atsign;
    assert(_user != null && _user?.atsign != null);
    try {
      await _storeInSecondary().then((response) {
        _setUser();
        _logger.info('Profile created successfully');
        successCallBack(response);
        _sdkService.sync();
      }).catchError((e) => errorCallBack(e));
    } on Exception catch (e) {
      _logger.severe('throws exception $e');
    }
  }

  ///Updates user profile.
  ///
  ///Throws [assertionError] if user or atsign is null.
  Future<void> updateProfile(BuildContext context, Function successCallBack,
      Function errorCallBack) async {
    _container = StateContainer.of(context);
    _user = _container.user;
    _sdkService.currentAtsign = _user.atsign;
    assert(_user != null && _user?.atsign != null);
    try {
      await _updateInSecondary().then((response) {
        successCallBack(response);
        _sdkService.sync();
      }).catchError((e) => errorCallBack(e));
    } on Exception catch (e) {
      _logger.severe('throws exception $e');
    }
  }

  ///fetches [atsign] login history.
  Future<void> getHistory(BuildContext context,
      {String atsign, Function successCallBack, Function errorCallBack}) async {
    try {
      _sdkService.currentAtsign = atsign ??= _sdkService.currentAtsign;
      _container = StateContainer.of(context);
      _setUser(atsign: atsign);
      scanKeys = await _sdkService.getAtKeys();
      for (var key in scanKeys) {
        await _performLookupAndSetUser(key);
        // if (!result) errorCallBack(false);
      }
      _container.updateWidgets();
      successCallBack(true);
      await _sdkService.sync();
    } catch (err) {
      _logger.severe('Fetching ${_sdkService.currentAtsign} throws $err');
      errorCallBack(err);
    }
  }

  ///Returns `true` on fetching value for [atKey].
  Future<bool> _performLookupAndSetUser(at_commons.AtKey atKey) async {
    var isSetUserField = false;
    var isCustom;
    isCustom = atKey.key.contains(AtText.CUSTOM);
    if (atKey.key == FieldsEnum.IMAGE.name) {
      atKey.metadata.isBinary = true;
    }

    var successValue = await _sdkService.get(atKey);
    if (successValue.value != null) {
      // _logger.info('fetched value ${successValue.value} for key ${atKey.key}');
      isSetUserField = _setUserField(atKey.key, successValue.value, isCustom,
          isPublic: successValue.metadata?.isPublic);
    }
    return isSetUserField;
  }

  /// sets user field with [value].
  bool _setUserField(var key, var value, bool isCustom, {bool isPublic}) {
    try {
      bool isPrivate = true;
      if (isPublic != null && isPublic) {
        isPrivate = false;
      }
      _tempObject[key] = value;
      if (isCustom) {
        _setCustomField(value, isPrivate);
        return true;
      }
      var data = _container.get(key);
      if (data == null || data.isPrivate != true) {
        _container.set(key, value, isPrivate: isPrivate);
      }
    } catch (ex) {
      _logger.severe('setting the $key key for user throws ${ex.toString()}');
    }
    return true;
  }

  ///Returns true if the field gets updated in secondary successfully.
  Future<bool> _update(BasicData data, String key, [bool isCheck]) async {
    var result;
    key = key.trim().toLowerCase().replaceAll(' ', '');
    String sharedWith = data.isPrivate ? _sdkService.currentAtsign : null;
    var value = data.value;
    if (value.isEmpty && isCheck == null) {
      return true;
    }
    var metaData = at_commons.Metadata();
    metaData.isPublic = !data.isPrivate;
    metaData.isEncrypted = data.isPrivate;
    if (key == FieldsEnum.IMAGE.name) {
      metaData.isBinary = true;
    }
    var atKey = at_commons.AtKey()
      ..key = key
      ..sharedWith = sharedWith
      ..metadata = metaData;
    //updates only changed key and deletes previous key if public status is changed.
    if (isCheck != null) {
      var isDeleted = await _deleteChangedKeys(atKey);
      if (value.isEmpty) {
        _tempObject.remove(key.split('.')[0]);
        return await _sdkService.delete(atKey);
      }
      if (isDeleted == null) {
        var notUpdate = _checkCriteria(key.split('.')[0], data.value);
        if (notUpdate) {
          return true;
        }
      }
    }
    result = await _sdkService.put(atKey, value);
    return result;
  }

  ///Returns true on succesfully updating custom fields in secondary.
  Future<bool> _updateCustomFields(String category, List<BasicData> value,
      [bool isCheck]) async {
    var result;
    for (var data in value) {
      String accountname =
          data.accountName.trim().toLowerCase().replaceAll(' ', '');
      String key = AtText.CUSTOM + '_' + accountname;
      String sharedWith = data.isPrivate ? _sdkService.currentAtsign : null;
      String jsonValue = _encodeToJsonString(data, category);
      var metadata = at_commons.Metadata()
        ..isPublic = !data.isPrivate
        ..isEncrypted = data.isPrivate;
      var atKey = at_commons.AtKey()
        ..key = key.contains(AtText.IS_DELETED)
            ? key.replaceAll(AtText.IS_DELETED, '')
            : key
        ..sharedWith = sharedWith
        ..metadata = metadata;
      if (data.value == null && isCheck == null) {
        continue;
      }
      if (isCheck != null) {
        var isDeleted = await _deleteChangedKeys(atKey);
        if (data.value == null) {
          _tempObject.remove(key.split('.')[0]);
          result = await _sdkService.delete(atKey);
          if (!result) return result;
          continue;
        }
        if (isDeleted == null) {
          var notUpdate = _checkCriteria(key, jsonValue);
          if (notUpdate) {
            continue;
          }
        }
      }

      result = await _sdkService.put(atKey, jsonValue);
      if (result == false) {
        return result;
      }
    }
    return result ??= true;
  }

  ///Returns `true` if tempObject's value for [key] is equal to [value].
  bool _checkCriteria(dynamic key, var value) {
    return _tempObject.containsKey(key) ? _tempObject[key] == value : false;
  }

  Future<bool> _updateInSecondary() async {
    scanKeys = await _sdkService.getAtKeys();
    return await _storeInSecondary(true);
  }

  ///Returns 'true' on storing all fields in secondary.
  Future<bool> _storeInSecondary([isCheck]) async {
    //storing detail fields
    for (FieldsEnum field in FieldsEnum.values) {
      var data = _container.get(field.name);
      if (field == FieldsEnum.ATSIGN) {
        continue;
      }
      if (data.value != null) {
        // String key = atkeys.get(field.name);
        var isUpdated = await _update(data, field.name, isCheck);
        if (!isUpdated) return isUpdated;
      }
    }
    // storing custom fields
    Map<String, List<BasicData>> customFields = _user.customFields;
    if (customFields != null) {
      for (var field in customFields.entries) {
        if (field.value == null) {
          continue;
        }
        var isUpdated =
            await _updateCustomFields(field.key, field.value, isCheck);
        if (!isUpdated) return isUpdated;
      }
    }
    return true;
  }

  Future<void> startMonitor() async {
    await _sdkService.startMonitor(acceptStream);
    _logger.info('Monitor started for ${_sdkService.currentAtsign}');
  }

  acceptStream(response) async {
    response = response.toString().replaceAll('notification:', '').trim();
    var notification = AtNotification.fromJson(jsonDecode(response));
    if (notification.operation == 'update' &&
        notification.to == _sdkService.currentAtsign &&
        notification.key.contains(AppConstants.notificationKey)) {
      await NotificationService().showNotification(notification);
    }
  }

  ///deletes old key for atKey if public status is changed.
  Future<bool> _deleteChangedKeys(at_commons.AtKey atKey) async {
    var response;
    var tempScanKeys = [];
    tempScanKeys.addAll(scanKeys);

    tempScanKeys.retainWhere((scanKey) =>
        scanKey.key == atKey.key &&
        !scanKey.metadata.isPublic == atKey.metadata.isPublic);
    if (tempScanKeys.isNotEmpty) {
      response = await _sdkService.delete(tempScanKeys[0]);
    }
    return response;
  }

  ///Returns jsonString of [basicData].
  String _encodeToJsonString(BasicData basicData, String screenName) {
    var value = {};
    value[CustomFieldConstants.label] = basicData.accountName;
    value[CustomFieldConstants.category] = screenName;
    value[CustomFieldConstants.type] = basicData.type;
    value[CustomFieldConstants.value] = basicData.value;
    value = _setCustomContentValue(type: basicData.type, json: value);
    String json = jsonEncode(value);
    return json;
  }

  ///sets user customFields.
  void _setCustomField(String response, isPrivate) {
    var json = jsonDecode(response);
    if (json != 'null' && json != null) {
      String category = json[CustomFieldConstants.category];
      var type = _getType(json[CustomFieldConstants.type]);
      var value = _getCustomContentValue(type: type, json: json);
      String label = json[CustomFieldConstants.label];
      BasicData basicData = BasicData(
          accountName: label, value: value, isPrivate: isPrivate, type: type);
      _container.createCustomField(basicData, category.toUpperCase());
    }
  }

  ///Feches type of customField.
  _getType(type) {
    if (type is String) {
      return type;
    }
    if (type[CustomFieldConstants.name] == CustomFieldConstants.txtInNumber)
      return CustomContentType.Number.name;
    else if (type[CustomFieldConstants.name] == CustomFieldConstants.txtInText)
      return CustomContentType.Text.name;
    else if (type[CustomFieldConstants.name] == CustomFieldConstants.txtInUrl)
      return CustomContentType.Link.name;
  }

  ///returns [json] by modifying the value based on [type].
  _setCustomContentValue({@required var type, @required var json}) {
    json[CustomFieldConstants.valueLabel] = '';
    if (type == CustomContentType.Image.name) {
      json[CustomFieldConstants.value] =
          Base2e15.encode(json[CustomFieldConstants.value]);
      return json;
    } else if (type == CustomContentType.Youtube.name) {
      json[CustomFieldConstants.valueLabel] = json[CustomFieldConstants.value];
      var match = RegExp(AtText.YOUTUBE_PATTERN)
          .firstMatch(json[CustomFieldConstants.value].toString());
      if (match != null && match.groupCount >= 1) {
        json[CustomFieldConstants.value] = match.group(1);
      }
      return json;
    } else {
      return json;
    }
  }

  ///parses customField value from [json] based on type.
  _getCustomContentValue({@required var type, @required var json}) {
    if (type == CustomContentType.Image.name) {
      return Base2e15.decode(json[CustomFieldConstants.value]);
    } else if (type == CustomContentType.Youtube.name) {
      if (json[CustomFieldConstants.valueLabel] != null &&
          json[CustomFieldConstants.valueLabel] != '') {
        return json[CustomFieldConstants.valueLabel];
      }
      return json[CustomFieldConstants.value];
    } else {
      return json[CustomFieldConstants.value];
    }
  }

  ///sets user with [atsign].
  _setUser({String atsign}) {
    _user = User()..atsign = atsign;
    _container.save(_user);
  }
}

class CustomFieldConstants {
  static const String label = 'label';
  static const String value = 'value';
  static const String valueLabel = 'valueLabel';
  static const String category = 'category';
  static const String type = 'type';
  static const String name = 'name';
  static const String txtInNumber = 'TextInputType.number';
  static const String txtInText = 'TextInputType.text';
  static const String txtInUrl = 'TextInputType.url';
}
