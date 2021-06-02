import 'package:at_login_mobile/providers/follow_from_web_provider.dart';
import 'package:at_login_mobile/services/navigator_service.dart';
import 'package:provider/provider.dart';
import 'package:at_login_mobile/routes/app_routes.dart';
import 'package:at_login_mobile/utils/app_constants.dart';
import 'package:flutter/material.dart';

import 'package:at_login_mobile/services/at_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  rootEnvironment = RootEnvironment.Production;
  runApp(StateContainer(child: MyApp()));
}

/// This widget is the root of your application.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FollowFromWebProvider>(
            create: (context) => FollowFromWebProvider()),
      ],
      child: MaterialApp(
        navigatorKey: NavigatorService.navigatorKey,
        initialRoute: AppRoutes.initialRoute,
        routes: AppRoutes.routes,
        debugShowCheckedModeBanner: false,
        title: AppConstants.appTitle,
        theme: ThemeData(
            primarySwatch: AtTheme.primarySwatch,
            primaryColor: AtTheme.themecolor,
            fontFamily: AtFont.family,
            buttonTheme: ButtonThemeData(
              buttonColor: AtTheme.themecolor,
            )),
      ),
    );
  }
}
