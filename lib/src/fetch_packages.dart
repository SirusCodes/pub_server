import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class FetchPackages {
  Router get router {
    final _router = Router();

    _router.get('/<package>', (Request request, String package) {
      return Response.ok(package);
    });

    _router.get(
      '/<package>/versions/<version>',
      (Request request, String package, String version) {
        return Response.ok('$package/versions/$version');
      },
    );

    return _router;
  }
}
