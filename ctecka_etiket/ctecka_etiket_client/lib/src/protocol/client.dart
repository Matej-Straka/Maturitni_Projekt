/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:ctecka_etiket_client/src/protocol/coffee.dart' as _i3;
import 'package:ctecka_etiket_client/src/protocol/qr_code.dart' as _i4;
import 'package:ctecka_etiket_client/src/protocol/app_user.dart' as _i5;
import 'package:ctecka_etiket_client/src/protocol/media_file.dart' as _i6;
import 'package:ctecka_etiket_client/src/protocol/greeting.dart' as _i7;
import 'protocol.dart' as _i8;

/// Endpoint for admin operations (content management)
/// {@category Endpoint}
class EndpointAdmin extends _i1.EndpointRef {
  EndpointAdmin(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'admin';

  /// ========== Coffee Management ==========
  /// Create new coffee
  _i2.Future<_i3.Coffee?> createCoffee(
    String username,
    String password,
    String name,
    String description,
    String composition,
    String moreInfo,
    String videoUrl,
    String imageUrl,
  ) =>
      caller.callServerEndpoint<_i3.Coffee?>(
        'admin',
        'createCoffee',
        {
          'username': username,
          'password': password,
          'name': name,
          'description': description,
          'composition': composition,
          'moreInfo': moreInfo,
          'videoUrl': videoUrl,
          'imageUrl': imageUrl,
        },
      );

  /// Update existing coffee
  _i2.Future<_i3.Coffee?> updateCoffee(
    String username,
    String password,
    int coffeeId,
    String name,
    String description,
    String composition,
    String moreInfo,
    String videoUrl,
    String imageUrl,
  ) =>
      caller.callServerEndpoint<_i3.Coffee?>(
        'admin',
        'updateCoffee',
        {
          'username': username,
          'password': password,
          'coffeeId': coffeeId,
          'name': name,
          'description': description,
          'composition': composition,
          'moreInfo': moreInfo,
          'videoUrl': videoUrl,
          'imageUrl': imageUrl,
        },
      );

  /// Delete coffee
  _i2.Future<bool> deleteCoffee(
    String username,
    String password,
    int coffeeId,
  ) =>
      caller.callServerEndpoint<bool>(
        'admin',
        'deleteCoffee',
        {
          'username': username,
          'password': password,
          'coffeeId': coffeeId,
        },
      );

  /// ========== QR Code Management ==========
  /// Assign QR code to coffee
  _i2.Future<_i4.QRCodeMapping?> assignQRCode(
    String username,
    String password,
    String qrCode,
    int coffeeId,
  ) =>
      caller.callServerEndpoint<_i4.QRCodeMapping?>(
        'admin',
        'assignQRCode',
        {
          'username': username,
          'password': password,
          'qrCode': qrCode,
          'coffeeId': coffeeId,
        },
      );

  /// Get all QR code mappings
  _i2.Future<List<_i4.QRCodeMapping>> getAllQRMappings(
    String username,
    String password,
  ) =>
      caller.callServerEndpoint<List<_i4.QRCodeMapping>>(
        'admin',
        'getAllQRMappings',
        {
          'username': username,
          'password': password,
        },
      );

  /// Delete QR code mapping
  _i2.Future<bool> deleteQRMapping(
    String username,
    String password,
    int mappingId,
  ) =>
      caller.callServerEndpoint<bool>(
        'admin',
        'deleteQRMapping',
        {
          'username': username,
          'password': password,
          'mappingId': mappingId,
        },
      );

  /// ========== User Management ==========
  /// Get available user roles
  _i2.Future<List<String>> getRoles(
    String username,
    String password,
  ) =>
      caller.callServerEndpoint<List<String>>(
        'admin',
        'getRoles',
        {
          'username': username,
          'password': password,
        },
      );

  /// Get current user's role
  _i2.Future<String?> getCurrentUserRole(
    String username,
    String password,
  ) =>
      caller.callServerEndpoint<String?>(
        'admin',
        'getCurrentUserRole',
        {
          'username': username,
          'password': password,
        },
      );

  /// Create new admin user
  _i2.Future<_i5.AppUser?> createUser(
    String adminUsername,
    String adminPassword,
    String newUsername,
    String newPassword,
    String email,
    String role,
  ) =>
      caller.callServerEndpoint<_i5.AppUser?>(
        'admin',
        'createUser',
        {
          'adminUsername': adminUsername,
          'adminPassword': adminPassword,
          'newUsername': newUsername,
          'newPassword': newPassword,
          'email': email,
          'role': role,
        },
      );

  /// Get all users
  _i2.Future<List<_i5.AppUser>> getAllUsers(
    String username,
    String password,
  ) =>
      caller.callServerEndpoint<List<_i5.AppUser>>(
        'admin',
        'getAllUsers',
        {
          'username': username,
          'password': password,
        },
      );

  /// Update user
  _i2.Future<_i5.AppUser?> updateUser(
    String adminUsername,
    String adminPassword,
    int userId,
    String? email,
    String? role,
    String? newPassword,
  ) =>
      caller.callServerEndpoint<_i5.AppUser?>(
        'admin',
        'updateUser',
        {
          'adminUsername': adminUsername,
          'adminPassword': adminPassword,
          'userId': userId,
          'email': email,
          'role': role,
          'newPassword': newPassword,
        },
      );

  /// Delete user
  _i2.Future<bool> deleteUser(
    String adminUsername,
    String adminPassword,
    int userId,
  ) =>
      caller.callServerEndpoint<bool>(
        'admin',
        'deleteUser',
        {
          'adminUsername': adminUsername,
          'adminPassword': adminPassword,
          'userId': userId,
        },
      );

  /// Toggle user active status
  _i2.Future<_i5.AppUser?> toggleUserActive(
    String adminUsername,
    String adminPassword,
    int userId,
  ) =>
      caller.callServerEndpoint<_i5.AppUser?>(
        'admin',
        'toggleUserActive',
        {
          'adminUsername': adminUsername,
          'adminPassword': adminPassword,
          'userId': userId,
        },
      );

  /// Login and verify credentials
  _i2.Future<_i5.AppUser?> login(
    String username,
    String password,
  ) =>
      caller.callServerEndpoint<_i5.AppUser?>(
        'admin',
        'login',
        {
          'username': username,
          'password': password,
        },
      );

  /// ========== File Upload ==========
  /// Upload a file (base64 encoded)
  _i2.Future<String?> uploadFileBase64(
    String username,
    String password,
    String fileName,
    String fileDataBase64,
    String fileType,
  ) =>
      caller.callServerEndpoint<String?>(
        'admin',
        'uploadFileBase64',
        {
          'username': username,
          'password': password,
          'fileName': fileName,
          'fileDataBase64': fileDataBase64,
          'fileType': fileType,
        },
      );

  /// Get all uploaded media files
  _i2.Future<List<_i6.MediaFile>> getAllMedia(
    String username,
    String password,
  ) =>
      caller.callServerEndpoint<List<_i6.MediaFile>>(
        'admin',
        'getAllMedia',
        {
          'username': username,
          'password': password,
        },
      );

  /// Delete a media file
  _i2.Future<bool> deleteMedia(
    String username,
    String password,
    int mediaId,
  ) =>
      caller.callServerEndpoint<bool>(
        'admin',
        'deleteMedia',
        {
          'username': username,
          'password': password,
          'mediaId': mediaId,
        },
      );
}

/// Endpoint for coffee-related operations (mobile app)
/// {@category Endpoint}
class EndpointCoffee extends _i1.EndpointRef {
  EndpointCoffee(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'coffee';

  /// Get coffee by QR code
  _i2.Future<_i3.Coffee?> getCoffeeByQR(String qrCode) =>
      caller.callServerEndpoint<_i3.Coffee?>(
        'coffee',
        'getCoffeeByQR',
        {'qrCode': qrCode},
      );

  /// Get all active coffees
  _i2.Future<List<_i3.Coffee>> getAllCoffees() =>
      caller.callServerEndpoint<List<_i3.Coffee>>(
        'coffee',
        'getAllCoffees',
        {},
      );

  /// Get coffee detail by ID
  _i2.Future<_i3.Coffee?> getCoffeeDetail(int coffeeId) =>
      caller.callServerEndpoint<_i3.Coffee?>(
        'coffee',
        'getCoffeeDetail',
        {'coffeeId': coffeeId},
      );

  /// Create new coffee
  _i2.Future<_i3.Coffee> createCoffee(_i3.Coffee coffee) =>
      caller.callServerEndpoint<_i3.Coffee>(
        'coffee',
        'createCoffee',
        {'coffee': coffee},
      );

  /// Update coffee
  _i2.Future<_i3.Coffee> updateCoffee(_i3.Coffee coffee) =>
      caller.callServerEndpoint<_i3.Coffee>(
        'coffee',
        'updateCoffee',
        {'coffee': coffee},
      );

  /// Delete coffee
  _i2.Future<bool> deleteCoffee(int coffeeId) =>
      caller.callServerEndpoint<bool>(
        'coffee',
        'deleteCoffee',
        {'coffeeId': coffeeId},
      );

  /// Get all QR codes
  _i2.Future<List<_i4.QRCodeMapping>> getAllQRCodes() =>
      caller.callServerEndpoint<List<_i4.QRCodeMapping>>(
        'coffee',
        'getAllQRCodes',
        {},
      );

  /// Create QR code
  _i2.Future<_i4.QRCodeMapping> createQRCode(_i4.QRCodeMapping qrCode) =>
      caller.callServerEndpoint<_i4.QRCodeMapping>(
        'coffee',
        'createQRCode',
        {'qrCode': qrCode},
      );

  /// Delete QR code
  _i2.Future<bool> deleteQRCode(int qrId) => caller.callServerEndpoint<bool>(
        'coffee',
        'deleteQRCode',
        {'qrId': qrId},
      );
}

/// Endpoint for file uploads
/// {@category Endpoint}
class EndpointUpload extends _i1.EndpointRef {
  EndpointUpload(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'upload';

  /// Upload a file (image or video)
  _i2.Future<String?> uploadFile(
    String fileName,
    List<int> fileData,
    String fileType,
  ) =>
      caller.callServerEndpoint<String?>(
        'upload',
        'uploadFile',
        {
          'fileName': fileName,
          'fileData': fileData,
          'fileType': fileType,
        },
      );

  /// Delete uploaded file
  _i2.Future<bool> deleteFile(String fileUrl) =>
      caller.callServerEndpoint<bool>(
        'upload',
        'deleteFile',
        {'fileUrl': fileUrl},
      );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _i1.EndpointRef {
  EndpointGreeting(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _i2.Future<_i7.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i7.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    _i1.AuthenticationKeyManager? authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )? onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
          host,
          _i8.Protocol(),
          securityContext: securityContext,
          authenticationKeyManager: authenticationKeyManager,
          streamingConnectionTimeout: streamingConnectionTimeout,
          connectionTimeout: connectionTimeout,
          onFailedCall: onFailedCall,
          onSucceededCall: onSucceededCall,
          disconnectStreamsOnLostInternetConnection:
              disconnectStreamsOnLostInternetConnection,
        ) {
    admin = EndpointAdmin(this);
    coffee = EndpointCoffee(this);
    upload = EndpointUpload(this);
    greeting = EndpointGreeting(this);
  }

  late final EndpointAdmin admin;

  late final EndpointCoffee coffee;

  late final EndpointUpload upload;

  late final EndpointGreeting greeting;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'admin': admin,
        'coffee': coffee,
        'upload': upload,
        'greeting': greeting,
      };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {};
}
