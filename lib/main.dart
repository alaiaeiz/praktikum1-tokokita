import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'firebase_options.dart';
import 'services/order_database.dart';

import 'screens/main_page.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/product_detail_page.dart';
import 'screens/cart_page.dart';
import 'screens/profile_page.dart';
import 'screens/checkout_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Inisialisasi SQLite FFI untuk Windows dan Linux.
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Memastikan database SQLite tersedia.
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),

      initialRoute: '/',

      getPages: [
        // Authentication gate.
        GetPage(name: '/', page: () => const AuthGate()),

        // Authentication pages.
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/register', page: () => const RegisterPage()),

        // Existing application pages.
        GetPage(name: '/detail', page: () => const ProductDetailPage()),
        GetPage(name: '/cart', page: () => const CartPage()),
        GetPage(name: '/profile', page: () => const ProfilePage()),
        GetPage(name: '/checkout', page: () => const CheckoutPage()),
      ],
    );
  }
}

// Mengecek status autentikasi pengguna.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Gagal memeriksa status login: ${snapshot.error}'),
            ),
          );
        }

        // Jika pengguna sudah login.
        if (snapshot.hasData) {
          return const MainPage();
        }

        // Jika pengguna belum login.
        return const LoginPage();
      },
    );
  }
}
