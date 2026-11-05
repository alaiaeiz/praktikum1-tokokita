import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreOrderService {
  FirestoreOrderService._();

  static final FirestoreOrderService instance = FirestoreOrderService._();

  final CollectionReference<Map<String, dynamic>> _orders = FirebaseFirestore
      .instance
      .collection('orders');

  // CREATE: Menyimpan pesanan pengguna ke Firestore.
  Future<String> createOrder({
    required String uid,
    required List<Map<String, dynamic>> daftarItem,
    required double totalHarga,
    required String status,
  }) async {
    final document = await _orders.add({
      'uid': uid,
      'daftarItem': daftarItem,
      'totalHarga': totalHarga,
      'tanggal': Timestamp.now(),
      'status': status,
    });

    return document.id;
  }

  // READ: Mengambil pesanan secara real-time berdasarkan UID.
  Stream<QuerySnapshot<Map<String, dynamic>>> watchOrders(String uid) {
    return _orders
        .where('uid', isEqualTo: uid)
        .orderBy('tanggal', descending: true)
        .snapshots();
  }

  // UPDATE: Mengubah status pesanan.
  Future<void> updateOrderStatus({
    required String documentId,
    required String status,
  }) async {
    await _orders.doc(documentId).update({'status': status});
  }

  // DELETE: Menghapus pesanan dari Firestore.
  Future<void> deleteOrder(String documentId) async {
    await _orders.doc(documentId).delete();
  }
}
