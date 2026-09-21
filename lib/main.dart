import 'package:flutter/material.dart';
import 'models/product.dart'; // Import model & dummyProducts dari Pertemuan 2
import 'widgets/product_card.dart'; // Import widget ProductCard dari Pertemuan 3

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TokoKita',
      debugShowCheckedModeBanner: false, // Menghilangkan banner DEBUG di pojok kanan atas
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TokoKita'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        itemCount: dummyProducts.length,
        itemBuilder: (context, index) {
          // Memanggil ProductCard untuk setiap item di dummyProducts
          return ProductCard(product: dummyProducts[index]);
        },
      ),
    );
  }
}