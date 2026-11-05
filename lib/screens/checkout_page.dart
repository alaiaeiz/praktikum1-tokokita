import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../models/product.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final CartController cartController = Get.find();

  bool isProcessing = false;

  Future<void> _processCheckout() async {
    if (isProcessing) return;

    if (cartController.cartItems.isEmpty) {
      Get.snackbar(
        'Keranjang Kosong',
        'Tambahkan produk sebelum melakukan checkout.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() {
      isProcessing = true;
    });

    try {
      final orderId = await cartController.checkout();

      if (!mounted) return;

      Get.offNamed('/');

      Get.snackbar(
        'Pesanan Berhasil',
        'Pesanan #$orderId berhasil disimpan. Terima kasih!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (error) {
      if (!mounted) return;

      Get.snackbar(
        'Checkout Gagal',
        'Terjadi kesalahan saat menyimpan pesanan: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (mounted) {
        setState(() {
          isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ringkasan Checkout'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Obx(() {
        final items = cartController.cartItems;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Daftar Belanjaan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(item.product.name),
                      subtitle: Text(
                        '${item.quantity}x @ ${formatRupiah(item.product.price)}',
                      ),
                      trailing: Text(
                        formatRupiah(item.subtotal),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ),

              const Divider(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Pembayaran:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    formatRupiah(cartController.totalHarga),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: isProcessing ? null : _processCheckout,
                  child: isProcessing
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Bayar Sekarang',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
