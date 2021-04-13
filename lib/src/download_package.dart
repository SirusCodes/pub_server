import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class DownloadPackage {
  Router get router {
    final _router = Router();
    _router.get(
      '/<package>/versions/<version>.tar.gz',
      (Request request, String package, String version) {
        return Response.ok('$package/versions/$version.tar.gz');
      },
    );

    return _router;
  }
}
