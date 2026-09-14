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
  String? description;

  Product({required this.id, required this.name, this.description});
}

class DiscountedProduct extends Product {
  double discount; 

  DiscountedProduct({
    required int id, 
    required String name, 
    String? description, 
    required this.discount
  }) : super(id: id, name: name, description: description); 
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
  
  Product barang1 = Product(id: 1, name: 'Baju');
  print('Objek 1: ${barang1.name}, Deskripsi: ${barang1.description}');

  DiscountedProduct barang2 = DiscountedProduct(
    id: 2, 
    name: 'Celana', 
    discount: 50.0,
    description: 'Diskon cuci gudang'
  );
  print('Objek 2: ${barang2.name}, Diskon: ${barang2.discount}%, Info: ${barang2.description}\n');

  // Product produkError = Product(
  //   id: 3, 
  //   name: null, 
  // );
}