import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/database/firestore_service.dart';
import '../../categories/model/category_model.dart';
import '../../categories/model/product_model.dart';

class HomeController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();

  // قوائم مراقبة تفاعلية من الفايربيس
  var categories = <CategoryModel>[].obs;
  var productsList = <ProductModel>[].obs;

  var isLoadingCategories = true.obs;
  var isLoadingProducts = false.obs;

  // مؤشر الفئة المختارة حالياً (0 تعني الفئة الأولى المجلوبة)
  var selectedCategoryIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadHomeData(); // جلب البيانات فور تحميل الصفحة
  }

  // دالة جلب الفئات والمنتجات معاً
  Future<void> loadHomeData() async {
    try {
      isLoadingCategories.value = true;
      var fetchedCategories = await _firestoreService.fetchAllCategories();

      if (fetchedCategories.isNotEmpty) {
        categories.assignAll(fetchedCategories);
        // جلب منتجات أول فئة تلقائياً بعد تحميل الفئات
        await fetchProductsForSelectedCategory(fetchedCategories[0].id);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تحميل بيانات الصفحة الرئيسية',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoadingCategories.value = false;
    }
  }

  // جلب منتجات الفئة المحددة بالضغط
  Future<void> fetchProductsForSelectedCategory(String categoryId) async {
    try {
      isLoadingProducts.value = true;
      var fetchedProducts = await _firestoreService.getProductsByCategory(categoryId.toLowerCase());
      productsList.assignAll(fetchedProducts);
    } catch (e) {
      print("Error loading products in home: $e");
    } finally {
      isLoadingProducts.value = false;
    }
  }

  // تغيير الفئة عند ضغط المستخدم على الشريط الأفقي
  void changeCategory(int index) {
    selectedCategoryIndex.value = index;
    // جلب منتجات الفئة الجديدة بناءً على الـ ID الخاص بها من الفايربيس
    fetchProductsForSelectedCategory(categories[index].id);
  }
}