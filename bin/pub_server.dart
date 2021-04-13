import 'package:pub_server/pub_server.dart';
import 'package:pub_server/src/download_package.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

const PUB_HOSTED_URL = 'localhost';
const PORT_NO = 8080;

void main(List<String> arguments) {
  final router = Router();

  router.mount('/api/packages/', FetchPackages().router);

  router.mount('/packages/', DownloadPackage().router);

  final handler = Pipeline() //
      .addMiddleware(logRequests())
      .addHandler(router);

  io.serve(handler, PUB_HOSTED_URL, PORT_NO);
  print('Connected on http://$PUB_HOSTED_URL:$PORT_NO');
}
