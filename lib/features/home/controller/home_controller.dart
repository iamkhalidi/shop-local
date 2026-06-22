// lib/features/home/controller/home_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/database/firestore_service.dart';
import '../../categories/model/category_model.dart';
import '../../categories/model/product_model.dart';

class HomeController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();

  var categories = <CategoryModel>[].obs;

  // ✨ خريطة ذكية تفاعلية لحفظ منتجات كل فئة بشكل معزول تماماً: [key: categoryId, value: List<ProductModel>]
  var categoryProductsMap = <String, List<ProductModel>>{}.obs;

  var isLoadingCategories = true.obs;
  var isLoadingProducts = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    try {
      isLoadingCategories.value = true;
      var fetchedCategories = await _firestoreService.fetchAllCategories();

      if (fetchedCategories.isNotEmpty) {
        categories.assignAll(fetchedCategories);

        // ✨ جلب وتحميل المنتجات لكل الفئات بشكل معزول وتلقائي لتوزيعها بشكل سليم وصحيح بالواجهة
        for (var category in fetchedCategories) {
          await fetchProductsForCategory(category.id);
        }
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تحميل بيانات الصفحة الرئيسية',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoadingCategories.value = false;
    }
  }

  // جلب منتجات فئة محددة وحفظها بداخل المعرف الخاص بها في الخريطة
  Future<void> fetchProductsForCategory(String categoryId) async {
    try {
      isLoadingProducts.value = true;
      var fetchedProducts = await _firestoreService.getProductsByCategory(categoryId.toLowerCase());

      // حفظ المنتجات المجلوبة بداخل التبويب الخاص بالفئة الفعلي
      categoryProductsMap[categoryId.toLowerCase()] = fetchedProducts;
    } catch (e) {
      print("Error loading products for category ($categoryId) in home: $e");
    } finally {
      isLoadingProducts.value = false;
    }
  }
}
