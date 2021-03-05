import 'dart:io';

import 'package:server/utils.dart';

class SessionState {
  factory SessionState.create() {
    return SessionState._(randomString(32));
  }

  SessionState._(this.id);

  final String id;

  String? auth;

  String get cookieHeader => Cookie('session', id).toString();
}
