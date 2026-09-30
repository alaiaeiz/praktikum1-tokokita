String formatRupiah(double nominal) => 'Rp${nominal.toInt()}';

class Product {
  int id;
  String name;
  double price;
  String category;
  int stock;
  String? imageUrl;
  String? description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.stock,
    this.imageUrl,
    this.description,
  });

  String getStatusStok() {
    if (stock > 10) return 'Tersedia';
    if (stock > 0 && stock <= 10) return 'Stok Terbatas';
    return 'Habis';
  }
}

class DiscountedProduct extends Product {
  double discount;

  DiscountedProduct({
    required super.id,
    required super.name,
    required super.price,
    required super.category,
    required super.stock,
    super.description,
    required this.discount,
  });
}

List dummyProducts = [
  DiscountedProduct(
    id: 1,
    name: 'Kemeja Flanel Elegan',
    price: 120000,
    category: 'Fashion',
    stock: 15,
    discount: 20.0,
    description: 'Bahan katun berkualitas tinggi.',
  ),
  Product(
    id: 2,
    name: 'Kaos Polos Premium',
    price: 50000,
    category: 'Fashion',
    stock: 5,
  ),
  Product(
    id: 3,
    name: 'Sepatu Sneakers Running',
    price: 250000,
    category: 'Fashion',
    stock: 0,
  ),
  DiscountedProduct(
    id: 4,
    name: 'Laptop Gaming RTX 4060',
    price: 15000000,
    category: 'Elektronik',
    stock: 2,
    discount: 10.0,
    description: 'Performa rata kanan.',
  ),
  Product(
    id: 5,
    name: 'Mouse Wireless Silent',
    price: 150000,
    category: 'Elektronik',
    stock: 20,
  ),
  DiscountedProduct(
    id: 6,
    name: 'Keripik Kentang Balado',
    price: 15000,
    category: 'Makanan',
    stock: 50,
    discount: 5.0,
  ),
  Product(
    id: 7,
    name: 'Cokelat Batang Dark 70%',
    price: 25000,
    category: 'Makanan',
    stock: 8,
  ),
  DiscountedProduct(
    id: 8,
    name: 'Headphone Bluetooth Bass',
    price: 350000,
    category: 'Elektronik',
    stock: 12,
    discount: 15.0,
  ),
  Product(
    id: 9,
    name: 'Jaket Denim Vintage',
    price: 210000,
    category: 'Fashion',
    stock: 11,
  ),
  Product(
    id: 10,
    name: 'Keyboard Mekanikal RGB',
    price: 450000,
    category: 'Elektronik',
    stock: 7,
  ),
  DiscountedProduct(
    id: 11,
    name: 'Kopi Arabika 250g',
    price: 65000,
    category: 'Makanan',
    stock: 30,
    discount: 10.0,
  ),
  Product(
    id: 12,
    name: 'Botol Minum Stainless 1L',
    price: 85000,
    category: 'Gaya Hidup',
    stock: 18,
  ),
  DiscountedProduct(
    id: 13,
    name: 'Smartwatch Sport Fit',
    price: 599000,
    category: 'Elektronik',
    stock: 4,
    discount: 25.0,
  ),
  Product(
    id: 14,
    name: 'Roti Tawar Gandum',
    price: 18000,
    category: 'Makanan',
    stock: 0,
  ),
  DiscountedProduct(
    id: 15,
    name: 'Tas Ransel Laptop Anti Air',
    price: 185000,
    category: 'Fashion',
    stock: 14,
    discount: 12.0,
  ),
];