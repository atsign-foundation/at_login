import 'package:server/server.dart';

Future<void> main(List<String> args) async {
  final server = Server();
  await server.start('localhost', 8080);
  print('Serving at http://${server.address.host}:${server.port}');
}
