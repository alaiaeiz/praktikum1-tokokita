import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/wishlist_controller.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/product_card.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final WishlistController wishlistController = Get.find<WishlistController>();

  final ProductService productService = ProductService();

  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();

    futureProducts = productService.fetchProducts();
  }

  void _reloadProducts() {
    setState(() {
      futureProducts = productService.fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wishlist Saya',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),

      body: Obx(() {
        if (!wishlistController.isLoaded.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (wishlistController.favoriteIds.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 72, color: Colors.grey),
                SizedBox(height: 12),
                Text(
                  'Wishlist kamu masih kosong.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 6),
                Text(
                  'Tekan ikon hati pada produk untuk menyimpannya.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return FutureBuilder<List<Product>>(
          future: futureProducts,

          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Gagal memuat produk wishlist. '
                        'Periksa koneksi internet kamu.',
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 12),

                      ElevatedButton.icon(
                        onPressed: _reloadProducts,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final List<Product> products = snapshot.data ?? <Product>[];

            final List<Product> favoriteProducts = products.where((product) {
              return wishlistController.favoriteIds.contains(product.id);
            }).toList();

            if (favoriteProducts.isEmpty) {
              return const Center(
                child: Text('Produk favorit tidak ditemukan.'),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),

              itemCount: favoriteProducts.length,

              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),

              itemBuilder: (context, index) {
                return ProductCard(product: favoriteProducts[index]);
              },
            );
          },
        );
      }),
    );
  }
}
