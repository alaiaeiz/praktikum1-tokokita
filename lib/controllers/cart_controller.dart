
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../services/order_database.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;

  void addToCart(Product product, {int qty = 1}) {
    final index = cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (index >= 0) {
      cartItems[index].quantity += qty;
      cartItems.refresh();
    } else {
      cartItems.add(
        CartItem(product: product, quantity: qty),
      );
    }

    Get.rawSnackbar(
      message:
          'Berhasil menambahkan $qty item "${product.name}" ke keranjang!',
      backgroundColor: const Color(0xFF4CAF50),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
      icon: const Icon(
        Icons.check_circle,
        color: Colors.white,
      ),
      shouldIconPulse: true,
    );
  }

  void incrementQuantity(CartItem item) {
    item.quantity++;
    cartItems.refresh();
  }

  void decrementQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
      cartItems.refresh();
    } else {
      removeFromCart(item);
    }
  }

  void removeFromCart(CartItem item) {
    cartItems.remove(item);

    Get.rawSnackbar(
      message:
          'Berhasil menghapus "${item.product.name}" dari keranjang!',
      backgroundColor: Colors.redAccent,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
      icon: const Icon(
        Icons.delete_forever,
        color: Colors.white,
      ),
    );
  }

  void clearCart() {
    cartItems.clear();
  }

  int get totalItem {
    return cartItems.fold(
      0,
      (sum, item) => sum + item.quantity,
    );
  }

  double get totalHarga {
    return cartItems.fold(
      0,
      (sum, item) => sum + item.subtotal,
    );
  }

  // CHECKOUT: Menyimpan pesanan ke SQLite.
  Future<int> checkout() async {
    if (cartItems.isEmpty) {
      throw Exception('Keranjang masih kosong.');
    }

    // Membuat salinan data produk dari keranjang.
    final List<Map<String, dynamic>> orderItems =
        cartItems.map((item) {
      return {
        'productId': item.product.id,
        'namaProduk': item.product.name,
        'harga': item.product.price,
        'jumlah': item.quantity,
        'subtotal': item.subtotal,
      };
    }).toList();

    // Membuat object pesanan.
    final order = Order(
      tanggal: DateTime.now().toIso8601String(),
      daftarItem: orderItems,
      totalHarga: totalHarga,
      status: 'Diproses',
    );

    // Simpan pesanan terlebih dahulu.
    final orderId =
        await OrderDatabase.instance.insertOrder(order);

    // Keranjang hanya dikosongkan jika penyimpanan berhasil.
    clearCart();

    return orderId;
  }
}
