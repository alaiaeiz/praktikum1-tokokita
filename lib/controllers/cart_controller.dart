import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;

  void addToCart(Product product, {int qty = 1}) {
    final index = cartItems.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      cartItems[index].quantity += qty;
      cartItems.refresh();
    } else {
      cartItems.add(CartItem(product: product, quantity: qty));
    }

    // Menggunakan Snackbar standar GetX yang stabil dan pasti muncul
    Get.rawSnackbar(
      message: 'Berhasil menambahkan $qty item "${product.name}" ke keranjang!',
      backgroundColor: const Color(0xFF4CAF50),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
      icon: const Icon(Icons.check_circle, color: Colors.white),
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
      message: 'Berhasil menghapus "${item.product.name}" dari keranjang!',
      backgroundColor: Colors.redAccent,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
      icon: const Icon(Icons.delete_forever, color: Colors.white),
    );
  }

  void clearCart() {
    cartItems.clear();
  }

  int get totalItem => cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get totalHarga {
    return cartItems.fold(0, (sum, item) => sum + item.subtotal);
  }
}