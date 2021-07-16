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

Map parseFormData(String? body) {
  var formData = {'atsign':'', 'remember':false};
  var params = [];
  body!.indexOf('&')>0? params = body.split('&') : params.add(body);
  print(params);
  params.forEach((element) {
    if(element.startsWith('atsign=')) {
      var atSign = element.substring(element.indexOf('=') + 1);
      formData['atsign'] = atSign;
    };
    if(element.startsWith('remember=')) {
      var remember = element.indexOf('on') > 0 ? true : false;
      formData['remember'] = remember;
    };
  });
  return formData;
}

Map parseUrlPath(Uri? url) {
  print('got to parseUrl');
  var formData = {'atsign':'', 'remember':false};
  var atSignIn = '';
  var rememberIn = false;
  var pathSegments = url!.pathSegments;
  // is like /login/@bob or /login/@bob/remember
  if(pathSegments.length == 2) {
    atSignIn = pathSegments[1];
  } else if(pathSegments.length == 3) {
    atSignIn = pathSegments[1];
    rememberIn = pathSegments[2] == 'remember'? true : false;
  }
  print('parseUrlPath atSignIn: $atSignIn');
  print('parseUrlPath rememberIn: $rememberIn');
  formData['atsign'] = atSignIn;
  formData['remember'] = rememberIn;
  return formData;
}

