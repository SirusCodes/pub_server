import 'dart:io';

import '../../pub_server.dart';
import '../exceptions.dart';

// TODO: Move this to test once actual DB is implemented
class FakeDatabase extends Database {
  @override
  Future<ListVersionModel> listPackageVersion(String package) async {
    if (package != 'fake_package') {
      throw NotFoundException('$package was not found');
    }
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
