import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_multipart/shelf_multipart.dart';
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

    if (!request.isMultipart) {
      return Response(400, body: 'Expected multipart/form-data');
    }

    final uploadsDir = await Directory('web/uploads').create(recursive: true);

    String? fileName;
    String? mimeType;
    int fileSize = 0;
    List<int>? fileBytes;

    await for (final formData in request.multipartFormData) {
      if (formData.name != 'file') {
        continue;
      }

      fileName = formData.filename ?? 'upload.bin';
      mimeType = formData.contentType?.mimeType ?? 'application/octet-stream';
      fileBytes = await formData.part.readBytes();
      fileSize = fileBytes.length;
      break;
    }

    if (fileBytes == null || fileName == null) {
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
