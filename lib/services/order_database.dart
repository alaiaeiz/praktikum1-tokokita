import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/order.dart';

class OrderDatabase {
  static final OrderDatabase instance = OrderDatabase._init();

  static Database? _database;

  OrderDatabase._init();

  // mengakses database yang sudah tersedia.
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('tokokita.db');

    return _database!;
  }

  // membuka atau membuat database.
  Future<Database> _initDB(String fileName) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, fileName);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  // membuat tabel orders untuk database baru.
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        uid TEXT,
        tanggal TEXT NOT NULL,
        daftarItem TEXT NOT NULL,
        totalHarga REAL NOT NULL,
        status TEXT NOT NULL
      )
    ''');
  }

  Future<void> _upgradeDB(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE orders
        ADD COLUMN uid TEXT
      ''');
    }
  }

  Future<int> insertOrder(Order order) async {
    final db = await instance.database;

    if (order.uid == null || order.uid!.isEmpty) {
      throw Exception('UID pengguna tidak boleh kosong.');
    }

    return await db.insert(
      'orders',
      order.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<List<Order>> getAllOrders({
    required String uid,
    String? status,
  }) async {
    final db = await instance.database;

    final List<String> conditions = ['uid = ?'];
    final List<Object?> arguments = [uid];

    final normalizedStatus = status?.trim();

    if (normalizedStatus != null && normalizedStatus.isNotEmpty) {
      conditions.add('status LIKE ?');
      arguments.add('%$normalizedStatus%');
    }

    final List<Map<String, Object?>> result = await db.query(
      'orders',
      where: conditions.join(' AND '),
      whereArgs: arguments,
      orderBy: 'tanggal DESC',
    );

    return result.map((map) => Order.fromMap(map)).toList();
  }

  // mengubah status hanya pada pesanan milik pengguna aktif.
  Future<int> updateOrderStatus({
    required int id,
    required String uid,
    required String status,
  }) async {
    final db = await instance.database;

    return await db.update(
      'orders',
      {'status': status},
      where: 'id = ? AND uid = ?',
      whereArgs: [id, uid],
    );
  }

  // menghapus hanya pesanan milik pengguna aktif.
  Future<int> deleteOrder({
    required int id,
    required String uid,
  }) async {
    final db = await instance.database;

    return await db.delete(
      'orders',
      where: 'id = ? AND uid = ?',
      whereArgs: [id, uid],
    );
  }
}