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
  final ScrollController scrollController = ScrollController();

  // المصفوفة الكاملة القادمة من السيرفر (تمت إعادتها لاسمها الأصلي cartItems لضمان التوافق مع باقي أجزاء المشروع)
  final RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  
  // المصفوفة المخصصة للعرض التدريجي (Pagination)
  final RxList<CartItemModel> displayedItems = <CartItemModel>[].obs;

  // متغيرات التحكم في التجزئة المحلية
  var isFetchingMore = false.obs;
  var hasNextPage = true.obs;
  final int _limit = 6;
  int _currentLoadedCount = 0;

  // 🌟 متغير جديد لمراقبة حالة التحميل أثناء إضافة منتج
  var isLoadingAdd = false.obs;

  // 🌟 الحل الذكي: جلب المعرف الحقيقي للمستخدم النشط حالياً بدلاً من النص الثابت
  String get userId {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? 'guest_user';
  }

  @override
  void onInit() {
    super.onInit();
    if (userId != 'guest_user') {
      // مراقبة السلة الحقيقية وتحديث العرض
      cartItems.bindStream(_cartRepository.getCartStream(userId));
      
      // الاستماع للتغييرات في السلة لإعادة ضبط التجزئة
      ever(cartItems, (_) => _resetPagination());
    }

    // إعداد مستمع التمرير
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100) {
        _loadMoreLocal();
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  // إعادة ضبط العرض التدريجي عند حدوث أي تغيير في السلة الأصلية
  void _resetPagination() {
    _currentLoadedCount = _limit;
    if (cartItems.length <= _limit) {
      displayedItems.assignAll(cartItems);
      hasNextPage.value = false;
    } else {
      displayedItems.assignAll(cartItems.take(_limit).toList());
      hasNextPage.value = true;
    }
  }

  // تحميل المزيد محلياً لمحاكاة الـ Infinite Scroll
  void _loadMoreLocal() {
    if (isFetchingMore.value || !hasNextPage.value || cartItems.length <= displayedItems.length) return;

    isFetchingMore.value = true;
    
    // محاكاة تأخير بسيط ليعطي إحساس التحميل الاحترافي
    Future.delayed(const Duration(milliseconds: 500), () {
      int nextCount = _currentLoadedCount + _limit;
      displayedItems.assignAll(cartItems.take(nextCount).toList());
      _currentLoadedCount = nextCount;

      if (displayedItems.length >= cartItems.length) {
        hasNextPage.value = false;
      }
      isFetchingMore.value = false;
    });
  }

  Future<void> addProductToCart(ProductModel product) async {
    if (userId == 'guest_user') {
      AppSnack.warning('يجب تسجيل الدخول أولاً لتتمكن من إضافة المنتجات للسلة');
      return;
    }

    try {
      isLoadingAdd.value = true; // بدء التحميل
      CartItemModel cartItem = CartItemModel.fromProduct(product, quantity: 1);
      await _cartRepository.addToCart(userId, cartItem);

      AppSnack.success("تم إضافة (${product.name}) بنجاح إلى السلة");
    } catch (e) {
      AppSnack.error('فشل إضافة المنتج: $e');
    } finally {
      isLoadingAdd.value = false; // إنهاء التحميل
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
