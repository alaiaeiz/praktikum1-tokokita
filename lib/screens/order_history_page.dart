import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/order.dart';
import '../services/order_database.dart';
import '../services/firestore_order_service.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();

  late Future<List<Order>> futureOrders;
  late TabController tabController;

  Stream<QuerySnapshot<Map<String, dynamic>>>? firestoreOrders;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 2, vsync: this);

    futureOrders = OrderDatabase.instance.getAllOrders();

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      firestoreOrders = FirestoreOrderService.instance.watchOrders(user.uid);
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    tabController.dispose();
    super.dispose();
  }

  // Memuat ulang riwayat SQLite.
  void _loadOrders({String? status}) {
    setState(() {
      futureOrders = OrderDatabase.instance.getAllOrders(status: status);
    });
  }

  // Memperbarui status pesanan SQLite.
  Future<void> _updateLocalStatus(Order order, String newStatus) async {
    if (order.id == null) return;

    try {
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
    } catch (error) {
      Get.snackbar(
        'Gagal',
        'Tidak dapat memperbarui pesanan: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Memperbarui status pesanan Firestore.
  Future<void> _updateCloudStatus(String documentId, String newStatus) async {
    try {
      await FirestoreOrderService.instance.updateOrderStatus(
        documentId: documentId,
        status: newStatus,
      );

      Get.snackbar(
        'Berhasil',
        'Status pesanan Cloud diperbarui menjadi $newStatus.',
        snackPosition: SnackPosition.BOTTOM,
      );

      // StreamBuilder akan menerima perubahan secara otomatis.
    } catch (error) {
      Get.snackbar(
        'Gagal',
        'Tidak dapat memperbarui pesanan Cloud: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Dialog konfirmasi penghapusan.
  Future<bool> _confirmDelete() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Pesanan'),
          content: const Text(
            'Apakah kamu yakin ingin menghapus riwayat pesanan ini?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
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

    return confirmed == true;
  }

  // Menghapus pesanan SQLite.
  Future<void> _deleteLocalOrder(Order order) async {
    if (order.id == null) return;

    final confirmed = await _confirmDelete();

    if (!confirmed) return;

    try {
      await OrderDatabase.instance.deleteOrder(order.id!);

      if (!mounted) return;

      _loadOrders(status: searchController.text);

      Get.snackbar(
        'Berhasil',
        'Riwayat pesanan lokal berhasil dihapus.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      Get.snackbar(
        'Gagal',
        'Tidak dapat menghapus pesanan: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Menghapus pesanan Firestore.
  Future<void> _deleteCloudOrder(String documentId) async {
    final confirmed = await _confirmDelete();

    if (!confirmed) return;

    try {
      await FirestoreOrderService.instance.deleteOrder(documentId);

      Get.snackbar(
        'Berhasil',
        'Pesanan Cloud berhasil dihapus.',
        snackPosition: SnackPosition.BOTTOM,
      );

      // StreamBuilder akan memperbarui daftar secara otomatis.
    } catch (error) {
      Get.snackbar(
        'Gagal',
        'Tidak dapat menghapus pesanan Cloud: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Format tanggal untuk data SQLite.
  String _formatLocalDate(String value) {
    final date = DateTime.tryParse(value);

    if (date == null) return value;

    return DateFormat('dd/MM/yyyy HH:mm').format(date.toLocal());
  }

  // Format tanggal untuk data Firestore.
  String _formatCloudDate(dynamic value) {
    DateTime? date;

    if (value is Timestamp) {
      date = value.toDate();
    } else if (value is DateTime) {
      date = value;
    } else if (value is String) {
      date = DateTime.tryParse(value);
    }

    if (date == null) return 'Tanggal tidak tersedia';

    return DateFormat('dd/MM/yyyy HH:mm').format(date.toLocal());
  }

  // Ringkasan produk dari pesanan SQLite.
  String _getLocalItemSummary(Order order) {
    return order.daftarItem
        .map((item) {
          final name = item['namaProduk'] ?? 'Produk';
          final quantity = item['jumlah'] ?? 0;

          return '$name ($quantity x)';
        })
        .join(', ');
  }

  // Ringkasan produk dari pesanan Firestore.
  String _getCloudItemSummary(dynamic rawItems) {
    if (rawItems is! List || rawItems.isEmpty) {
      return 'Tidak ada detail produk';
    }

    return rawItems
        .map((item) {
          if (item is! Map) return 'Produk';

          final name = item['namaProduk'] ?? 'Produk';
          final quantity = item['jumlah'] ?? 0;

          return '$name ($quantity x)';
        })
        .join(', ');
  }

  // Mencari status secara lokal untuk kedua sumber data.
  bool _matchesStatus(String status) {
    final keyword = searchController.text.trim().toLowerCase();

    if (keyword.isEmpty) return true;

    return status.toLowerCase().contains(keyword);
  }

  // Tampilan daftar pesanan SQLite.
  Widget _buildLocalOrders() {
    return FutureBuilder<List<Order>>(
      future: futureOrders,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Gagal memuat riwayat lokal: ${snapshot.error}'),
          );
        }

        final orders = snapshot.data ?? <Order>[];

        if (orders.isEmpty) {
          return _buildEmptyState('Belum ada riwayat pesanan lokal.');
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];

            return _buildOrderCard(
              title: 'Pesanan Lokal #${order.id}',
              status: order.status,
              date: _formatLocalDate(order.tanggal),
              itemSummary: _getLocalItemSummary(order),
              total: order.totalHarga,
              onStatusChanged: (newStatus) {
                _updateLocalStatus(order, newStatus);
              },
              onDelete: () {
                _deleteLocalOrder(order);
              },
            );
          },
        );
      },
    );
  }

  // Tampilan daftar pesanan Firestore.
  Widget _buildCloudOrders() {
    if (firestoreOrders == null) {
      return _buildEmptyState('Silakan login untuk melihat pesanan Cloud.');
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: firestoreOrders,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Gagal memuat pesanan Cloud: ${snapshot.error}\n\n'
                'Jika muncul pesan FAILED_PRECONDITION, '
                'periksa kebutuhan indeks Firestore.',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final documents = snapshot.data?.docs ?? [];

        final filteredDocuments = documents.where((document) {
          final data = document.data();
          final status = data['status']?.toString() ?? '';

          return _matchesStatus(status);
        }).toList();

        if (filteredDocuments.isEmpty) {
          return _buildEmptyState(
            searchController.text.trim().isEmpty
                ? 'Belum ada pesanan di Cloud Firestore.'
                : 'Pesanan dengan status tersebut tidak ditemukan.',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: filteredDocuments.length,
          itemBuilder: (context, index) {
            final document = filteredDocuments[index];
            final data = document.data();

            final status = data['status']?.toString() ?? 'Diproses';
            final total = (data['totalHarga'] as num?)?.toDouble() ?? 0.0;

            return _buildOrderCard(
              title: 'Pesanan Cloud #${document.id}',
              status: status,
              date: _formatCloudDate(data['tanggal']),
              itemSummary: _getCloudItemSummary(data['daftarItem']),
              total: total,
              onStatusChanged: (newStatus) {
                _updateCloudStatus(document.id, newStatus);
              },
              onDelete: () {
                _deleteCloudOrder(document.id);
              },
            );
          },
        );
      },
    );
  }

  // Widget kartu pesanan yang digunakan kedua tab.
  Widget _buildOrderCard({
    required String title,
    required String status,
    required String date,
    required String itemSummary,
    required double total,
    required Function(String) onStatusChanged,
    required VoidCallback onDelete,
  }) {
    final isCompleted = status == 'Selesai';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                Chip(
                  label: Text(status),
                  backgroundColor: isCompleted
                      ? Colors.green.shade100
                      : Colors.orange.shade100,
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              'Tanggal: $date',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),

            const SizedBox(height: 6),

            Text('Produk: $itemSummary'),

            const SizedBox(height: 6),

            Text(
              'Total: ${formatOrderPrice(total)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            const Divider(),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'delete') {
                      onDelete();
                    } else {
                      onStatusChanged(value);
                    }
                  },
                  itemBuilder: (context) => [
                    if (!isCompleted)
                      const PopupMenuItem(
                        value: 'Selesai',
                        child: Text('Tandai Selesai'),
                      ),
                    if (isCompleted)
                      const PopupMenuItem(
                        value: 'Diproses',
                        child: Text('Kembalikan ke Diproses'),
                      ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text(
                        'Hapus Riwayat',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Icon(Icons.more_vert, size: 20),
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
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.receipt_long_outlined, size: 72, color: Colors.grey),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ),
        ],
      ),
    );
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
        bottom: TabBar(
          controller: tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(icon: Icon(Icons.storage), text: 'Lokal (SQLite)'),
            Tab(icon: Icon(Icons.cloud), text: 'Cloud (Firestore)'),
          ],
        ),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: (_) {
                setState(() {
                  futureOrders = OrderDatabase.instance.getAllOrders(
                    status: searchController.text,
                  );
                });
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

          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [_buildLocalOrders(), _buildCloudOrders()],
            ),
          ),
        ],
      ),
    );
  }
}

// Format harga untuk halaman riwayat.
String formatOrderPrice(double amount) {
  return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}';
}
