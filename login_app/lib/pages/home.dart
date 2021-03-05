import 'package:app/services/service.dart';
import 'package:at_commons/at_commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';

@immutable
class HomeScreen extends StatefulWidget {
  static String id = '/';

  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Service _service;

  @override
  void initState() {
    super.initState();
    _service = Service.getInstance();
  }

  String? _last;

  void _onQrReaderReady(QrReaderViewController controller) {
    controller.onQrBack = _onQrBack;
  }

  void _onQrBack(String data, List<Offset> offsets) {
    if (_last != data) {
      _last = data;
      print('data: $data');
      final pair = AtKey();
      pair.key = 'test';
      pair.sharedWith = _service.atSign;
      pair.metadata = Metadata()..isPublic = true;
      _service.put(pair, data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 320,
              height: 350,
              child: QrReaderView(
                width: 320,
                height: 350,
                callback: _onQrReaderReady,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
