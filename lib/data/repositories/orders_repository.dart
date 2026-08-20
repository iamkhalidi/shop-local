import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../features/orders/model/order_model.dart';

class OrdersRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // جلب الـ UID الخاص بالمستخدم الحالي لتحديد مسار الـ Sub-collection الصحيح
  String get _userId => _auth.currentUser?.uid ?? '';

  // 🚀 1️⃣ دالة حفظ الطلب الجديد داخل الـ Sub-collection الخاص بالمستخدم
  Future<void> saveOrderOnly(OrderModel newOrder) async {
    if (_userId.isEmpty) throw Exception("المستخدم غير مسجل دخول");
    try {
      // المسار الجديد: users -> {userId} -> orders -> {order.id}
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('orders')
          .doc(newOrder.id) // اعتماد الـ Uuid المولّد كـ Document ID
          .set(newOrder.toJson());
    } catch (e) {
      throw Exception("فشل في حفظ الطلب بالـ Sub-collection: $e");
    }
  }

  // 🚀 2️⃣ جلب الطلبات بنظام التجزئة (Pagination)
  Future<({List<OrderModel> orders, DocumentSnapshot? lastDoc})> getOrdersPaginated({
    int limit = 7,
    DocumentSnapshot? lastDocument,
  }) async {
    if (_userId.isEmpty) return (orders: <OrderModel>[], lastDoc: null);

    try {
      Query query = _firestore
          .collection('users')
          .doc(_userId)
          .collection('orders')
          .orderBy('createdAt', descending: true);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      query = query.limit(limit);
      QuerySnapshot snapshot = await query.get();

      List<OrderModel> orders = snapshot.docs.map((doc) {
        return OrderModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return (
        orders: orders,
        lastDoc: snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
      );
    } catch (e) {
      print("❌ خطأ أثناء جلب الطلبات المجدولة: $e");
      return (orders: <OrderModel>[], lastDoc: null);
    }
  }

  // 🚀 2.1 دالة الاستماع المباشر للتغييرات (Real-time Stream)
  Stream<List<OrderModel>> listenToUserOrders() {
    if (_userId.isEmpty) {
      return Stream.value([]); // إرجاع قائمة فارغة إذا لم يكن هناك مستخدم مسجل دخول
    }

    try {
      return _firestore
          .collection('users')
          .doc(_userId)
          .collection('orders')
          .orderBy('createdAt', descending: true) // ترتيب الطلبات من الأحدث للأقدم سحابياً
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return OrderModel.fromJson(doc.data());
        }).toList();
      });
    } catch (e) {
      // في حال عدم وجود Index في البداية، يعمل الـ Stream كاحتياط بدون ترتيب لتفادي الانهيار
      return _firestore
          .collection('users')
          .doc(_userId)
          .collection('orders')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return OrderModel.fromJson(doc.data());
        }).toList();
      });
    }
  }

  // 3️⃣ دالة مستقلة لتفريغ السلة من الفايرستور بالكامل (بقيت كما هي بمستند المستخدم الرئيسي بناءً على طلبك)
  Future<void> clearFirestoreCart() async {
    if (_userId.isEmpty) return;
    try {
      final userDocRef = _firestore.collection('users').doc(_userId);
      await userDocRef.update({'cart': []});
    } catch (e) {
      throw Exception("فشل في تفريغ السلة سحابياً: $e");
    }
  }


  // 🚀 4️⃣ دالة حذف طلب معين من الـ Sub-collection سحابياً
  Future<void> deleteOrder(String orderId) async {
    if (_userId.isEmpty) throw Exception("المستخدم غير مسجل دخول");
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('orders')
          .doc(orderId)
          .delete();
    } catch (e) {
      throw Exception("فشل في حذف الطلب: $e");
    }
  }

}