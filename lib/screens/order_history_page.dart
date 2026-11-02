
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/order.dart';
import '../services/order_database.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final TextEditingController searchController =
      TextEditingController();

  late Future<List<Order>> futureOrders;

  @override
  void initState() {
    super.initState();
    futureOrders = OrderDatabase.instance.getAllOrders();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Memuat ulang riwayat, termasuk pencarian status.
  void _loadOrders({String? status}) {
    setState(() {
      futureOrders = OrderDatabase.instance.getAllOrders(
        status: status,
      );
    });
  }

  // Mengubah status pesanan.
  Future<void> _updateStatus(
    Order order,
    String newStatus,
  ) async {
    if (order.id == null) return;

    await OrderDatabase.instance.updateOrderStatus(
      id: order.id!,
      status: newStatus,
    );

    if (!mounted) return;

    _loadOrders(status: searchController.text);

    Get.snackbar(
      'Berhasil',
      'Status pesanan diperbarui menjadi $newStatus.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Menghapus riwayat pesanan.
  Future<void> _deleteOrder(Order order) async {
    if (order.id == null) return;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Pesanan'),
          content: const Text(
            'Apakah kamu yakin ingin menghapus riwayat pesanan ini?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await OrderDatabase.instance.deleteOrder(order.id!);

    if (!mounted) return;

    _loadOrders(status: searchController.text);

    Get.snackbar(
      'Berhasil',
      'Riwayat pesanan berhasil dihapus.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Format tanggal pesanan.
  String _formatDate(String value) {
    final date = DateTime.tryParse(value);

    if (date == null) return value;

    return DateFormat('dd/MM/yyyy HH:mm').format(
      date.toLocal(),
    );
  }

  // Menampilkan daftar produk dalam satu pesanan.
  String _getItemSummary(Order order) {
    return order.daftarItem.map((item) {
      final name = item['namaProduk'] ?? 'Produk';
      final quantity = item['jumlah'] ?? 0;

      return '$name ($quantity x)';
    }).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Riwayat Pesanan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),

      body: Column(
        children: [
          // Kolom pencarian berdasarkan status.
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                _loadOrders(status: value);
              },
              decoration: InputDecoration(
                hintText: 'Cari berdasarkan status pesanan...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    _loadOrders();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          // Menampilkan data dari SQLite.
          Expanded(
            child: FutureBuilder<List<Order>>(
              future: futureOrders,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Gagal memuat riwayat: ${snapshot.error}',
                    ),
                  );
                }

                final orders = snapshot.data ?? <Order>[];

                if (orders.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 72,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Belum ada riwayat pesanan.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];

                    final isCompleted =
                        order.status == 'Selesai';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Pesanan #${order.id}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),

                                Chip(
                                  label: Text(order.status),
                                  backgroundColor: isCompleted
                                      ? Colors.green.shade100
                                      : Colors.orange.shade100,
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            Text(
                              'Tanggal: ${_formatDate(order.tanggal)}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              'Produk: ${_getItemSummary(order)}',
                            ),

                            const SizedBox(height: 6),

                            Text(
                              'Total: ${formatOrderPrice(order.totalHarga)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),

                            const Divider(),

                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.end,
                              children: [
                                PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'delete') {
                                      _deleteOrder(order);
                                    } else {
                                      _updateStatus(order, value);
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    if (!isCompleted)
                                      const PopupMenuItem(
                                        value: 'Selesai',
                                        child: Text(
                                          'Tandai Selesai',
                                        ),
                                      ),

                                    if (isCompleted)
                                      const PopupMenuItem(
                                        value: 'Diproses',
                                        child: Text(
                                          'Kembalikan ke Diproses',
                                        ),
                                      ),

                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Text(
                                        'Hapus Riwayat',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                  child: const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.more_vert,
                                          size: 20,
                                        ),
                                        SizedBox(width: 4),
                                        Text('Kelola Pesanan'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Format harga khusus halaman riwayat.
String formatOrderPrice(double amount) {
  return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (match) => '${match[1]}.',
  )}';
}
