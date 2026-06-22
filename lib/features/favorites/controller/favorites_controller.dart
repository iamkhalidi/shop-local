import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/database/firestore_service.dart';
import '../../auth/controller/auth_controller.dart';
import '../../categories/model/product_model.dart';

class FavoritesController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthController _authController = Get.find<AuthController>();

  var favoriteProducts = <ProductModel>[].obs;
  var favoriteIds = <String>[].obs; // مصفوفة الـ IDs للمقارنة السريعة في الشاشات
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  // تحميل المفضلة بطلب واحد سريع ومباشر من مستند المستخدم
  void loadFavorites() async {
    final uid = _authController.firebaseUser.value?.uid;
    if (uid == null) return;

    try {
      isLoading.value = true;

      // جلب المنتجات كاملة مباشرة
      List<ProductModel> fetchedProducts = await _firestoreService.getUserFullFavorites(uid);

      favoriteProducts.assignAll(fetchedProducts);

      // استخراج الـ IDs وحفظها لتحديث أزرار القلوب في الشاشات الأخرى
      favoriteIds.assignAll(fetchedProducts.map((p) => p.id).toList());
    } catch (e) {
      print("Error loading favorites: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // دالة التبديل الذكية تدمج الحفظ والحذف الفوري
  void toggleFavorite(ProductModel product) async {
    final uid = _authController.firebaseUser.value?.uid;
    if (uid == null) return;

    if (favoriteIds.contains(product.id)) {
      // 1. إذا كان موجوداً، نحذفه محلياً ومن قاعدة البيانات
      favoriteIds.remove(product.id);
      favoriteProducts.removeWhere((p) => p.id == product.id);
      await _firestoreService.removeFromFavorites(uid, product.id);

      // رسالة سريعة أسفل الشاشة عند الحذف
      Get.snackbar(
        'تنبيه',
        'تم إزالة (${product.name}) من المفضلة',
        snackPosition: SnackPosition.BOTTOM, // لكي تظهر في الأسفل تماماً
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        margin: const EdgeInsets.all(15),
        duration: const Duration(seconds: 2),
      );
    } else {
      // 2. إذا لم يكن موجوداً، نضيفه محلياً ومن قاعدة البيانات كاملاً
      favoriteIds.add(product.id);
      favoriteProducts.add(product);
      await _firestoreService.addToFavorites(uid, product);

      // رسالة سريعة أسفل الشاشة عند الإضافة بنجاح
      Get.snackbar(
        'نجاح',
        'تم إضافة (${product.name}) بنجاح إلى المفضلة',
        snackPosition: SnackPosition.BOTTOM, // لكي تظهر في الأسفل تماماً
        backgroundColor: Colors.green.withOpacity(0.9),
        colorText: Colors.white,
        margin: const EdgeInsets.all(15),
        duration: const Duration(seconds: 2),
      );
    }
  }

  // دالة فحص حالة المنتج (هل هو مفضل أم لا) مستخدمة في أزرار الـ Toggle
  bool isFavorite(String productId) {
    return favoriteIds.contains(productId);
  }
}