import 'package:at_login_mobile/routes/routes.dart';
import 'package:at_login_mobile/widgets/third_widget.dart';
import 'package:at_login_mobile/widgets/home_widget.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static String initialRoute = Routes.HOME;

  static Map<String, WidgetBuilder> get routes {
    return {
      Routes.HOME: (context) => HomeWidget(),
      Routes.THIRD: (context) => ThirdWidget(),
    };
  }
}
