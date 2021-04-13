import 'package:pub_server/src/models/list_version_model.dart';
import 'package:pub_server/src/models/version_model.dart';

abstract class Database {
  Future<ListVersionModel> listPackageVersion(String package);
  Future<VersionModel> packageVersion(String package, String version);
}
