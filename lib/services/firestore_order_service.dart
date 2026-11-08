import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreOrderService {
  FirestoreOrderService._();

  static final FirestoreOrderService instance = FirestoreOrderService._();

  final CollectionReference<Map<String, dynamic>> _orders = FirebaseFirestore
      .instance
      .collection('orders');

  // menyimpan pesanan pengguna ke firestore.
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

  Stream<QuerySnapshot<Map<String, dynamic>>> watchOrders(String uid) {
    return _orders
        .where('uid', isEqualTo: uid)
        .orderBy('tanggal', descending: true)
        .snapshots();
  }

  // mengubah status pesanan.
  Future<void> updateOrderStatus({
    required String documentId,
    required String status,
  }) async {
    await _orders.doc(documentId).update({'status': status});
  }

  // menghapus pesanan dari firestore.
  Future<void> deleteOrder(String documentId) async {
    await _orders.doc(documentId).delete();
  }
}
