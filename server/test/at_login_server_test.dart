import 'dart:io';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';
import 'package:server/server.dart';
import 'package:server/utils.dart';

void main() {
  group('Utils tests', () {
    setUp(() async {

    });

    test('good form data', () async {
      var formData = 'atsign=@kevin&remember=off';
      var atsign = parseFormData(formData)['atsign'];
      var remember = parseFormData(formData)['remember'];
      expect(atsign, equals('@kevin'));
      expect(remember, false);
    });
  });
}