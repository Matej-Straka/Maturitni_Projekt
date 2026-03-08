import 'package:serverpod/serverpod.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

/// Endpoint for file uploads
class UploadEndpoint extends Endpoint {
  /// Upload a file (image or video)
  Future<String?> uploadFile(Session session, String fileName, List<int> fileData, String fileType) async {
    try {
      // Validate file type
      final allowedTypes = ['image/jpeg', 'image/png', 'image/jpg', 'video/mp4', 'video/mov', 'video/avi'];
      if (!allowedTypes.contains(fileType)) {
        session.log('Invalid file type: $fileType', level: LogLevel.warning);
        return null;
      }

      // Create uploads directory if it doesn't exist
      final uploadsDir = Directory('web/uploads');
      if (!await uploadsDir.exists()) {
        await uploadsDir.create(recursive: true);
      }

      // Generate unique filename
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = path.extension(fileName);
      final uniqueFileName = '${timestamp}_${path.basenameWithoutExtension(fileName)}$extension';
      
      // Save file
      final filePath = path.join(uploadsDir.path, uniqueFileName);
      final file = File(filePath);
      await file.writeAsBytes(fileData);

      // Return URL
      final url = '/uploads/$uniqueFileName';
      session.log('File uploaded: $url', level: LogLevel.info);
      return url;
    } catch (e) {
      session.log('Error uploading file: $e', level: LogLevel.error);
      return null;
    }
  }

  /// Delete uploaded file
  Future<bool> deleteFile(Session session, String fileUrl) async {
    try {
      // Extract filename from URL
      final fileName = path.basename(fileUrl);
      final filePath = path.join('web/uploads', fileName);
      final file = File(filePath);

      if (await file.exists()) {
        await file.delete();
        session.log('File deleted: $fileUrl', level: LogLevel.info);
        return true;
      }
      return false;
    } catch (e) {
      session.log('Error deleting file: $e', level: LogLevel.error);
      return false;
    }
  }
}
