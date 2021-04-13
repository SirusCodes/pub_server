import 'package:pub_server/src/database.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class FetchPackages {
  final Database db;

  FetchPackages(this.db);

  Router get router {
    final _router = Router();

    _router.get('/<package>', (Request request, String package) async {
      final listVersion = await db.listPackageVersion(package);
      return Response.ok(listVersion.toJson());
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
}
