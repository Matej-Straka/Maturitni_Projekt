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

abstract class Coffee implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = CoffeeTable();

  static const db = CoffeeRepository._();

  @override
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

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static CoffeeInclude include() {
    return CoffeeInclude._();
  }

  static CoffeeIncludeList includeList({
    _i1.WhereExpressionBuilder<CoffeeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CoffeeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CoffeeTable>? orderByList,
    CoffeeInclude? include,
  }) {
    return CoffeeIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Coffee.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Coffee.t),
      include: include,
    );
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

class CoffeeTable extends _i1.Table<int?> {
  CoffeeTable({super.tableRelation}) : super(tableName: 'coffee') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    composition = _i1.ColumnString(
      'composition',
      this,
    );
    moreInfo = _i1.ColumnString(
      'moreInfo',
      this,
    );
    videoUrl = _i1.ColumnString(
      'videoUrl',
      this,
    );
    imageUrl = _i1.ColumnString(
      'imageUrl',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  /// Name of the coffee blend
  late final _i1.ColumnString name;

  /// Short description shown in the info menu
  late final _i1.ColumnString description;

  /// Detailed composition/ingredients
  late final _i1.ColumnString composition;

  /// Extended information text
  late final _i1.ColumnString moreInfo;

  /// URL to the video (can be local path or remote URL)
  late final _i1.ColumnString videoUrl;

  /// URL to the product image
  late final _i1.ColumnString imageUrl;

  /// Creation timestamp
  late final _i1.ColumnDateTime createdAt;

  /// Last update timestamp
  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        description,
        composition,
        moreInfo,
        videoUrl,
        imageUrl,
        createdAt,
        updatedAt,
      ];
}

class CoffeeInclude extends _i1.IncludeObject {
  CoffeeInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Coffee.t;
}

class CoffeeIncludeList extends _i1.IncludeList {
  CoffeeIncludeList._({
    _i1.WhereExpressionBuilder<CoffeeTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Coffee.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Coffee.t;
}

class CoffeeRepository {
  const CoffeeRepository._();

  /// Returns a list of [Coffee]s matching the given query parameters.
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
  Future<List<Coffee>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CoffeeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CoffeeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CoffeeTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Coffee>(
      where: where?.call(Coffee.t),
      orderBy: orderBy?.call(Coffee.t),
      orderByList: orderByList?.call(Coffee.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Coffee] matching the given query parameters.
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
  Future<Coffee?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CoffeeTable>? where,
    int? offset,
    _i1.OrderByBuilder<CoffeeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CoffeeTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Coffee>(
      where: where?.call(Coffee.t),
      orderBy: orderBy?.call(Coffee.t),
      orderByList: orderByList?.call(Coffee.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Coffee] by its [id] or null if no such row exists.
  Future<Coffee?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Coffee>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Coffee]s in the list and returns the inserted rows.
  ///
  /// The returned [Coffee]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Coffee>> insert(
    _i1.Session session,
    List<Coffee> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Coffee>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Coffee] and returns the inserted row.
  ///
  /// The returned [Coffee] will have its `id` field set.
  Future<Coffee> insertRow(
    _i1.Session session,
    Coffee row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Coffee>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Coffee]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Coffee>> update(
    _i1.Session session,
    List<Coffee> rows, {
    _i1.ColumnSelections<CoffeeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Coffee>(
      rows,
      columns: columns?.call(Coffee.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Coffee]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Coffee> updateRow(
    _i1.Session session,
    Coffee row, {
    _i1.ColumnSelections<CoffeeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Coffee>(
      row,
      columns: columns?.call(Coffee.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Coffee]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Coffee>> delete(
    _i1.Session session,
    List<Coffee> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Coffee>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Coffee].
  Future<Coffee> deleteRow(
    _i1.Session session,
    Coffee row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Coffee>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Coffee>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CoffeeTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Coffee>(
      where: where(Coffee.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CoffeeTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Coffee>(
      where: where?.call(Coffee.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
