import 'package:app/utils/strings.dart';

class AtNotification {
  String id;
  String from;
  String to;
  String key;
  String value;
  String operation;
  int dateTime;

  AtNotification(
      {this.id,
      this.from,
      this.to,
      this.key,
      this.value,
      this.dateTime,
      this.operation});

  // AtNotification();

  factory AtNotification.fromJson(Map<String, dynamic> json) {
    return AtNotification(
      id: json[Strings.id],
      from: json[Strings.from],
      dateTime: json[Strings.epochMillis],
      to: json[Strings.to],
      key: json[Strings.key],
      operation: json[Strings.operation],
      value: json[Strings.value],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      Strings.id: id,
      Strings.from: from,
      Strings.to: to,
      Strings.epochMillis: dateTime,
      Strings.key: key,
      Strings.operation: operation,
      Strings.value: value
    };
  }
}
