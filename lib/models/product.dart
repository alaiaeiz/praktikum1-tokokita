String cekStatusProduk(int stok) {
  if (stok > 10) {
    return 'Tersedia';
  } else if (stok > 0 && stok <= 10) {
    return 'Stok Terbatas';
  } else {
    return 'Habis';
  }
}

String formatRupiah(double nominal) => 'Rp${nominal.toInt()}';

double hitungDiskon(double harga, {double persenDiskon = 0.0}) {
  return harga - (harga * persenDiskon);
}

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
    required int id, 
    required String name, 
    required double price,       
    required String category,    
    required int stock,          
    String? description, 
    required this.discount
  }) : super(
          id: id, 
          name: name, 
          price: price,          
          category: category,    
          stock: stock,         
          description: description
        ); 
}

List<Product> dummyProducts = [
  Product(id: 1, name: 'Kemeja Flanel', price: 120000, category: 'Fashion', stock: 15, description: 'Nyaman dipakai.'),
  Product(id: 2, name: 'Kaos Polos', price: 50000, category: 'Fashion', stock: 5), // Tanpa description
  Product(id: 3, name: 'Sepatu Sneakers', price: 250000, category: 'Fashion', stock: 0),
  Product(id: 4, name: 'Laptop Gaming', price: 15000000, category: 'Elektronik', stock: 2, description: 'RTX 4060.'),
  Product(id: 5, name: 'Mouse Wireless', price: 150000, category: 'Elektronik', stock: 20),
  Product(id: 6, name: 'Keripik Kentang', price: 15000, category: 'Makanan', stock: 50, description: 'Rasa Balado.'),
  Product(id: 7, name: 'Cokelat Batang', price: 25000, category: 'Makanan', stock: 8),
  Product(id: 8, name: 'Headphone Bluetooth', price: 350000, category: 'Elektronik', stock: 12),
];

double hitungTotalBelanja(List<Product> keranjang) {
  double total = 0;
  for (var produk in keranjang) {
    total += produk.price;
  }
  return total;
}

void main() {
  // # LANGKAH 1
  print('Variabel & Tipe Data');
  
  const String namaToko = "TokoKita"; 
  final DateTime waktuAkses = DateTime.now();
  var namaKasir = "Budi";
  
  int stok = 50;
  double harga = 150000.0;
  String namaProduk = "Sepatu Sneakers";
  bool statusTersedia = true;

  print('Nama Toko (const): $namaToko');
  print('Nama Produk: $namaProduk');
  print('Harga: Rp$harga');
  print('Stok: $stok');
  print('Status Tersedia: $statusTersedia\n');

  List<String> kategoriProduk = ['Elektronik', 'Fashion', 'Makanan'];
  Map<String, dynamic> dataMentahProduk = {
    'id': 1,
    'nama': namaProduk,
    'harga': harga,
    'stok': stok,
    'kategori': kategoriProduk[1]
  };

  print('Daftar Kategori: $kategoriProduk');
  print('Data Mentah Produk: $dataMentahProduk\n');

  // # LANGKAH 2
  print('Operator Perhitungan');

  int jumlahBeli = 3;
  double totalHarga = harga * jumlahBeli;
  int sisaStok = stok - jumlahBeli;
  int sisaBagiStok = stok % 3; 

  print('Total harga untuk $jumlahBeli item: Rp$totalHarga');
  print('Sisa stok setelah pembelian: $sisaStok');
  print('Sisa bagi stok jika dibagi 3: $sisaBagiStok\n');

  double hargaBatas = 100000.0;
  print('Apakah harga lebih besar dari Rp100.000? ${harga > hargaBatas}');
  print('Apakah stok habis (0)? ${stok == 0}');
  print('Apakah sisa stok >= 10? ${sisaStok >= 10}\n');

  bool layakTampil = (stok > 0) && (harga > 0);
  bool produkGratisAtauHabis = (harga == 0) || (stok == 0);
  bool tidakTersedia = !statusTersedia;

  print('Apakah produk layak ditampilkan? $layakTampil');
  print('Apakah produk gratis atau habis? $produkGratisAtauHabis');
  print('Kebalikan dari status tersedia: $tidakTersedia\n');

  // # LANGKAH 3
  print('Control Flow ');

  int stokBarang = 5;
  print('Status produk: ${cekStatusProduk(stokBarang)}');

  List<double> keranjang = [50000.0, 150000.0, 20000.0];
  double total = 0;
  for (double hargaItem in keranjang) { 
    total += hargaItem; 
  }
  print('Total belanja: Rp$total');

  int stokWhile = 3; 
  while (stokWhile > 0) {
    print('Terjual 1, sisa stok: $stokWhile');
    stokWhile--; 
  }

  String kategori = 'Fashion';
  double diskon;
  switch (kategori) {
    case 'Elektronik': diskon = 10; break;
    case 'Fashion': diskon = 15; break;
    default: diskon = 0;
  }
  print('Diskon kategori $kategori: $diskon%\n');

  // # LANGKAH 4
  print('Function');
  
  double hargaAwal = 100000.0;
  double hargaPromo = hitungDiskon(hargaAwal, persenDiskon: 0.2);
  print('Harga promo: ${formatRupiah(hargaPromo)}');

  double hargaNormal = hitungDiskon(hargaAwal);
  print('Harga normal: ${formatRupiah(hargaNormal)}\n');

  // # LANGKAH 5
  print('Class & Object');
  
  Product barang1 = Product(
    id: 1, 
    name: 'Baju',
    price: 100000,
    category: 'Fashion',
    stock: 10
  );
  print('Objek 1: ${barang1.name}, Deskripsi: ${barang1.description}');

  DiscountedProduct barang2 = DiscountedProduct(
    id: 2, 
    name: 'Celana', 
    price: 150000,
    category: 'Fashion',
    stock: 5,
    discount: 50.0,
    description: 'Diskon cuci gudang'
  );
  print('Objek 2: ${barang2.name}, Diskon: ${barang2.discount}%, Info: ${barang2.description}\n');

  // Product produkError = Product(
  //   id: 3, 
  //   name: null, 
  // );
}