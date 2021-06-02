import 'package:at_login_mobile/services/at_services.dart';
import 'package:flutter/material.dart';

class AtTheme {
  // TODO pick a color
  static var themecolor = Color.fromARGB(255, 255, 0, 0);
  static var primarySwatch = MaterialColor(0xFF00B7B8, materialColors);
  static var inactiveThumbColor = Colors.grey[400];
  static var inactiveTrackColor = Colors.grey[300];
  static var activeTrackColor = themecolor.withOpacity(0.3);
  static var activeColor = themecolor;
  static var containerLightColor = Colors.grey[200];
  static var borderColor = Colors.grey[300];
  static var textColor = Colors.grey[400];
  static var buttonTextColor = Colors.white;
  static var darkColor = Color.fromARGB(255, 45, 42, 48);
  static var lightColor = Color.fromARGB(255, 230, 228, 226);
  static var fieldLabelTextColor = Colors.grey[700];
  static var lightColorText = Color.fromARGB(255, 173, 171, 169);
}

///different fonts and sizes used across [@login].
class AtFont {
  /// general bold font.
  static var boldFamily = 'Roboto Bold';
  static double size = 16.0;

  /// general font family.
  static var family = 'Roboto';
  static var comic = 'Comic';
  static var roboto = 'Roboto';
  static var robotoBold = 'Roboto Bold';
  static var comfortaa = 'Comfortaa';
  static var comfortaaBold = 'Comfortaa Bold';
  static var openSans = 'Open Sans';
  static var openSansBold = 'Open SansB';
  static var raleway = 'Raleway';

  /// gives a font size of 17.0.
  static double subHeading = 17.0;
}

///Texts used across [@login].
class AtText {
  final String atsign;
  AtText({this.atsign});
  static const IS_DELETED = '_deleted';
  static const MAP_PREVIEW = 'Map Preview';
  static const SHOW_RADIUS_OVERLAY = 'Show radius overlay';
  static const CONFIRM = "I've saved my private key. ";
  static const APP_NAMESPACE = 'persona';
  static const PUBLIC = 'public';
  static const CUSTOM = 'custom';
  static var rootDomain = rootEnvironment.domain;
  static const EMPTY = '';
  static const SCAN = 'scan';
  static const COPYRIGHT = '2019-2021 THE @ COMPANY';
  static const HOME_START = 'Hi';
  static const HEADER = 'All info is public unless set to ';
  static const HEADER_SUB = 'Private';
  static const BUTTON_DETAILS = 'Next: Add More Info';
  static const BUTTON_DASHBOARD = 'Next: Dashboard';
  static const BUTTON_SOCIAL = 'Next: Social';
  static const SOURCE_CAMERA = 'Take a new picture';
  static const SOURCE_GALLERY = 'Pick from Gallery';
  static const SOURCE_REMOVE = 'Remove Photo';
  static const CROPPER = 'Cropper';
  static const PROFILE_OPTIONS = 'Camera/Gallery';
  static const PRIVATE_IMAGE = 'Set image to private';
  static const PRIVATE_KEY_CAUTION =
      "Please save your private key. For security reasons, it's highly recommended to save it in GDrive/iCloudDrive.";
  static const APP_REGEX = '.*persona@';
  static const APP_KEY_SPLIT_REGEX = '(\w*\.)*persona@';
  static const TITLE_ERROR_DIALOG = 'Error';
  static const ADD_AT_SIGN = 'ADD ANOTHER @SIGN';
  static const VISIT_DASHBOARD = 'Visit Dashboard';
  static const CONFIGURE_ATSIGN = "Let's configure your new @sign!";
  static const CUSTOM_CONTENT = 'CUSTOM CONTENT';
  static const PROFILE_IMAGE_LIMIT = "Allows maximum of 512KB";
  static const PRIVACY_POLICY_URL =
      'https://atsign.com/apps/login/privacy-policy/';
  static const PRIVACY_POLICY = 'Privacy Policy';
  static const URL_PATTERN =
      r"^((((H|h)(T|t)|(F|f))(T|t)(P|p)((S|s)?))\://)?(www.|[a-zA-Z0-9].)[a-zA-Z0-9\-\.]+\.?[a-zA-Z]{2,6}(\:[0-9]{1,5})*(/($|[a-zA-Z0-9\.\,\;\?\'\\\+&amp;%\$#\=~_\-@]+))*$";
  static const YOUTUBE_PATTERN =
      r"^(?:https?:\/\/)?(?:m\.|www\.)?(?:youtu\.be\/|youtube\.com\/(?:embed\/|v\/|watch\?v=|watch\?.+&v=))((?<id>\w|-){11})(?:\S+)?$";
  static const SOCIAL_URL_PATTERN =
      r"^(https|http):\/\/(www.|[a-zA-Z0-9].)[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,6}(\:[0-9]{1,5})*(\/($|[a-zA-Z0-9\.\,\;\?\'\\\+&amp;%\$#\=~_\-@]+))*$";
  static const APP_URL = 'atprotocol://persona';
}

Map<int, Color> materialColors = {
  50: Color.fromRGBO(0, 183, 184, .1),
  100: Color.fromRGBO(0, 183, 184, .2),
  200: Color.fromRGBO(0, 183, 184, .3),
  300: Color.fromRGBO(0, 183, 184, .4),
  400: Color.fromRGBO(0, 183, 184, .5),
  500: Color.fromRGBO(0, 183, 184, .6),
  600: Color.fromRGBO(0, 183, 184, .7),
  700: Color.fromRGBO(0, 183, 184, .8),
  800: Color.fromRGBO(0, 183, 184, .9),
  900: Color.fromRGBO(0, 183, 184, 1),
};

class AtAppBar extends AtText {
  static var scan = 'appbar';
  static const PROFILE = 'Customize your profile';
  static const PRIVATE_KEY_QR_CODE = 'Save your Private Key';
}
