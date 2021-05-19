import 'dart:io';

import 'package:pub_server/pub_server.dart';
import 'package:pub_server/src/fake/fake_database.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:test/test.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:http/http.dart' as http;

import '../constants.dart';

void main() {
  late HttpServer server;
  late http.Client client;
  late Uri uri;

  const _path = '/api/packages/';
  const _packageName = 'fake_package';

  setUp(() async {
    final router = Router();

    final fakedb = FakeDatabase();

    router.mount(_path, FetchPackages(fakedb).router);

    server = await io.serve(router, PUB_HOSTED_URL, PORT_NO);
    uri = Uri.parse('https://${server.address.host}:${server.port}');

    client = http.Client();
  });

  // tearDown(() async {
  //   await server.close();
  //   client.close();
  // });

  group('Fetch packages end-points', () {
    test('get list of all versions of a package', () async {
      final result = await client.get(uri.replace(path: '$_path$_packageName'));
      expect(200, result.statusCode);

      final listVersionModel = ListVersionModel.fromJson(result.body);
      expect('fake_package', equals(listVersionModel.name));
    });
  });
}
