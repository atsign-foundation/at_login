import 'package:at_login_mobile/services/at_enum.dart';
import 'package:flutter/material.dart';

/// Contains pre-defined fields to use across [@me].
class AtFields {}

class Field {
  String fieldName;
  String hintText;
  IconData icon;
  String label;
  var type = TextInputType.text;
  Field(this.fieldName, {this.hintText, this.type, this.icon, this.label});
}

class AtSign {
  String name;
  bool isOpen = false;
  bool isLastAccessed = false;
  bool isOnboarded = false;
  AtSign(
      {@required this.name,
      this.isOpen = false,
      this.isLastAccessed = false,
      this.isOnboarded = false});
}
