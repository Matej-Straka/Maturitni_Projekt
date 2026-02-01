import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_static/shelf_static.dart';

void main() async {
  // Serve files from web/uploads directory
  final handler = createStaticHandler(
    'web/uploads',
    defaultDocument: 'index.html',
  );

  final server = await shelf_io.serve(handler, '0.0.0.0', 8090);
  print('Static file server running on http://${server.address.host}:${server.port}');
}
