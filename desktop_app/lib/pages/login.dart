import 'package:barcode_widget/barcode_widget.dart';
import 'package:desktop_app/app/app.dart';
import 'package:desktop_app/backend/backend.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@immutable
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _atSignController = TextEditingController(
    text: '@bob🛠',
  );

  void _login() {
    ExampleApp.backendOf(context).login(_atSignController.text);
  }

  void _cancel() {
    ExampleApp.backendOf(context).logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 64.0, horizontal: 128.0),
            child: Center(
              child: Image.asset('assets/logo.png'),
            ),
          ),
          Expanded(
            child: Center(
              child: IntrinsicWidth(
                child: Consumer<Backend>(
                  builder: (BuildContext context, Backend backend, Widget? child) {
                    if (backend.state == LoginState.LoggingIn) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Please scan this QR Code\nin the @login app.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32.0),
                          BarcodeWidget(
                            barcode: Barcode.qrCode(
                              typeNumber: 3,
                              errorCorrectLevel: BarcodeQRCorrectionLevel.quartile,
                            ),
                            width: 256.0,
                            height: 256.0,
                            data: backend.challenge,
                          ),
                          const SizedBox(height: 32.0),
                          ElevatedButton(
                            onPressed: _cancel,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 48.0),
                              child: Text('Cancel'),
                            ),
                          )
                        ],
                      );
                    }
                    return child!;
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _atSignController,
                        decoration: InputDecoration(
                          labelText: 'AtSign',
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _login,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 48.0),
                          child: Text('Login To App'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 128.0),
        ],
      ),
    );
  }
}
