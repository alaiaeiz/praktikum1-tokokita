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

List<Product> dummyProducts = [
  DiscountedProduct(
    id: 1,
    name: 'Kemeja Flanel Elegan',
    price: 120000,
    category: 'Fashion',
    stock: 15,
    discount: 20.0,
    description: 'Kemeja flanel bahan katun berkualitas tinggi, nyaman dipakai harian.',
  ),
  Product(
    id: 2,
    name: 'Kaos Polos Premium',
    price: 50000,
    category: 'Fashion',
    stock: 5,
    description: 'Kaos bahan Combed 30s adem dan menyerap keringat.',
  ),
  Product(
    id: 3,
    name: 'Sepatu Sneakers Running',
    price: 250000,
    category: 'Fashion',
    stock: 0,
    description: 'Sepatu lari ringan dengan bantalan empuk.',
  ),
  DiscountedProduct(
    id: 4,
    name: 'Laptop Gaming RTX 4060',
    price: 15000000,
    category: 'Elektronik',
    stock: 2,
    discount: 10.0,
    description: 'Laptop performa tinggi untuk gaming dan render video berat.',
  ),
  Product(
    id: 5,
    name: 'Mouse Wireless Silent',
    price: 150000,
    category: 'Elektronik',
    stock: 20,
    description: 'Mouse nirkabel tanpa suara klik, cocok untuk kerja di perpustakaan.',
  ),
  DiscountedProduct(
    id: 6,
    name: 'Keripik Kentang Balado',
    price: 15000,
    category: 'Makanan',
    stock: 50,
    discount: 5.0,
    description: 'Camilan keripik kentang renyah dengan bumbu balado asli.',
  ),
  Product(
    id: 7,
    name: 'Cokelat Batang Dark 70%',
    price: 25000,
    category: 'Makanan',
    stock: 8,
    description: 'Cokelat hitam premium kaya akan antioksidan.',
  ),
  DiscountedProduct(
    id: 8,
    name: 'Headphone Bluetooth Bass',
    price: 350000,
    category: 'Elektronik',
    stock: 12,
    discount: 15.0,
    description: 'Suara bass mantap dengan ketahanan baterai hingga 20 jam.',
  ),
];