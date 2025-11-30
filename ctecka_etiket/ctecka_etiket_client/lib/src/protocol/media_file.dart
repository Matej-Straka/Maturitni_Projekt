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

abstract class MediaFile implements _i1.SerializableModel {
  MediaFile._({
    this.id,
    required this.url,
    required this.fileName,
    required this.fileType,
    required this.mimeType,
    required this.fileSize,
    DateTime? uploadedAt,
    required this.uploadedBy,
  }) : uploadedAt = uploadedAt ?? DateTime.now();

  factory MediaFile({
    int? id,
    required String url,
    required String fileName,
    required String fileType,
    required String mimeType,
    required int fileSize,
    DateTime? uploadedAt,
    required String uploadedBy,
  }) = _MediaFileImpl;

  factory MediaFile.fromJson(Map<String, dynamic> jsonSerialization) {
    return MediaFile(
      id: jsonSerialization['id'] as int?,
      url: jsonSerialization['url'] as String,
      fileName: jsonSerialization['fileName'] as String,
      fileType: jsonSerialization['fileType'] as String,
      mimeType: jsonSerialization['mimeType'] as String,
      fileSize: jsonSerialization['fileSize'] as int,
      uploadedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['uploadedAt']),
      uploadedBy: jsonSerialization['uploadedBy'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String url;

  String fileName;

  String fileType;

  String mimeType;

  int fileSize;

  DateTime uploadedAt;

  String uploadedBy;

  /// Returns a shallow copy of this [MediaFile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MediaFile copyWith({
    int? id,
    String? url,
    String? fileName,
    String? fileType,
    String? mimeType,
    int? fileSize,
    DateTime? uploadedAt,
    String? uploadedBy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'url': url,
      'fileName': fileName,
      'fileType': fileType,
      'mimeType': mimeType,
      'fileSize': fileSize,
      'uploadedAt': uploadedAt.toJson(),
      'uploadedBy': uploadedBy,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MediaFileImpl extends MediaFile {
  _MediaFileImpl({
    int? id,
    required String url,
    required String fileName,
    required String fileType,
    required String mimeType,
    required int fileSize,
    DateTime? uploadedAt,
    required String uploadedBy,
  }) : super._(
          id: id,
          url: url,
          fileName: fileName,
          fileType: fileType,
          mimeType: mimeType,
          fileSize: fileSize,
          uploadedAt: uploadedAt,
          uploadedBy: uploadedBy,
        );

  /// Returns a shallow copy of this [MediaFile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MediaFile copyWith({
    Object? id = _Undefined,
    String? url,
    String? fileName,
    String? fileType,
    String? mimeType,
    int? fileSize,
    DateTime? uploadedAt,
    String? uploadedBy,
  }) {
    return MediaFile(
      id: id is int? ? id : this.id,
      url: url ?? this.url,
      fileName: fileName ?? this.fileName,
      fileType: fileType ?? this.fileType,
      mimeType: mimeType ?? this.mimeType,
      fileSize: fileSize ?? this.fileSize,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      uploadedBy: uploadedBy ?? this.uploadedBy,
    );
  }
}
