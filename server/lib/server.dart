import 'dart:async';
import 'dart:io';

import 'package:at_client/at_client.dart';
import 'package:at_commons/at_commons.dart' as at_commons;
import 'package:barcode_image/barcode_image.dart' as barcode;
import 'package:image/image.dart' as img;
import 'package:server/model/client_state.dart';
import 'package:server/utils.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_cookie/shelf_cookie.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart' as shelf_static;

class Server {
  Server() {
    final public = shelf_static.createStaticHandler(
      'public',
      defaultDocument: 'index.html',
    );
    _app = Router()
      ..get('/login/<atsign>', _login)
      ..get('/qrcode', _generateQRCode)
      ..mount('/', public);
  }

  final _sessionState = <String, SessionState>{};

  late HttpServer _server;

  late final Router _app;

  late final AtClientPreference _prefs;
  late final AtClient _client;
  late Timer _timer;

  static String atSign = '@bob🛠';
  String? challenge;

  InternetAddress get address => _server.address;

  int get port => _server.port;

  Future<void> start(String hostname, int port) async {
    _server = await io.serve(
      const Pipeline() //
          .addMiddleware(logRequests())
          .addMiddleware(cookieParser())
          .addMiddleware(sessionHandler())
          .addHandler(_app),
      hostname,
      port,
    );

    _prefs = AtClientPreference()
      ..namespace = 'login'
      ..syncStrategy = SyncStrategy.IMMEDIATE
      ..rootDomain = 'vip.ve.atsign.zone';
    await AtClientImpl.createClient(atSign, 'login', _prefs);
    _client = await AtClientImpl.getClient(atSign);
    final atLookUp = _client.getRemoteSecondary().atLookUp;
    print('atlookup ${atLookUp.connection}');
    _timer = Timer.periodic(const Duration(seconds: 3), _checkLogin);
  }

  void _checkLogin(Timer timer) async {
    if (challenge != null) {
      final pair = at_commons.AtKey();
      pair.key = 'test';
      pair.sharedWith = atSign;
      try {
        final result = await _client
            .getRemoteSecondary()
            .atLookUp
            .scan(regex: '.*', sharedBy: atSign, auth: false);
        print('Success ${result}');
      } catch (error) {
        print('Failed $error');
      }
    }
  }

  Middleware sessionHandler() {
    return (Handler handler) {
      return (Request request) {
        final cookies = request.context['cookies']! as CookieParser;
        final sessionId = cookies.get('session_id')?.value;
        SessionState? session;
        if (sessionId != null) {
          session = _sessionState[sessionId];
        }
        if (sessionId == null || session == null) {
          session = SessionState.create();
          _sessionState[session.id] = session;
        }
        return Future.sync(() {
          return handler(
            request.change(context: {
              ...request.context,
              'session_id': session!.id,
            }),
          );
        }).then((res) {
          return res.change(
            headers: {
              ...res.headersAll,
              HttpHeaders.setCookieHeader: [
                cookies.set('session_id', session!.id, path: '/').toString(),
              ]
            },
          );
        });
      };
    };
  }

  SessionState sessionState(Request request) {
    return _sessionState[request.context['session_id'] as String]!;
  }

  Response _login(Request request, String atsign) {
    final session = sessionState(request);
    session.auth = randomString(16);
    atsign = '@bob🛠';
    challenge = session.auth;
    return Response.ok(
      '$atsign ${describeIdentity(session)}: ${session.auth}',
      headers: {
        HttpHeaders.contentTypeHeader: 'text/plain',
      },
    );
  }

  Response _generateQRCode(Request request) {
    final session = sessionState(request);
    if (session.auth == null) {
      return Response.notFound('auth missing');
    }
    final image = img.fill(img.Image(256, 256), 0xFFFFFFFF);
    barcode.drawBarcode(
      image,
      barcode.Barcode.qrCode(
        typeNumber: 3,
        errorCorrectLevel: barcode.BarcodeQRCorrectionLevel.quartile,
      ),
      session.auth!,
    );
    return Response.ok(
      img.encodePng(image),
      headers: {HttpHeaders.contentTypeHeader: 'image/png'},
    );
  }
}
