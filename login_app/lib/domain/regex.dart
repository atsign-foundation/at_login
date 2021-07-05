import 'dart:core';

import 'package:app/services/at_fields.dart';
import 'package:app/services/at_services.dart';

class Regex {
  static const String twitter = '^[A-Za-z0-9_]{1,15}\$';
  static const String facebook = '^[a-zA-Z0-9\d.]{5,50}\$';
  static String linkedIn = '';
  static const String tumblr = '';
  static const String medium = '';
  static const String instagram = '^[a-zA-Z0-9._]+\$';
  static const String youtube = '';

  static bool isValid(String property, String value) {
    FieldsEnum field = valueOf(property);
    bool result = false;
    switch (field) {
      case FieldsEnum.TWITTER:
        result = RegExp(Regex.twitter).hasMatch(value);
        return !result;
        break;
      case FieldsEnum.INSTAGRAM:
        result = RegExp(Regex.instagram).hasMatch(value);
        return !result;
        break;
      case FieldsEnum.FACEBOOK:
        result = RegExp(Regex.facebook).hasMatch(value);
        return !result;
        break;
      default:
        return result;
        break;
    }
  }
}
