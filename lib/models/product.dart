import 'package:intl/intl.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final String category;
  final int stock;
  final String? description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.stock,
    this.description,
  });

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
    required this.discount,
  });

  double get discountedPrice => price - (price * discount / 100);
}

String formatRupiah(double amount) {
  final formatCurrency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  return formatCurrency.format(amount);
}