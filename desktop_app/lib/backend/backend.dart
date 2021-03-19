import 'dart:async';

import 'package:at_lookup/at_lookup.dart';
import 'package:desktop_app/backend/utils.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;

enum LoginState {
  LoggedOut,
  LoggingIn,
  LoggedIn,
}

class Backend extends ChangeNotifier {
  var _loginState = LoginState.LoggedOut;
  late final AtLookupImpl _atLookup;
  Timer? _timer;
  String? _atSign;
  String? _location;
  String? _challenge;

  LoginState get state => _loginState;

  String get atSign => _atSign!;

  String get key => '$_location:$_challenge';

  String get challenge => _challenge!;

  Future<void> login(String atSign) async {
    _atSign = atSign;
    _loginState = LoginState.LoggingIn;
    _location = 'test.login'; //randomString(8);
    _challenge = randomString(16);
    _atLookup = AtLookupImpl(atSign, 'vip.ve.atsign.zone', 64);
    _timer = Timer.periodic(const Duration(seconds: 1), _callback);
    print('login with $key');
    notifyListeners();
  }

  Future<void> _callback(Timer _) async {
    try {
      final value = await _atLookup.lookup('$atSign:$_location', atSign, auth: false);
      if (value == 'data:$_challenge') {
        _loginState = LoginState.LoggedIn;
        _timer!.cancel();
        notifyListeners();
      }
    } catch (error) {
      print('Failed $error');
    }
  }

  Future<void> logout() async {
    _timer?.cancel();
    _atSign = null;
    _loginState = LoginState.LoggedOut;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }
}
