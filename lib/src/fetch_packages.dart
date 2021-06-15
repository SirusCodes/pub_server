import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import 'database.dart';
import 'exceptions.dart';

class FetchPackages {
  final Database db;

  FetchPackages(this.db);

  static const headers = {
    'content-type': 'application/json; charset="utf-8"',
    'x-content-type-options': 'nosniff',
  };

  Router get router {
    final _router = Router();

    _router.get('/<package>', (Request request, String? package) async {
      try {
        _checkPackageVersionParams(package);
        final listVersion = await db.listPackageVersion(package!);
        return Response.ok(listVersion.toJson(), headers: headers);
      } on ApiResponseException catch (e) {
        return e.asApiResponse();
      }
    });

    _router.get(
      '/<package>/versions/<version>',
      (Request request, String package, String version) async {
        final versionPakg = await db.packageVersion(package, version);
        return Response.ok(versionPakg.toJson());
      },
    );

    return _router;
  }

  void _checkPackageVersionParams(String? package, [String? version]) {
    InvalidInputException.checkNotEmpty(package, 'package');
    InvalidInputException.checkNotNull(package, 'package');
    InvalidInputException.check(
        package!.trim() == package, 'Invalid package name.');
    InvalidInputException.checkStringLength(package, 'package',
        minimum: 1, maximum: 64);
    if (version != null) {
      InvalidInputException.check(
          version.trim() == version, 'Invalid version.');
      InvalidInputException.checkStringLength(version, 'version',
          minimum: 1, maximum: 64);
      if (version != 'latest') {
        InvalidInputException.checkSemanticVersion(version);
      }
    }
  }
}
