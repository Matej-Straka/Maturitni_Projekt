import 'dart:convert';
import 'dart:io';

import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
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

    final mediaType = MediaType.parse(contentType);
    final boundary = mediaType.parameters['boundary'];
    if (boundary == null || boundary.isEmpty) {
      return Response(400, body: 'Missing multipart boundary');
    }

    final uploadsDir = await Directory('web/uploads').create(recursive: true);

    String? fileName;
    String? uniqueFileName;
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

      final safeFileName = fileName
          .replaceAll(RegExp(r'[\\/]+'), '_')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      uniqueFileName = '${timestamp}_$safeFileName';
      final filePath = '${uploadsDir.path}/$uniqueFileName';

      final file = File(filePath);
      final sink = file.openWrite();
      
      try {
        await for (final chunk in part) {
          sink.add(chunk);
          fileSize += chunk.length;
        }
        await sink.flush();
        await sink.close();
        fileBytes = [1]; // dummy to indicate success
      } catch (e) {
        await sink.close();
        if (await file.exists()) {
          await file.delete();
        }
        rethrow;
      }
      break;
    }

    if (fileBytes == null || fileName == null || fileSize == 0) {
      return Response(400, body: 'Missing file');
    }

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
