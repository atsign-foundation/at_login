import 'package:app/pages/home.dart';
import 'package:app/services/service.dart';
import 'package:at_demo_data/at_demo_data.dart' as at_demo_data;
import 'package:flutter/material.dart';
import 'package:pedantic/pedantic.dart';

@immutable
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static String id = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late Service _service;

  Future? _loading;

  @override
  void initState() {
    super.initState();
    _service = Service.getInstance();
  }

  void _login() {
    _loading = () async {
      final atSign = '@bob🛠';
      final jsonData = _service.encryptKeyPairs(atSign);
      await _service.onboard(atsign: atSign).then((value) async {
        unawaited(Navigator.pushReplacementNamed(context, HomeScreen.id));
      }).catchError((error) async {
        await _service.authenticate(atSign,
            jsonData: jsonData, decryptKey: at_demo_data.aesKeyMap[atSign]);
        unawaited(Navigator.pushReplacementNamed(context, HomeScreen.id));
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox.expand(
        child: SafeArea(
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  'assets/logo.png',
                  height: 50.0,
                ),
              ),
              const SizedBox(height: 64.0),
              FutureBuilder(
                future: _loading,
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasError) {
                    return ErrorWidget(snapshot.error!);
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ElevatedButton(onPressed: _login, child: Text('Login'));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
