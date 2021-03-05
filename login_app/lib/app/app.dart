import 'package:app/pages/home.dart';
import 'package:app/pages/login.dart';
import 'package:flutter/material.dart';

@immutable
class AtLoginApp extends StatelessWidget {
  const AtLoginApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red,
        accentColor: Colors.redAccent,
      ),
      initialRoute: LoginScreen.id,
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        HomeScreen.id: (context) => HomeScreen(),
      },
    );
  }
}
