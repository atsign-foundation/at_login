import 'package:at_settings/services/at_services.dart';

class AppConstants {
  static final String rootDomain = rootEnvironment.domain;
  static final String appTitle = '@wavi';
  static final String appNamespace = 'wavi';
  static final String personaNameSpace = 'persona';
  static const String copyRight = '2019-2021 THE @ COMPANY';
  static const String privacyPolicy = 'Privacy Policy';
  static const ignoreKeys = 'at_following_by_self|at_followers_of_self';
  static const String appUrl = 'atprotocol://persona';
  static const String appMigratedKey = 'waviMigrated';
  static const String syncRegex = '.(wavi|persona)@';
  static const String appIconImage = 'assets/images/app-icon.png';

  ///regex `.wavi@` to filter the keys.
  static const String appRegex = '.wavi@';
  static const String personaRegex = '.persona@';
  static const String notificationKey = 'at_following_by_self';

  //Button titles
  static const String closeButton = 'Close';
  static const String submitButton = 'Submit';
  static const String cancelButton = 'Cancel';
  static const String removeButton = 'Remove';
}
