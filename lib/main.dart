
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'services/order_database.dart';

import 'screens/main_page.dart';
import 'screens/product_detail_page.dart';
import 'screens/cart_page.dart';
import 'screens/profile_page.dart';
import 'screens/checkout_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi SQLite FFI untuk Windows dan Linux.
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Memastikan database dan tabel orders dibuat.
  await OrderDatabase.instance.database;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TokoKita',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const MainPage(),
        ),
        GetPage(
          name: '/detail',
          page: () => const ProductDetailPage(),
        ),
        GetPage(
          name: '/cart',
          page: () => const CartPage(),
        ),
        GetPage(
          name: '/profile',
          page: () => const ProfilePage(),
        ),
        GetPage(
          name: '/checkout',
          page: () => const CheckoutPage(),
        ),
      ],
    );
  }
}
