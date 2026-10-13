import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Product> dummyProducts = [
      Product(
        id: '1',
        name: 'Laptop ASUS ROG',
        price: 15000000,
        category: 'Elektronik',
        stock: 5,
        description: 'Laptop gaming performa tinggi dengan prosesor terkini dan kartu grafis mumpuni untuk kebutuhan gaming serta rendering berat.',
      ),
      DiscountedProduct(
        id: '2',
        name: 'Smartphone Samsung',
        price: 4500000,
        category: 'Elektronik',
        stock: 10,
        discount: 10,
        description: 'Smartphone layar AMOLED jernih dengan baterai tahan lama dan kamera beresolusi tinggi.',
      ),
      Product(
        id: '3',
        name: 'Sepatu Running Nike',
        price: 1200000,
        category: 'Olahraga',
        stock: 0,
        description: 'Sepatu lari yang ringan dan nyaman digunakan untuk olahraga sehari-hari.',
      ),
      DiscountedProduct(
        id: '4',
        name: 'Kemeja Flanel Casual',
        price: 250000,
        category: 'Pakaian',
        stock: 15,
        discount: 15,
        description: 'Kemeja flanel bahan lembut, adem, dan cocok untuk gaya kasual sehari-hari.',
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('TokoKita', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar Awal
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari produk di TokoKita...',
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Banner Promosi
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade600, Colors.blue.shade400],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Promo Spesial Praktikum!',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Dapatkan diskon menarik untuk berbagai produk elektronik.',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Daftar Produk',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              // Grid Produk Original
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dummyProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) {
                  return ProductCard(product: dummyProducts[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}