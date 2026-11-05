import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/order.dart';

class OrderDatabase {
  static final OrderDatabase instance = OrderDatabase._init();

  static Database? _database;

  OrderDatabase._init();

  // Mengakses database yang sudah tersedia.
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('tokokita.db');

    return _database!;
  }

  // Membuka atau membuat database.
  Future<Database> _initDB(String fileName) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Membuat tabel orders.
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tanggal TEXT NOT NULL,
        daftarItem TEXT NOT NULL,
        totalHarga REAL NOT NULL,
        status TEXT NOT NULL
      )
    ''');
  }

  // CREATE: Menyimpan pesanan baru.
  Future<int> insertOrder(Order order) async {
    final db = await instance.database;

    return await db.insert(
      'orders',
      order.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  // READ: Mengambil seluruh riwayat pesanan.
  // Filter status menggunakan SQL WHERE.
  Future<List<Order>> getAllOrders({String? status}) async {
    final db = await instance.database;

    final normalizedStatus = status?.trim();
    final bool hasFilter =
        normalizedStatus != null && normalizedStatus.isNotEmpty;

    final List<Map<String, Object?>> result = await db.query(
      'orders',
      where: hasFilter ? 'status LIKE ?' : null,
      whereArgs: hasFilter ? ['%$normalizedStatus%'] : null,
      orderBy: 'tanggal DESC',
    );

    return result.map((map) => Order.fromMap(map)).toList();
  }

  // UPDATE: Mengubah status pesanan.
  Future<int> updateOrderStatus({
    required int id,
    required String status,
  }) async {
    final db = await instance.database;

    return await db.update(
      'orders',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE: Menghapus riwayat pesanan.
  Future<int> deleteOrder(int id) async {
    final db = await instance.database;

    return await db.delete('orders', where: 'id = ?', whereArgs: [id]);
  }
}
