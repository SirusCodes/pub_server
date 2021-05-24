import 'models/list_version_model.dart';
import 'models/version_model.dart';

abstract class Database {
  Future<ListVersionModel> listPackageVersion(String package);

  Future<VersionModel> packageVersion(String package, String version);
}
