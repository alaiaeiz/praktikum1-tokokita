import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  static const String baseUrl = 'https://fakestoreapi.com/products';

  Future<List<Product>> fetchProducts() async {
    try {
      print('Mengirim HTTP GET ke $baseUrl...');
      final response = await http.get(Uri.parse(baseUrl));

      print('Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Product> products = body.map((dynamic item) => Product.fromJson(item)).toList();
        return products;
      } else {
        throw Exception('Gagal memuat produk dari server (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Koneksi internet bermasalah atau gagal terhubung ke server.');
    }
  }

  Future<Product> fetchProductDetail(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat detail produk (Status: ${response.statusCode})');
    }
  }
}