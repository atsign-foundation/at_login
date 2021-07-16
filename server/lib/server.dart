import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:at_lookup/at_lookup.dart';
import 'package:barcode_image/barcode_image.dart' as barcode;
import 'package:image/image.dart' as img;
import 'package:server/model/client_state.dart';
import 'package:server/utils.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
//import 'package:shelf_cookie/shelf_cookie.dart';
import 'package:shelf_secure_cookie/shelf_secure_cookie.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart' as shelf_static;

class Server {
  Server() {
    final public = shelf_static.createStaticHandler(
      'public',
      defaultDocument: 'index.html',
    );
    _app = Router()
      ..get('/login/<atsign>', _handleUrlLogin)
      ..get('/login/<atsign>/remember', _handleUrlLogin)
      ..get('/login', _handleUrlParamLogin)
      ..post('/login', _handlePostLogin)
      ..get('/qrcode', _generateQRCode)
      ..mount('/', public);
  }

  final _sessionState = <String, SessionState>{};

  late HttpServer _server;

  late final Router _app;

  AtLookupImpl? _lookup;

  late Timer _timer;

  static String? _atSign;

  static bool _remember = false;

  static String? challenge;

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
    // _timer = Timer.periodic(const Duration(seconds: 3), _checkLogin);
  }

  void _checkLogin(Timer timer) async {
    if (challenge != null && _lookup != null) {
      try {
        final value = await _lookup!
            .lookup(_atSign! + ':test.login', _atSign!, auth: false);
        print('Success $value');
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

  Future<Response> _handlePostLogin(Request request) async {
    // print('got to _handlePostLogin');
    try {
      var body = await request.readAsString(utf8);
      var loginMap = parseFormData(body);
      _atSign = loginMap['atsign'];
      if (_atSign!.isEmpty) {
        final errorPage = File('public/404.html').readAsStringSync();
        return Response.notFound(
          errorPage,
          headers: {
            HttpHeaders.contentTypeHeader: 'text/html',
          },
        );
      }
      ;
      _remember = loginMap['remember'];
      final session = sessionState(request);
      session.auth = randomString(16);
      _lookup = AtLookupImpl(_atSign!, 'root.atsign.org', 64);
      // _lookup = AtLookupImpl(_atSign, 'vip.ve.atsign.zone', 64);
      challenge = session.auth;
      final qrcodePage = File('public/qrcode.html').readAsStringSync();
      return Response.ok(
        qrcodePage,
        headers: {
          HttpHeaders.contentTypeHeader: 'text/html',
        },
      );
    } catch (error) {
      return Response.internalServerError();
    }
  }

  Response _handleUrlLogin(Request request) {
    print('got to _handleUrlLogin');
    var loginMap = parseUrlPath(request.url);
    _atSign = loginMap['atsign'];
    if (_atSign!.isEmpty) {
      final errorPage = File('public/404.html').readAsStringSync();
      return Response.notFound(
        errorPage,
        headers: {
          HttpHeaders.contentTypeHeader: 'text/html',
        },
      );
    }

    _remember = loginMap['remember'];
    print('_handleUrlLogin._atSign: $_atSign');
    print('_handleUrlLogin._remember: $_remember');
    try {
      final session = sessionState(request);
      session.auth = randomString(16);
      _lookup = AtLookupImpl(_atSign!, 'root.atsign.org', 64);
      // _lookup = AtLookupImpl(_atSign, 'vip.ve.atsign.zone', 64);
      challenge = session.auth;
      final qrCodePage = File('public/qrcode.html').readAsStringSync();
      return Response.ok(
        qrCodePage,
        headers: {
          HttpHeaders.contentTypeHeader: 'text/html',
        },
      );
    } catch (error) {
      return Response.internalServerError();
    }
  }

  Response _handleUrlParamLogin(Request request) {
    // print('got to _handleUrlParamLogin');
    var params = request.url.queryParameters;
    if (params.isEmpty) {
      final errorPage = File('public/404.html').readAsStringSync();
      return Response.notFound(
        errorPage,
        headers: {
          HttpHeaders.contentTypeHeader: 'text/html',
        },
      );
    }

    _atSign = params['atsign']!;
    if (_atSign!.isEmpty) {
      final errorPage = File('public/404.html').readAsStringSync();
      return Response.notFound(
        errorPage,
        headers: {
          HttpHeaders.contentTypeHeader: 'text/html',
        },
      );
    }

    _remember = params['remember'] == 'on' ? true : false;
    try {
      final session = sessionState(request);
      session.auth = randomString(16);
      _lookup = AtLookupImpl(_atSign!, 'root.atsign.org', 64);
      // _lookup = AtLookupImpl(_atSign, 'vip.ve.atsign.zone', 64);
      challenge = session.auth;
      final qrCodePage = File('public/qrcode.html').readAsStringSync();
      return Response.ok(
        qrCodePage,
        headers: {
          HttpHeaders.contentTypeHeader: 'text/html',
        },
      );
    } catch (error) {
      return Response.internalServerError();
    }
  }

  Response _generateQRCode(Request request) {
    final session = sessionState(request);
    if (session.auth == null) {
      return Response.notFound('auth missing');
    }
    var jsonContent = json.encode({
      'atsign': _atSign!,
      'challenge': session.auth,
      'requestUrl': request.requestedUri.toString()
    });
    // var content = 'atsign::' +
    //     _atSign! +
    //     ',challenge::' +
    //     session.auth! +
    //     ',requestUrl::' +
    //     request.requestedUri.toString();
    print('content: $jsonContent, length: ${jsonContent.length}');
    final image = img.fill(img.Image(256, 256), 0xFFFFFFFF);
    barcode.drawBarcode(
      image,
      barcode.Barcode.qrCode(
        typeNumber: 11,
        errorCorrectLevel: barcode.BarcodeQRCorrectionLevel.quartile,
      ),
      jsonContent,
    );
    return Response.ok(
      img.encodePng(image),
      headers: {HttpHeaders.contentTypeHeader: 'image/png'},
    );
  }
}
