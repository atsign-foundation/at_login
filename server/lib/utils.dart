import 'dart:math' as math;

import 'package:charcode/charcode.dart';

String randomString([int length = 32]) {
  final rand = math.Random();
  return String.fromCharCodes(List.generate(length, (_) {
    switch (rand.nextInt(3)) {
      case 0:
        return $A + rand.nextInt($Z - $A);
      case 1:
        return $a + rand.nextInt($z - $a);
      case 2:
      default:
        return $0 + rand.nextInt($9 - $0);
    }
  }));
}

String describeIdentity(Object? object) => '${object.runtimeType}#${shortHash(object)}';

String shortHash(Object? object) {
  return object.hashCode.toUnsigned(20).toRadixString(16).padLeft(5, '0');
}
