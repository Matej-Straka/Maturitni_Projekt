import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';

void main() async {
  final router = Router();

  router.post('/upload', (Request request) async {
    final uploadToken = Platform.environment['UPLOAD_TOKEN'] ?? '';
    if (uploadToken.isNotEmpty) {
      final providedToken = request.headers['x-upload-token'] ?? '';
      if (providedToken != uploadToken) {
        return Response.forbidden('Invalid upload token');
      }
    }

    final contentType = request.headers['content-type'];
    if (contentType == null || !contentType.toLowerCase().startsWith('multipart/form-data')) {
      return Response(400, body: 'Expected multipart/form-data');
    }

    final boundary = HeaderValue.parse(contentType).parameters['boundary'];
    if (boundary == null || boundary.isEmpty) {
      return Response(400, body: 'Missing multipart boundary');
    }

    final uploadsDir = await Directory('web/uploads').create(recursive: true);

    String? fileName;
    String? mimeType;
    int fileSize = 0;
    List<int>? fileBytes;

    final transformer = MimeMultipartTransformer(boundary);
    await for (final part in transformer.bind(request.read())) {
      final disposition = part.headers['content-disposition'];
      if (disposition == null) {
        continue;
      }

      final dispositionHeader = HeaderValue.parse(disposition, preserveBackslash: true);
      final name = dispositionHeader.parameters['name'];
      if (name != 'file') {
        continue;
      }

      fileName = dispositionHeader.parameters['filename'] ?? 'upload.bin';
      mimeType = part.headers['content-type'] ?? 'application/octet-stream';

      final bytes = <int>[];
      await for (final chunk in part) {
        bytes.addAll(chunk);
      }
      fileBytes = bytes;
      fileSize = bytes.length;
      break;
    }

    if (fileBytes == null || fileName == null || fileBytes.isEmpty) {
      return Response(400, body: 'Missing file');
    }

    final safeFileName = fileName
        .replaceAll(RegExp(r'[\\/]+'), '_')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final uniqueFileName = '${timestamp}_$safeFileName';
    final filePath = '${uploadsDir.path}/$uniqueFileName';

    final file = File(filePath);
    await file.writeAsBytes(fileBytes, flush: true);

    final response = {
      'url': '/uploads/$uniqueFileName',
      'fileName': uniqueFileName,
      'mimeType': mimeType,
      'fileSize': fileSize,
    };

    return Response.ok(
      jsonEncode(response),
      headers: {'content-type': 'application/json'},
    );
  });

  // Serve files from web/uploads directory
  final staticHandler = createStaticHandler(
    'web/uploads',
    defaultDocument: 'index.html',
  );

  final handler = Pipeline().addMiddleware(logRequests()).addHandler(
        Cascade().add(router).add(staticHandler).handler,
      );

  final server = await shelf_io.serve(handler, '0.0.0.0', 8090);
  print('Static file server running on http://${server.address.host}:${server.port}');
}
