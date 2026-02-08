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

abstract class QRCodeMapping implements _i1.SerializableModel {
  QRCodeMapping._({
    this.id,
    required this.qrCode,
    required this.coffeeId,
    this.createdAt,
    required this.isActive,
  });

  factory QRCodeMapping({
    int? id,
    required String qrCode,
    required int coffeeId,
    DateTime? createdAt,
    required bool isActive,
  }) = _QRCodeMappingImpl;

  factory QRCodeMapping.fromJson(Map<String, dynamic> jsonSerialization) {
    return QRCodeMapping(
      id: jsonSerialization['id'] as int?,
      qrCode: jsonSerialization['qrCode'] as String,
      coffeeId: jsonSerialization['coffeeId'] as int,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      isActive: jsonSerialization['isActive'] as bool,
    );
  }

  /// Unique identifier
  int? id;

  /// The actual QR code string/value
  String qrCode;

  /// Foreign key to Coffee
  int coffeeId;

  /// Creation timestamp
  DateTime? createdAt;

  /// Whether this QR code is active
  bool isActive;

  /// Returns a shallow copy of this [QRCodeMapping]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  QRCodeMapping copyWith({
    int? id,
    String? qrCode,
    int? coffeeId,
    DateTime? createdAt,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'qrCode': qrCode,
      'coffeeId': coffeeId,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      'isActive': isActive,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _QRCodeMappingImpl extends QRCodeMapping {
  _QRCodeMappingImpl({
    int? id,
    required String qrCode,
    required int coffeeId,
    DateTime? createdAt,
    required bool isActive,
  }) : super._(
          id: id,
          qrCode: qrCode,
          coffeeId: coffeeId,
          createdAt: createdAt,
          isActive: isActive,
        );

  /// Returns a shallow copy of this [QRCodeMapping]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  QRCodeMapping copyWith({
    Object? id = _Undefined,
    String? qrCode,
    int? coffeeId,
    Object? createdAt = _Undefined,
    bool? isActive,
  }) {
    return QRCodeMapping(
      id: id is int? ? id : this.id,
      qrCode: qrCode ?? this.qrCode,
      coffeeId: coffeeId ?? this.coffeeId,
      createdAt: createdAt is DateTime? ? createdAt : this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
