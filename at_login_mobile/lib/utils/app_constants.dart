import 'package:at_login_mobile/services/at_services.dart';

class AppConstants {
  static final String rootDomain = rootEnvironment.domain;
  static final String appTitle = '@login';
  static final String appNamespace = 'login';
  static final String personaNameSpace = 'persona';
  static const String copyRight = '2019-2021 THE @ COMPANY';
  static const String privacyPolicy = 'Privacy Policy';
  static const ignoreKeys = 'at_following_by_self|at_followers_of_self';
  static const String appUrl = 'atprotocol://persona';
  static const String appMigratedKey = 'loginMigrated';
  static const String syncRegex = '.(login|persona)@';
  static const String appIconImage = 'assets/images/app-icon.png';

  ///regex `.login@` to filter the keys.
  static const String appRegex = '.login@';
  static const String personaRegex = '.persona@';
  static const String notificationKey = 'at_following_by_self';

  //Button titles
  static const String closeButton = 'Close';
  static const String submitButton = 'Submit';
  static const String cancelButton = 'Cancel';
  static const String removeButton = 'Remove';
}
