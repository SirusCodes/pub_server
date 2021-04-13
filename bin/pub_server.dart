import 'dart:io';

import 'package:pub_server/pub_server.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

const PUB_HOSTED_URL = 'localhost';
const PORT_NO = 8080;

Future<void> main(List<String> arguments) async {
  final router = Router();

  final fakedb = FakeDatabase();

  router.mount('/api/packages/', FetchPackages(fakedb).router);

  router.mount('/packages/', DownloadPackage().router);

  final handler = Pipeline() //
      .addMiddleware(logRequests())
      .addHandler(router);

  final server = await io.serve(handler, PUB_HOSTED_URL, PORT_NO);
  print('Connected on http://${server.address.host}:${server.port}');
}

class FakeDatabase extends Database {
  @override
  Future<ListVersionModel> listPackageVersion(String package) async {
    final data = await _readFile('list_package.json');
    return ListVersionModel.fromJson(data);
  }

  @override
  Future<VersionModel> packageVersion(String package, String version) async {
    final data = await _readFile('list_package.json');
    return VersionModel.fromJson(data);
  }

  Future<String> _readFile(String name) async {
    final fileAddress = await File('fake_data/$name').resolveSymbolicLinks();
    final file = File(fileAddress);
    return file.readAsString();
  }
}
