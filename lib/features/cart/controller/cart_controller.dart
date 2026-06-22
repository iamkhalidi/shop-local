import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/cart_repository.dart';
import '../../categories/model/product_model.dart';
import '../model/cart_item_model.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();

  final CartRepository _cartRepository = CartRepository();
  final RxList<CartItemModel> cartItems = <CartItemModel>[].obs;

  // 🌟 الحل الذكي: جلب المعرف الحقيقي للمستخدم النشط حالياً بدلاً من النص الثابت
  String get userId {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? 'guest_user';
  }

  @override
  void onInit() {
    super.onInit();
    // بدء بث البيانات ومراقبة المصفوفة فوراً بناءً على معرف اليوزر الحقيقي
    if (userId != 'guest_user') {
      cartItems.bindStream(_cartRepository.getCartStream(userId));
    }
  }

  Future<void> addProductToCart(ProductModel product) async {
    if (userId == 'guest_user') {
      Get.snackbar('تنبيه', 'يجب تسجيل الدخول أولاً لتتمكن من إضافة المنتجات للسلة',
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    try {
      CartItemModel cartItem = CartItemModel.fromProduct(product, quantity: 1);
      await _cartRepository.addToCart(userId, cartItem);

      Get.snackbar(
        'نجاح',
        'تم إضافة (${product.name}) بنجاح إلى السلة',
        snackPosition: SnackPosition.BOTTOM, // لكي تظهر في الأسفل تماماً فوق شريط التنقل
        backgroundColor: Colors.green.withOpacity(0.9), // لون أخضر مريح للعين
        colorText: Colors.white,
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 90), // 💡 تم رفع الـ bottom لـ 90 لكي لا تتداخل مع الـ Bottom Navigation Bar الزجاجي المرتفع لديك
        duration: const Duration(seconds: 2),
        borderRadius: 12,
        icon: const Icon(Icons.check_circle_outline, color: Colors.white), // أيقونة تأكيد ناعمة
      );


    } catch (e) {
      Get.snackbar('خطأ', 'فشل إضافة المنتج: $e',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  int get totalItemsCount => cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get totalPrice => cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

  void increaseQuantity(CartItemModel item) {
    _cartRepository.updateQuantity(userId, item.id, item.quantity + 1);
  }

  void decreaseQuantity(CartItemModel item) {
    _cartRepository.updateQuantity(userId, item.id, item.quantity - 1);
  }

  void removeItem(String itemId) {
    _cartRepository.removeFromCart(userId, itemId);
  }

  void clearAll() {
    _cartRepository.clearCart(userId);
  }
}