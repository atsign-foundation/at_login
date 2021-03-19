import 'package:desktop_app/app/app.dart';
import 'package:flutter/material.dart';

@immutable
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void _logout() {
    ExampleApp.backendOf(context).logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Super secret hidden content for: ${ExampleApp.backendOf(context).atSign}'),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _logout,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
