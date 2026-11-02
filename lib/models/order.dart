
import 'dart:convert';

class Order {
  final int? id;
  final String tanggal;
  final List<Map<String, dynamic>> daftarItem;
  final double totalHarga;
  final String status;

  Order({
    this.id,
    required this.tanggal,
    required this.daftarItem,
    required this.totalHarga,
    required this.status,
  });

  // Mengubah object Order menjadi Map untuk SQLite.
  Map<String, Object?> toMap() {
    final Map<String, Object?> data = {
      'tanggal': tanggal,
      'daftarItem': jsonEncode(daftarItem),
      'totalHarga': totalHarga,
      'status': status,
    };

    if (id != null) {
      data['id'] = id;
    }

    return data;
  }

  // Mengubah data Map dari SQLite menjadi object Order.
  factory Order.fromMap(Map<String, Object?> map) {
    final List<dynamic> decodedItems =
        jsonDecode(map['daftarItem'] as String) as List<dynamic>;

    return Order(
      id: map['id'] as int,
      tanggal: map['tanggal'] as String,
      daftarItem: decodedItems.map((item) {
        return Map<String, dynamic>.from(item as Map);
      }).toList(),
      totalHarga: (map['totalHarga'] as num).toDouble(),
      status: map['status'] as String,
    );
  }
}
