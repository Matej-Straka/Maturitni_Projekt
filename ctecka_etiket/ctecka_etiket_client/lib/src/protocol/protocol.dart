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
import 'app_user.dart' as _i2;
import 'coffee.dart' as _i3;
import 'greeting.dart' as _i4;
import 'media_file.dart' as _i5;
import 'qr_code.dart' as _i6;
import 'package:ctecka_etiket_client/src/protocol/qr_code.dart' as _i7;
import 'package:ctecka_etiket_client/src/protocol/app_user.dart' as _i8;
import 'package:ctecka_etiket_client/src/protocol/media_file.dart' as _i9;
import 'package:ctecka_etiket_client/src/protocol/coffee.dart' as _i10;
export 'app_user.dart';
export 'coffee.dart';
export 'greeting.dart';
export 'media_file.dart';
export 'qr_code.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i2.AppUser) {
      return _i2.AppUser.fromJson(data) as T;
    }
    if (t == _i3.Coffee) {
      return _i3.Coffee.fromJson(data) as T;
    }
    if (t == _i4.Greeting) {
      return _i4.Greeting.fromJson(data) as T;
    }
    if (t == _i5.MediaFile) {
      return _i5.MediaFile.fromJson(data) as T;
    }
    if (t == _i6.QRCodeMapping) {
      return _i6.QRCodeMapping.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.AppUser?>()) {
      return (data != null ? _i2.AppUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.Coffee?>()) {
      return (data != null ? _i3.Coffee.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.Greeting?>()) {
      return (data != null ? _i4.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.MediaFile?>()) {
      return (data != null ? _i5.MediaFile.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.QRCodeMapping?>()) {
      return (data != null ? _i6.QRCodeMapping.fromJson(data) : null) as T;
    }
    if (t == List<_i7.QRCodeMapping>) {
      return (data as List)
          .map((e) => deserialize<_i7.QRCodeMapping>(e))
          .toList() as T;
    }
    if (t == List<_i8.AppUser>) {
      return (data as List).map((e) => deserialize<_i8.AppUser>(e)).toList()
          as T;
    }
    if (t == List<_i9.MediaFile>) {
      return (data as List).map((e) => deserialize<_i9.MediaFile>(e)).toList()
          as T;
    }
    if (t == List<_i10.Coffee>) {
      return (data as List).map((e) => deserialize<_i10.Coffee>(e)).toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i2.AppUser) {
      return 'AppUser';
    }
    if (data is _i3.Coffee) {
      return 'Coffee';
    }
    if (data is _i4.Greeting) {
      return 'Greeting';
    }
    if (data is _i5.MediaFile) {
      return 'MediaFile';
    }
    if (data is _i6.QRCodeMapping) {
      return 'QRCodeMapping';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AppUser') {
      return deserialize<_i2.AppUser>(data['data']);
    }
    if (dataClassName == 'Coffee') {
      return deserialize<_i3.Coffee>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i4.Greeting>(data['data']);
    }
    if (dataClassName == 'MediaFile') {
      return deserialize<_i5.MediaFile>(data['data']);
    }
    if (dataClassName == 'QRCodeMapping') {
      return deserialize<_i6.QRCodeMapping>(data['data']);
    }
    return super.deserializeByClassName(data);
  }
}
