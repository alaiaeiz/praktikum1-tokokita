import 'package:intl/intl.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final String category;
  final int stock;
  final String? description;
  final String? imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.stock,
    this.description,
    this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['title'] ?? 'Tanpa Nama',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] ?? 'Umum',
      stock: 10,
      description: json['description'] ?? 'Tidak ada deskripsi',
      imageUrl: json['image'],
    );
  }

  String getStatusStok() {
    return stock > 0 ? 'Stok: $stock' : 'Habis';
  }
}

class DiscountedProduct extends Product {
  final double discount;

  DiscountedProduct({
    required super.id,
    required super.name,
    required super.price,
    required super.category,
    required super.stock,
    super.description,
    super.imageUrl,
    required this.discount,
  });

  double get discountedPrice => price - (price * discount / 100);
}

// Fungsi pembantu format Rupiah
String formatRupiah(double amount) {
  return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
}