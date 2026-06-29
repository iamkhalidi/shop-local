// داخل ملف lib/data/repositories/orders_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../features/orders/model/order_model.dart';

class OrdersRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser?.uid ?? '';

  // // 1️⃣ جلب الطلبات
  // Future<List<OrderModel>> getUserOrders() async {
  //   if (_userId.isEmpty) return [];
  //   try {
  //     final doc = await _firestore.collection('users').doc(_userId).get();
  //     if (doc.exists && doc.data()!.containsKey('orders')) {
  //       final List<dynamic> ordersList = doc.data()?['orders'] ?? [];
  //       return ordersList.map((order) => OrderModel.fromJson(order as Map<String, dynamic>)).toList();
  //     }
  //     return [];
  //   } catch (e) {
  //     throw Exception("فشل في جلب الطلبات: $e");
  //   }
  // }


// 🚀 الدالة المصححة للاستماع إلى مصفوفة الطلبات داخل مستند المستخدم نفسه
  Stream<List<OrderModel>> listenToUserOrders() {
    if (_userId.isEmpty) {
      return Stream.value([]); // إرجاع مصفوفة فارغة إذا لم يكن مسجلاً دخوله
    }

    return _firestore
        .collection('users')
        .doc(_userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data()!.containsKey('orders')) {
        final List<dynamic> ordersList = snapshot.data()?['orders'] ?? [];

        // تحويل الخريطة (Map) إلى كائنات OrderModel
        return ordersList
            .map((order) => OrderModel.fromJson(order as Map<String, dynamic>))
            .toList();
      }
      return []; // إذا لم يكن هناك طلبات بعد
    });
  }


  // 2️⃣ دالة لحفظ الطلب فقط دون المساس بالسلة
  Future<void> saveOrderOnly(OrderModel newOrder) async {
    if (_userId.isEmpty) throw Exception("المستخدم غير مسجل دخول");
    try {
      final userDocRef = _firestore.collection('users').doc(_userId);
      await userDocRef.update({
        'orders': FieldValue.arrayUnion([newOrder.toJson()]),
      });
    } catch (e) {
      throw Exception("فشل في حفظ الطلب: $e");
    }
  }

  // 3️⃣ دالة مستقلة لتفريغ السلة من الفايرستور بالكامل
  Future<void> clearFirestoreCart() async {
    if (_userId.isEmpty) return;
    try {
      final userDocRef = _firestore.collection('users').doc(_userId);
      await userDocRef.update({'cart': []});
    } catch (e) {
      throw Exception("فشل في تفريغ السلة سحابياً: $e");
    }
  }
}