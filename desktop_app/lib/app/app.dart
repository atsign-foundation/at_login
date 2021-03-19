import 'package:desktop_app/backend/backend.dart';
import 'package:desktop_app/pages/home.dart';
import 'package:desktop_app/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExampleApp extends StatefulWidget {
  static Backend backendOf(BuildContext context) {
    return Provider.of(context, listen: false);
  }

  @override
  _ExampleAppState createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  final _backend = Backend();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Backend>.value(
      value: _backend,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Consumer<Backend>(
          builder: (BuildContext context, Backend backend, Widget? child) {
            if (backend.state == LoginState.LoggedIn) {
              return Home();
            } else {
              return Login();
            }
          },
        ),
      ),
    );
  }
}
