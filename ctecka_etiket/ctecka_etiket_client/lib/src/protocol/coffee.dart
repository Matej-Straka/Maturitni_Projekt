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

abstract class Coffee implements _i1.SerializableModel {
  Coffee._({
    this.id,
    required this.name,
    required this.description,
    required this.composition,
    required this.moreInfo,
    required this.videoUrl,
    required this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory Coffee({
    int? id,
    required String name,
    required String description,
    required String composition,
    required String moreInfo,
    required String videoUrl,
    required String imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CoffeeImpl;

  factory Coffee.fromJson(Map<String, dynamic> jsonSerialization) {
    return Coffee(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String,
      composition: jsonSerialization['composition'] as String,
      moreInfo: jsonSerialization['moreInfo'] as String,
      videoUrl: jsonSerialization['videoUrl'] as String,
      imageUrl: jsonSerialization['imageUrl'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// Unique identifier
  int? id;

  /// Name of the coffee blend
  String name;

  /// Short description shown in the info menu
  String description;

  /// Detailed composition/ingredients
  String composition;

  /// Extended information text
  String moreInfo;

  /// URL to the video (can be local path or remote URL)
  String videoUrl;

  /// URL to the product image
  String imageUrl;

  /// Creation timestamp
  DateTime? createdAt;

  /// Last update timestamp
  DateTime? updatedAt;

  /// Returns a shallow copy of this [Coffee]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Coffee copyWith({
    int? id,
    String? name,
    String? description,
    String? composition,
    String? moreInfo,
    String? videoUrl,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'composition': composition,
      'moreInfo': moreInfo,
      'videoUrl': videoUrl,
      'imageUrl': imageUrl,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CoffeeImpl extends Coffee {
  _CoffeeImpl({
    int? id,
    required String name,
    required String description,
    required String composition,
    required String moreInfo,
    required String videoUrl,
    required String imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
          id: id,
          name: name,
          description: description,
          composition: composition,
          moreInfo: moreInfo,
          videoUrl: videoUrl,
          imageUrl: imageUrl,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Returns a shallow copy of this [Coffee]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Coffee copyWith({
    Object? id = _Undefined,
    String? name,
    String? description,
    String? composition,
    String? moreInfo,
    String? videoUrl,
    String? imageUrl,
    Object? createdAt = _Undefined,
    Object? updatedAt = _Undefined,
  }) {
    return Coffee(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      composition: composition ?? this.composition,
      moreInfo: moreInfo ?? this.moreInfo,
      videoUrl: videoUrl ?? this.videoUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt is DateTime? ? createdAt : this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}
