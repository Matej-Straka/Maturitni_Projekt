import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'package:bcrypt/bcrypt.dart';
import 'dart:io';

/// Endpoint for admin operations (content management)
class AdminEndpoint extends Endpoint {
  // Simple auth check - in production use proper JWT/session management
  Future<bool> _isAdmin(Session session, String username, String password) async {
    try {
      final user = await AppUser.db.findFirstRow(
        session,
        where: (t) => t.username.equals(username) & t.isActive.equals(true),
      );

      if (user == null) return false;

      // Use bcrypt for password verification
      final isValid = BCrypt.checkpw(password, user.passwordHash);
      return isValid && user.role == 'admin';
    } catch (e) {
      session.log('_isAdmin error: $e', level: LogLevel.error);
      return false;
    }
  }

  // Simple rate limiting - tracks failed attempts
  final Map<String, List<DateTime>> _loginAttempts = {};
  
  Future<bool> _checkRateLimit(Session session, String username) async {
    final now = DateTime.now();
    final attempts = _loginAttempts[username] ?? [];
    
    // Remove attempts older than 15 minutes
    attempts.removeWhere((time) => now.difference(time).inMinutes > 15);
    
    // Allow max 10 attempts per 15 minutes
    if (attempts.length >= 10) {
      return false;
    }
    
    attempts.add(now);
    _loginAttempts[username] = attempts;
    return true;
  }

  // Check if user has required role (admin, editor, or viewer)
  Future<bool> _hasRole(Session session, String username, String password, List<String> allowedRoles) async {
    try {
      final user = await AppUser.db.findFirstRow(
        session,
        where: (t) => t.username.equals(username) & t.isActive.equals(true),
      );

      if (user == null) return false;

      // Use bcrypt for password verification
      final isValid = BCrypt.checkpw(password, user.passwordHash);
      if (!isValid) return false;

      return allowedRoles.contains(user.role);
    } catch (e) {
      session.log('_hasRole error: $e', level: LogLevel.error);
      return false;
    }
  }

  // Get user role
  Future<String?> _getUserRole(Session session, String username, String password) async {
    try {
      final user = await AppUser.db.findFirstRow(
        session,
        where: (t) => t.username.equals(username) & t.isActive.equals(true),
      );

      if (user == null) return null;

      // Use bcrypt for password verification
      final isValid = BCrypt.checkpw(password, user.passwordHash);
      if (!isValid) return null;

      return user.role;
    } catch (e) {
      session.log('Error getting user role: $e', level: LogLevel.error);
      return null;
    }
  }

  /// ========== Coffee Management ==========

  /// Create new coffee
  Future<Coffee?> createCoffee(
    Session session,
    String username,
    String password,
    String name,
    String description,
    String composition,
    String moreInfo,
    String videoUrl,
    String imageUrl,
  ) async {
    if (!await _hasRole(session, username, password, ['admin', 'editor'])) {
      throw Exception('Unauthorized');
    }

    try {
      final coffee = Coffee(
        name: name,
        description: description,
        composition: composition,
        moreInfo: moreInfo,
        videoUrl: videoUrl,
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final created = await Coffee.db.insertRow(session, coffee);
      return created;
    } catch (e) {
      session.log('Error creating coffee: $e', level: LogLevel.error);
      return null;
    }
  }

  /// Update existing coffee
  Future<Coffee?> updateCoffee(
    Session session,
    String username,
    String password,
    int coffeeId,
    String name,
    String description,
    String composition,
    String moreInfo,
    String videoUrl,
    String imageUrl,
  ) async {
    if (!await _hasRole(session, username, password, ['admin', 'editor'])) {
      throw Exception('Unauthorized');
    }

    try {
      final existing = await Coffee.db.findById(session, coffeeId);
      if (existing == null) return null;

      final updated = existing.copyWith(
        name: name,
        description: description,
        composition: composition,
        moreInfo: moreInfo,
        videoUrl: videoUrl,
        imageUrl: imageUrl,
        updatedAt: DateTime.now(),
      );

      await Coffee.db.updateRow(session, updated);
      return updated;
    } catch (e) {
      session.log('Error updating coffee: $e', level: LogLevel.error);
      return null;
    }
  }

  /// Delete coffee
  Future<bool> deleteCoffee(
    Session session,
    String username,
    String password,
    int coffeeId,
  ) async {
    if (!await _hasRole(session, username, password, ['admin', 'editor'])) {
      throw Exception('Unauthorized');
    }

    try {
      await Coffee.db.deleteWhere(session, where: (t) => t.id.equals(coffeeId));
      return true;
    } catch (e) {
      session.log('Error deleting coffee: $e', level: LogLevel.error);
      return false;
    }
  }

  /// ========== QR Code Management ==========

  /// Assign QR code to coffee
  Future<QRCodeMapping?> assignQRCode(
    Session session,
    String username,
    String password,
    String qrCode,
    int coffeeId,
  ) async {
    if (!await _hasRole(session, username, password, ['admin', 'editor'])) {
      throw Exception('Unauthorized');
    }

    try {
      // Check if QR code already exists
      final existing = await QRCodeMapping.db.findFirstRow(
        session,
        where: (t) => t.qrCode.equals(qrCode),
      );

      if (existing != null) {
        // Update existing
        final updated = existing.copyWith(
          coffeeId: coffeeId,
          isActive: true,
        );
        await QRCodeMapping.db.updateRow(session, updated);
        return updated;
      } else {
        // Create new
        final mapping = QRCodeMapping(
          qrCode: qrCode,
          coffeeId: coffeeId,
          createdAt: DateTime.now(),
          isActive: true,
        );
        final created = await QRCodeMapping.db.insertRow(session, mapping);
        return created;
      }
    } catch (e) {
      session.log('Error assigning QR code: $e', level: LogLevel.error);
      return null;
    }
  }

  /// Get all QR code mappings
  Future<List<QRCodeMapping>> getAllQRMappings(
    Session session,
    String username,
    String password,
  ) async {
    if (!await _hasRole(session, username, password, ['admin', 'editor', 'viewer'])) {
      throw Exception('Unauthorized');
    }

    try {
      return await QRCodeMapping.db.find(session);
    } catch (e) {
      session.log('Error getting QR mappings: $e', level: LogLevel.error);
      return [];
    }
  }

  /// Delete QR code mapping
  Future<bool> deleteQRMapping(
    Session session,
    String username,
    String password,
    int mappingId,
  ) async {
    if (!await _hasRole(session, username, password, ['admin', 'editor'])) {
      throw Exception('Unauthorized');
    }

    try {
      await QRCodeMapping.db.deleteWhere(session, where: (t) => t.id.equals(mappingId));
      return true;
    } catch (e) {
      session.log('Error deleting QR mapping: $e', level: LogLevel.error);
      return false;
    }
  }

  /// ========== User Management ==========

  /// Get available user roles
  Future<List<String>> getRoles(
    Session session,
    String username,
    String password,
  ) async {
    if (!await _isAdmin(session, username, password)) {
      throw Exception('Unauthorized');
    }

    return ['admin', 'editor', 'viewer'];
  }

  /// Get current user's role
  Future<String?> getCurrentUserRole(
    Session session,
    String username,
    String password,
  ) async {
    return await _getUserRole(session, username, password);
  }

  /// Create new admin user
  Future<AppUser?> createUser(
    Session session,
    String adminUsername,
    String adminPassword,
    String newUsername,
    String newPassword,
    String email,
    String role,
  ) async {
    if (!await _isAdmin(session, adminUsername, adminPassword)) {
      throw Exception('Unauthorized');
    }

    try {
      // Use bcrypt with cost factor 12 for strong security
      final hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());

      final user = AppUser(
        username: newUsername,
        passwordHash: hashedPassword,
        email: email,
        role: role,
        isActive: true,
        createdAt: DateTime.now(),
      );

      final created = await AppUser.db.insertRow(session, user);
      return created;
    } catch (e) {
      session.log('Error creating user: $e', level: LogLevel.error);
      return null;
    }
  }

  /// Get all users
  Future<List<AppUser>> getAllUsers(
    Session session,
    String username,
    String password,
  ) async {
    // Only admins can view users
    if (!await _isAdmin(session, username, password)) {
      throw Exception('Unauthorized');
    }

    try {
      return await AppUser.db.find(session);
    } catch (e) {
      session.log('Error getting users: $e', level: LogLevel.error);
      return [];
    }
  }

  /// Update user
  Future<AppUser?> updateUser(
    Session session,
    String adminUsername,
    String adminPassword,
    int userId,
    String? email,
    String? role,
    String? newPassword,
  ) async {
    if (!await _isAdmin(session, adminUsername, adminPassword)) {
      throw Exception('Unauthorized');
    }

    try {
      final user = await AppUser.db.findById(session, userId);
      if (user == null) return null;

      if (email != null) user.email = email;
      if (role != null) user.role = role;
      if (newPassword != null) {
        // Use bcrypt for password hashing
        user.passwordHash = BCrypt.hashpw(newPassword, BCrypt.gensalt());
      }

      final updated = await AppUser.db.updateRow(session, user);
      return updated;
    } catch (e) {
      session.log('Error updating user: $e', level: LogLevel.error);
      return null;
    }
  }

  /// Delete user
  Future<bool> deleteUser(
    Session session,
    String adminUsername,
    String adminPassword,
    int userId,
  ) async {
    if (!await _isAdmin(session, adminUsername, adminPassword)) {
      throw Exception('Unauthorized');
    }

    try {
      // Don't allow deleting yourself
      final admin = await AppUser.db.findFirstRow(
        session,
        where: (t) => t.username.equals(adminUsername),
      );
      if (admin?.id == userId) {
        session.log('Cannot delete yourself', level: LogLevel.warning);
        return false;
      }

      await AppUser.db.deleteWhere(session, where: (t) => t.id.equals(userId));
      return true;
    } catch (e) {
      session.log('Error deleting user: $e', level: LogLevel.error);
      return false;
    }
  }

  /// Toggle user active status
  Future<AppUser?> toggleUserActive(
    Session session,
    String adminUsername,
    String adminPassword,
    int userId,
  ) async {
    if (!await _isAdmin(session, adminUsername, adminPassword)) {
      throw Exception('Unauthorized');
    }

    try {
      final user = await AppUser.db.findById(session, userId);
      if (user == null) return null;

      // Don't allow deactivating yourself
      final admin = await AppUser.db.findFirstRow(
        session,
        where: (t) => t.username.equals(adminUsername),
      );
      if (admin?.id == userId) {
        session.log('Cannot deactivate yourself', level: LogLevel.warning);
        return null;
      }

      user.isActive = !user.isActive;
      final updated = await AppUser.db.updateRow(session, user);
      return updated;
    } catch (e) {
      session.log('Error toggling user active: $e', level: LogLevel.error);
      return null;
    }
  }

  /// Login and verify credentials
  Future<AppUser?> login(
    Session session,
    String username,
    String password,
  ) async {
    session.log('LOGIN CALLED: username=$username', level: LogLevel.info);
    
    // Rate limiting check
    if (!await _checkRateLimit(session, username)) {
      session.log('Rate limit exceeded for user: $username', level: LogLevel.warning);
      throw Exception('Too many login attempts. Please try again later.');
    }
    
    try {
      final user = await AppUser.db.findFirstRow(
        session,
        where: (t) => t.username.equals(username) & t.isActive.equals(true),
      );

      session.log('User found: ${user?.username}', level: LogLevel.info);

      if (user == null) {
        session.log('User not found', level: LogLevel.warning);
        return null;
      }

      // Use bcrypt for password verification
      final isValid = BCrypt.checkpw(password, user.passwordHash);
      session.log('Password check result: $isValid', level: LogLevel.info);
      
      if (isValid) {
        // Update last login
        final updated = user.copyWith(lastLogin: DateTime.now());
        await AppUser.db.updateRow(session, updated);
        session.log('Login successful', level: LogLevel.info);
        return updated;
      }

      session.log('Password mismatch', level: LogLevel.warning);
      return null;
    } catch (e) {
      session.log('Error during login: $e', level: LogLevel.error);
      return null;
    }
  }

  /// ========== File Upload ==========

  /// Upload a file (base64 encoded)
  Future<String?> uploadFileBase64(
    Session session,
    String username,
    String password,
    String fileName,
    String fileDataBase64,
    String fileType,
  ) async {
    if (!await _hasRole(session, username, password, ['admin', 'editor'])) {
      throw Exception('Unauthorized');
    }

    try {
      // Decode base64
      final fileData = base64.decode(fileDataBase64);

      // Validate file type
      final allowedTypes = ['image/jpeg', 'image/png', 'image/jpg', 'video/mp4', 'video/mov', 'video/avi'];
      if (!allowedTypes.contains(fileType)) {
        session.log('Invalid file type: $fileType', level: LogLevel.warning);
        return null;
      }

      // Create uploads directory
      final uploadsDir = await Directory('web/uploads').create(recursive: true);

      // Generate unique filename
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = fileName.split('.').last;
      final baseName = fileName.split('.').first;
      final uniqueFileName = '${timestamp}_$baseName.$extension';

      // Save file
      final filePath = '${uploadsDir.path}/$uniqueFileName';
      final file = File(filePath);
      await file.writeAsBytes(fileData);

      // Return URL
      final url = '/uploads/$uniqueFileName';
      
      // Save to database
      final mediaFile = MediaFile(
        url: url,
        fileName: uniqueFileName,
        fileType: fileType.startsWith('image') ? 'image' : 'video',
        mimeType: fileType,
        fileSize: fileData.length,
        uploadedAt: DateTime.now(),
        uploadedBy: username,
      );
      await MediaFile.db.insertRow(session, mediaFile);
      
      session.log('File uploaded: $url', level: LogLevel.info);
      return url;
    } catch (e) {
      session.log('Error uploading file: $e', level: LogLevel.error);
      return null;
    }
  }

  /// Register uploaded media (used with static server multipart upload)
  Future<MediaFile?> registerMedia(
    Session session,
    String username,
    String password,
    String url,
    String fileName,
    String mimeType,
    int fileSize,
  ) async {
    if (!await _hasRole(session, username, password, ['admin', 'editor'])) {
      throw Exception('Unauthorized');
    }

    final mediaFile = MediaFile(
      url: url,
      fileName: fileName,
      fileType: mimeType.startsWith('image') ? 'image' : 'video',
      mimeType: mimeType,
      fileSize: fileSize,
      uploadedAt: DateTime.now(),
      uploadedBy: username,
    );
    await MediaFile.db.insertRow(session, mediaFile);
    return mediaFile;
  }

  /// Get all uploaded media files
  Future<List<MediaFile>> getAllMedia(
    Session session,
    String username,
    String password,
  ) async {
    if (!await _hasRole(session, username, password, ['admin', 'editor', 'viewer'])) {
      throw Exception('Unauthorized');
    }

    try {
      final media = await MediaFile.db.find(
        session,
        orderBy: (t) => t.uploadedAt,
        orderDescending: true,
      );
      return media;
    } catch (e) {
      session.log('Error getting media: $e', level: LogLevel.error);
      return [];
    }
  }

  /// Delete a media file
  Future<bool> deleteMedia(
    Session session,
    String username,
    String password,
    int mediaId,
  ) async {
    if (!await _hasRole(session, username, password, ['admin', 'editor'])) {
      throw Exception('Unauthorized');
    }

    try {
      // Get media file
      final media = await MediaFile.db.findById(session, mediaId);
      if (media == null) {
        return false;
      }

      // Delete physical file
      final filePath = 'web${media.url}';
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }

      // Delete from database
      final deleted = await MediaFile.db.deleteWhere(session, where: (t) => t.id.equals(mediaId));
      return deleted.isNotEmpty;
    } catch (e) {
      session.log('Error deleting media: $e', level: LogLevel.error);
      return false;
    }
  }
}


