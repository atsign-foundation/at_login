// import 'package:at_follows_flutter/screens/connections.dart';
import 'package:at_login_mobile/domain/shared_data.dart';
import 'package:at_login_mobile/services/at_services.dart';
// import 'package:at_login_mobile/utils/app_constants.dart';
import 'package:at_login_mobile/widgets/login_from_url.dart';
import 'package:at_login_mobile/widgets/third_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:at_login_mobile/services/globals.dart' as globals;

import 'at_enum.dart';
import 'user.dart';

class AtCommonService {
  static final AtCommonService _singleton = AtCommonService._internal();

  AtCommonService._internal();

  factory AtCommonService.getInstance() {
    return _singleton;
  }

  BasicData formData(name, value, {private, type}) {
    BasicData basicdata = BasicData(
        accountName: name,
        // icon: setIcon(name),
        isPrivate: private ?? false,
        type: TextInputType.text,
        value: value);
    return basicdata;
  }

  // setIcon(fieldName) {
  //   FieldsEnum field = valueOf(fieldName);
  //
  //   switch (field) {
  //     // case FieldsEnum.TWITTER:
  //     //   return Icon(FontAwesomeIcons.twitter, color: Colors.blue, size: 30);
  //     //   break;
  //     // case FieldsEnum.FACEBOOK:
  //     //   return Icon(FontAwesomeIcons.facebook,
  //     //       color: Colors.indigo[700], size: 30);
  //     //   break;
  //     // case FieldsEnum.LINKEDIN:
  //     //   return Icon(FontAwesomeIcons.linkedin,
  //     //       color: Colors.indigo[700], size: 30);
  //     //   break;
  //     // case FieldsEnum.INSTAGRAM:
  //     //   return Icon(FontAwesomeIcons.instagram, color: Colors.red, size: 30);
  //     //   break;
  //     // case FieldsEnum.YOUTUBE:
  //     //   return Icon(FontAwesomeIcons.youtube, color: Colors.red[700], size: 30);
  //     //   break;
  //     // case FieldsEnum.TUMBLR:
  //     //   return Icon(FontAwesomeIcons.tumblr,
  //     //       color: Colors.indigo[800], size: 30);
  //     //   break;
  //     // case FieldsEnum.MEDIUM:
  //     //   return Icon(FontAwesomeIcons.medium, color: Colors.black, size: 30);
  //     //   break;
  //     // case FieldsEnum.XBOX:
  //     //   return Icon(MdiIcons.microsoftXbox, color: Colors.green[800], size: 30);
  //     //   break;
  //     // case FieldsEnum.DISCORD:
  //     //   return Icon(MdiIcons.discord, color: Colors.indigo, size: 30);
  //     //   break;
  //     // case FieldsEnum.STEAM:
  //     //   return Icon(MdiIcons.steam, color: Colors.blue, size: 30);
  //     //   break;
  //     // case FieldsEnum.PS4:
  //     //   return Icon(MdiIcons.sonyPlaystation, color: Colors.indigo, size: 30);
  //     default:
  //       return null;
  //       break;
  //   }
  // }

  openSpecificPage(BuildContext context, {String atsign}) {
    var _sdkService = SDKService();
    if (globals.loadProfileIndex) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => ThirdWidget()));
    } else if (globals.loadFollowers) {
      var sharedData = SharedData.getInstance();
      if (globals.followType == FollowType.website) {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => LoginFromUrl()));
      } else if (globals.followType == FollowType.notification) {
        atsign = sharedData.notificationPayload.to;
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => Connections(
        //               appColor: AtTheme.themecolor,
        //               followerAtsignTitle:
        //                   globals.followType == FollowType.notification
        //                       ? sharedData.notificationPayload.from
        //                       : null,
        //               followAtsignTitle:
        //                   globals.followType == FollowType.notification
        //                       ? null
        //                       : sharedData.followAtsign,
        //               atClientserviceInstance: _sdkService
        //                       .atClientServiceMap[atsign] ??
        //                   _sdkService
        //                       .atClientServiceMap[_sdkService.currentAtsign],
        //             )));
      }
      globals.loadFollowers = false;
    }
  }
}
