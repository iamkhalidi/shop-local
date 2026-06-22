import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/cart/model/cart_item_model.dart';

class CartRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // جلب السلة كبث مباشر (Stream) ومراقبة مصفوفة cart داخل مستند اليوزر
  Stream<List<CartItemModel>> getCartStream(String userId) {
    return _db.collection('users').doc(userId).snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        // فك البيانات بأمان متوافق مع الويب والموبايل
        final data = Map<String, dynamic>.from(snapshot.data() as Map);
        if (data['cart'] != null) {
          final List<dynamic> cartList = data['cart'];
          return cartList.map((item) => CartItemModel.fromJson(Map<String, dynamic>.from(item as Map))).toList();
        }
      }
      return [];
    });
  }

  // إضافة منتج أو زيادة كميته داخل المصفوفة
  Future<void> addToCart(String userId, CartItemModel newItem) async {
    final docRef = _db.collection('users').doc(userId);
    final snapshot = await docRef.get();

    if (snapshot.exists && snapshot.data() != null) {
      final data = Map<String, dynamic>.from(snapshot.data() as Map);
      List<dynamic> cartList = data['cart'] != null ? List.from(data['cart']) : [];

      // التحقق مما إذا كان المنتج موجوداً مسبقاً في المصفوفة
      int index = cartList.indexWhere((item) => item['id'] == newItem.id);

      if (index != -1) {
        // إذا وجدناه، نزيد الكمية محلياً في المصفوفة
        Map<String, dynamic> existingItem = Map<String, dynamic>.from(cartList[index] as Map);
        int currentQty = existingItem['quantity'] ?? 0;
        existingItem['quantity'] = currentQty + newItem.quantity;
        cartList[index] = existingItem;
      } else {
        // إذا كان منتجاً جديداً، نضيفه للمصفوفة
        cartList.add(newItem.toJson());
      }

      // تحديث الحقل كاملاً في الفايرستور
      await docRef.update({'cart': cartList});
    }
  }

  // تحديث كمية المنتج (زيادة أو نقصان أو حذف إذا أصبحت صفر)
  Future<void> updateQuantity(String userId, String itemId, int quantity) async {
    final docRef = _db.collection('users').doc(userId);
    final snapshot = await docRef.get();

    if (snapshot.exists && snapshot.data() != null) {
      final data = Map<String, dynamic>.from(snapshot.data() as Map);
      List<dynamic> cartList = data['cart'] != null ? List.from(data['cart']) : [];

      int index = cartList.indexWhere((item) => item['id'] == itemId);

      if (index != -1) {
        if (quantity <= 0) {
          cartList.removeAt(index);
        } else {
          Map<String, dynamic> item = Map<String, dynamic>.from(cartList[index] as Map);
          item['quantity'] = quantity;
          cartList[index] = item;
        }
        await docRef.update({'cart': cartList});
      }
    }
  }

  // حذف منتج معين من المصفوفة
  Future<void> removeFromCart(String userId, String itemId) async {
    final docRef = _db.collection('users').doc(userId);
    final snapshot = await docRef.get();

    if (snapshot.exists && snapshot.data() != null) {
      final data = Map<String, dynamic>.from(snapshot.data() as Map);
      List<dynamic> cartList = data['cart'] != null ? List.from(data['cart']) : [];

      cartList.removeWhere((item) => item['id'] == itemId);
      await docRef.update({'cart': cartList});
    }
  }

  // تفريغ السلة بالكامل
  Future<void> clearCart(String userId) async {
    await _db.collection('users').doc(userId).update({'cart': []});
  }
}