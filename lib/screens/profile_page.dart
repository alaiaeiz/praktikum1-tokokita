import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'wishlist_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
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
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 16),

          const Center(
            child: Text(
              'Amelia Putri Aqiilah',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 8),

          const Center(
            child: Text(
              'Mahasiswa Informatika',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),

          const SizedBox(height: 32),

          const Divider(),

          ListTile(
            leading: const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            title: const Text(
              'Wishlist',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: const Text(
              'Lihat produk favorit kamu',
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
            onTap: () {
              Get.to(
                () => const WishlistPage(),
              );
            },
          ),

          const Divider(),
        ],
      ),
    );
  }
}