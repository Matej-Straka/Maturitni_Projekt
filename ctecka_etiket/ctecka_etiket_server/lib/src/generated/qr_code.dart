/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class QRCodeMapping
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = QRCodeMappingTable();

  static const db = QRCodeMappingRepository._();

  @override
  int? id;

  /// The actual QR code string/value
  String qrCode;

  /// Foreign key to Coffee
  int coffeeId;

  /// Creation timestamp
  DateTime? createdAt;

  /// Whether this QR code is active
  bool isActive;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'qrCode': qrCode,
      'coffeeId': coffeeId,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      'isActive': isActive,
    };
  }

  static QRCodeMappingInclude include() {
    return QRCodeMappingInclude._();
  }

  static QRCodeMappingIncludeList includeList({
    _i1.WhereExpressionBuilder<QRCodeMappingTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<QRCodeMappingTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<QRCodeMappingTable>? orderByList,
    QRCodeMappingInclude? include,
  }) {
    return QRCodeMappingIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(QRCodeMapping.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(QRCodeMapping.t),
      include: include,
    );
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

class QRCodeMappingTable extends _i1.Table<int?> {
  QRCodeMappingTable({super.tableRelation})
      : super(tableName: 'qr_code_mapping') {
    qrCode = _i1.ColumnString(
      'qrCode',
      this,
    );
    coffeeId = _i1.ColumnInt(
      'coffeeId',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    isActive = _i1.ColumnBool(
      'isActive',
      this,
    );
  }

  /// The actual QR code string/value
  late final _i1.ColumnString qrCode;

  /// Foreign key to Coffee
  late final _i1.ColumnInt coffeeId;

  /// Creation timestamp
  late final _i1.ColumnDateTime createdAt;

  /// Whether this QR code is active
  late final _i1.ColumnBool isActive;

  @override
  List<_i1.Column> get columns => [
        id,
        qrCode,
        coffeeId,
        createdAt,
        isActive,
      ];
}

class QRCodeMappingInclude extends _i1.IncludeObject {
  QRCodeMappingInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => QRCodeMapping.t;
}

class QRCodeMappingIncludeList extends _i1.IncludeList {
  QRCodeMappingIncludeList._({
    _i1.WhereExpressionBuilder<QRCodeMappingTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(QRCodeMapping.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => QRCodeMapping.t;
}

class QRCodeMappingRepository {
  const QRCodeMappingRepository._();

  /// Returns a list of [QRCodeMapping]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<QRCodeMapping>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<QRCodeMappingTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<QRCodeMappingTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<QRCodeMappingTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<QRCodeMapping>(
      where: where?.call(QRCodeMapping.t),
      orderBy: orderBy?.call(QRCodeMapping.t),
      orderByList: orderByList?.call(QRCodeMapping.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [QRCodeMapping] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<QRCodeMapping?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<QRCodeMappingTable>? where,
    int? offset,
    _i1.OrderByBuilder<QRCodeMappingTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<QRCodeMappingTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<QRCodeMapping>(
      where: where?.call(QRCodeMapping.t),
      orderBy: orderBy?.call(QRCodeMapping.t),
      orderByList: orderByList?.call(QRCodeMapping.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [QRCodeMapping] by its [id] or null if no such row exists.
  Future<QRCodeMapping?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<QRCodeMapping>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [QRCodeMapping]s in the list and returns the inserted rows.
  ///
  /// The returned [QRCodeMapping]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<QRCodeMapping>> insert(
    _i1.Session session,
    List<QRCodeMapping> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<QRCodeMapping>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [QRCodeMapping] and returns the inserted row.
  ///
  /// The returned [QRCodeMapping] will have its `id` field set.
  Future<QRCodeMapping> insertRow(
    _i1.Session session,
    QRCodeMapping row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<QRCodeMapping>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [QRCodeMapping]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<QRCodeMapping>> update(
    _i1.Session session,
    List<QRCodeMapping> rows, {
    _i1.ColumnSelections<QRCodeMappingTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<QRCodeMapping>(
      rows,
      columns: columns?.call(QRCodeMapping.t),
      transaction: transaction,
    );
  }

  /// Updates a single [QRCodeMapping]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<QRCodeMapping> updateRow(
    _i1.Session session,
    QRCodeMapping row, {
    _i1.ColumnSelections<QRCodeMappingTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<QRCodeMapping>(
      row,
      columns: columns?.call(QRCodeMapping.t),
      transaction: transaction,
    );
  }

  /// Deletes all [QRCodeMapping]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<QRCodeMapping>> delete(
    _i1.Session session,
    List<QRCodeMapping> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<QRCodeMapping>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [QRCodeMapping].
  Future<QRCodeMapping> deleteRow(
    _i1.Session session,
    QRCodeMapping row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<QRCodeMapping>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<QRCodeMapping>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<QRCodeMappingTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<QRCodeMapping>(
      where: where(QRCodeMapping.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<QRCodeMappingTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<QRCodeMapping>(
      where: where?.call(QRCodeMapping.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
