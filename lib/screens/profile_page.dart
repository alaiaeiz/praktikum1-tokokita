import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'wishlist_page.dart';
import 'order_history_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _logout() async {
    final bool? confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text(
          'Apakah kamu yakin ingin keluar dari akun TokoKita?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: false);
            },
            child: const Text('Batal'),
          ),

          ElevatedButton(
            onPressed: () {
              Get.back(result: true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await FirebaseAuth.instance.signOut();

    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Logout Gagal',
        e.message ?? 'Tidak dapat keluar dari akun.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Terjadi Kesalahan',
        'Tidak dapat melakukan logout.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengguna'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 24),

          const Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
          ),

          const SizedBox(height: 16),

          const Center(
            child: Text(
              'Amelia Putri Aqiilah',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 8),

          const Center(
            child: Text(
              'Mahasiswa Informatika',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),

          const SizedBox(height: 8),

          Center(
            child: Text(
              currentUser?.email ?? 'Email tidak tersedia',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.blue),
            ),
          ),

          const SizedBox(height: 32),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.favorite, color: Colors.red),
            title: const Text(
              'Wishlist',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Text('Lihat produk favorit kamu'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Get.to(() => const WishlistPage());
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.receipt_long, color: Colors.blue),
            title: const Text(
              'Riwayat Pesanan',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Text('Lihat dan kelola pesanan kamu'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Get.to(() => const OrderHistoryPage());
            },
          ),

          const Divider(),

          const SizedBox(height: 12),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
            ),
            subtitle: const Text('Keluar dari akun TokoKita'),
            onTap: _logout,
          ),

          const Divider(),
        ],
      ),
    );
  }
}
