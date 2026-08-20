import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/cart_repository.dart';
import '../../categories/model/product_model.dart';
import '../model/cart_item_model.dart';
import '../../../core/utils/app_snack.dart';

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
      AppSnack.warning('يجب تسجيل الدخول أولاً لتتمكن من إضافة المنتجات للسلة');
      return;
    }

    try {
      CartItemModel cartItem = CartItemModel.fromProduct(product, quantity: 1);
      await _cartRepository.addToCart(userId, cartItem);

      AppSnack.success("تم إضافة (${product.name}) بنجاح إلى السلة");
    } catch (e) {
      AppSnack.error('فشل إضافة المنتج: $e');
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