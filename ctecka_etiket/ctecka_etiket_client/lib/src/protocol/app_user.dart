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

abstract class AppUser implements _i1.SerializableModel {
  AppUser._({
    this.id,
    required this.username,
    required this.passwordHash,
    required this.email,
    required this.role,
    required this.isActive,
    this.createdAt,
    this.lastLogin,
  });

  factory AppUser({
    int? id,
    required String username,
    required String passwordHash,
    required String email,
    required String role,
    required bool isActive,
    DateTime? createdAt,
    DateTime? lastLogin,
  }) = _AppUserImpl;

  factory AppUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppUser(
      id: jsonSerialization['id'] as int?,
      username: jsonSerialization['username'] as String,
      passwordHash: jsonSerialization['passwordHash'] as String,
      email: jsonSerialization['email'] as String,
      role: jsonSerialization['role'] as String,
      isActive: jsonSerialization['isActive'] as bool,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      lastLogin: jsonSerialization['lastLogin'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['lastLogin']),
    );
  }

  /// Unique identifier
  int? id;

  /// Username for login
  String username;

  /// Hashed password
  String passwordHash;

  /// Email address
  String email;

  /// User role (admin, editor)
  String role;

  /// Whether the user is active
  bool isActive;

  /// Creation timestamp
  DateTime? createdAt;

  /// Last login timestamp
  DateTime? lastLogin;

  /// Returns a shallow copy of this [AppUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AppUser copyWith({
    int? id,
    String? username,
    String? passwordHash,
    String? email,
    String? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastLogin,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'username': username,
      'passwordHash': passwordHash,
      'email': email,
      'role': role,
      'isActive': isActive,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (lastLogin != null) 'lastLogin': lastLogin?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppUserImpl extends AppUser {
  _AppUserImpl({
    int? id,
    required String username,
    required String passwordHash,
    required String email,
    required String role,
    required bool isActive,
    DateTime? createdAt,
    DateTime? lastLogin,
  }) : super._(
          id: id,
          username: username,
          passwordHash: passwordHash,
          email: email,
          role: role,
          isActive: isActive,
          createdAt: createdAt,
          lastLogin: lastLogin,
        );

  /// Returns a shallow copy of this [AppUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AppUser copyWith({
    Object? id = _Undefined,
    String? username,
    String? passwordHash,
    String? email,
    String? role,
    bool? isActive,
    Object? createdAt = _Undefined,
    Object? lastLogin = _Undefined,
  }) {
    return AppUser(
      id: id is int? ? id : this.id,
      username: username ?? this.username,
      passwordHash: passwordHash ?? this.passwordHash,
      email: email ?? this.email,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt is DateTime? ? createdAt : this.createdAt,
      lastLogin: lastLogin is DateTime? ? lastLogin : this.lastLogin,
    );
  }
}
