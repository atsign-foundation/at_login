import 'package:at_onboarding_flutter/at_onboarding_flutter.dart';
import 'package:at_login_mobile/services/at_services.dart';
import 'package:at_login_mobile/services/navigator_service.dart';
import 'package:flutter/material.dart';

class OnboardingWidgetService {
  var _sdkService = SDKService();

  onboarding(
      {Function onboard,
      Function onError,
      Widget nextScreen,
      String atsign,
      Widget fistTimeAuthNextScreen}) {
    _sdkService.getAtClientPreference().then((value) => Onboarding(
          context: NavigatorService.navigatorKey.currentContext,
          appColor: AtTheme.themecolor,
          onboard: onboard,
          onError: onError,
          nextScreen: nextScreen,
          atsign: atsign,
          domain: AtText.rootDomain,
          fistTimeAuthNextScreen: fistTimeAuthNextScreen,
          atClientPreference: value,
        ));
  }
}
