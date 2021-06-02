import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:at_login_mobile/domain/at_notification.dart';
import 'package:at_login_mobile/providers/follow_from_web_provider.dart';
import 'package:at_login_mobile/services/at_services.dart';
import 'package:at_login_mobile/services/user.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:at_utils/at_logger.dart';
import 'package:at_login_mobile/services/globals.dart' as globals;

class SharedData {
  static final SharedData _singleton = SharedData._internal();

  SharedData._internal();
  final AtSignLogger _logger = AtSignLogger('SharedData');

  factory SharedData.getInstance() {
    return _singleton;
  }
  // String sharedText;
  List<SharedMediaFile> sharedFiles;

  BasicData data;
  AtNotification notificationPayload;

  String followAtsign;

  // set customContentData()

  set sharedFile(List<SharedMediaFile> sharedFiles) {
    sharedFiles.forEach((file) {
      File receivedFile = File(file.path);
      Uint8List fileData = receivedFile.readAsBytesSync();
      if (file.type == SharedMediaType.IMAGE) {
        data = BasicData()
          ..isPrivate = false
          ..type = CustomContentType.Image.name
          ..value = fileData;
      }
      _logger.finer('Received ${file.type} file');
    });
  }

  set sharedText(String text) {
    var isLink = RegExp(AtText.URL_PATTERN).hasMatch(text);
    data = BasicData()
      ..isPrivate = false
      ..type = isLink
          ? RegExp(AtText.YOUTUBE_PATTERN).hasMatch(text)
              ? CustomContentType.Youtube.name
              : CustomContentType.Link.name
          : CustomContentType.Text.name
      ..value = text;
    _logger.finer('Received ${data.type}');
  }

  set notificationData(String payload) {
    notificationPayload = AtNotification.fromJson(jsonDecode(payload));
    _logger.info('Received notification is $payload');
  }

  set followData(String value) {
    var data = value.split('persona/')[1];
    data = Uri.decodeFull(data);
    var atsign = SDKService().formatAtSign(data);
    if (SDKService().currentAtsign != atsign &&
        SDKService().currentAtsign != null) {
      followAtsign = atsign;
      globals.followType = FollowType.website;
      globals.loadFollowers = true;
      FollowFromWebProvider().setPageState(null);
    }
    _logger.info('Follow atsign received from web app is $followAtsign');
  }
}
