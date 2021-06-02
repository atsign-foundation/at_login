class Strings {
  //at_me_service
  static const ignoreKeys = 'at_following_by_self|at_followers_of_self|cached:';
  //notification texts
  static const String id = 'id';
  static const String from = 'from';
  static const String to = 'to';
  static const String epochMillis = 'epochMillis';
  static const String key = 'key';
  static const String operation = 'operation';
  static const String value = 'value';

  //follow from web
  static String addFollowConfirmation(String from, String to) {
    return 'Do you want to add $from to $to \'s following list';
  }

  static const String yesButton = 'Yes';
  static const String noButton = 'No';
  //Home screen
  static const String appTitle = 'wavi';
  static const String letsGo = 'Let\'s go!';
  static final String configureAtsign = 'Let\'s configure your new @sign!';
  static final String visitDashboardTitle = 'Visit Dashboard';
  static final String resetButton = 'Reset';
  static const String resetDescription =
      'This will remove the selected @sign and its details from this app only.';
  static const String noAtsignToReset = 'No @signs are paired to reset. ';
  static const String resetErrorText =
      'Please select atleast one @sign to reset';
  static const String resetWarningText =
      'Warning: This action cannot be undone';
}
