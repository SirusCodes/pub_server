import 'package:pub_server/pub_server.dart';
import 'package:pub_server/src/fake/fake_database.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

const PUB_HOSTED_URL = 'localhost';
const PORT_NO = 8080;

Future<void> main(List<String> arguments) async {
  final router = Router();

  // TODO: Remove this once actual DB is implemented
  final fakedb = FakeDatabase.instance;

  router.mount('/api/packages/', FetchPackages(fakedb).router);

  router.mount('/packages/', DownloadPackage().router);

  final handler = Pipeline() //
      .addMiddleware(logRequests())
      .addHandler(router);

  final server = await io.serve(handler, PUB_HOSTED_URL, PORT_NO);
  print('Connected on http://${server.address.host}:${server.port}');
}
