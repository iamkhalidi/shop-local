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


  // // القديمة
  // Future<void> loadHomeData() async {
  //   try {
  //     isLoadingCategories.value = true;
  //     var fetchedCategories = await _firestoreService.fetchAllCategories();
  //
  //     if (fetchedCategories.isNotEmpty) {
  //       categories.assignAll(fetchedCategories);
  //
  //       // ✨ جلب وتحميل المنتجات لكل الفئات بشكل معزول وتلقائي لتوزيعها بشكل سليم وصحيح بالواجهة
  //       for (var category in fetchedCategories) {
  //         await fetchProductsForCategory(category.id);
  //       }
  //     }
  //   } catch (e) {
  //     Get.snackbar('خطأ', 'فشل في تحميل بيانات الصفحة الرئيسية',
  //         backgroundColor: Colors.redAccent, colorText: Colors.white);
  //   } finally {
  //     isLoadingCategories.value = false;
  //   }
  // }

  // الجديدة والمطورة
  Future<void> loadHomeData() async {
    try {
      isLoadingCategories.value = true;

      // 1. جلب الفئات أولاً (طلب سريع)
      var fetchedCategories = await _firestoreService.fetchAllCategories();

      if (fetchedCategories.isNotEmpty) {
        categories.assignAll(fetchedCategories);

        // 🚀 تشغيل جلب المنتجات لكل فئة بشكل متوازي (Parallel) دون حجب الـ UI
        // استخدمنا Future.wait لتسريع العملية الكلية أو إطلاقها بشكل حر
        for (var category in fetchedCategories) {
          fetchProductsForCategory(category.id);
        }
      }
    } catch (e) {
      print("Error in loadHomeData: $e");
    } finally {
      isLoadingCategories.value = false;
    }
  }

  // جلب منتجات فئة محددة وحفظها بشكل مستقل
  Future<void> fetchProductsForCategory(String categoryId) async {
    try {
      // 🚀 إزالة .toLowerCase() لأن الـ IDs في فايرستور حساسة لحالة الأحرف
      var fetchedProducts = await _firestoreService.getProductsByCategory(
        categoryId, 
        limit: 6,
      );

      // تحديث الخريطة بالمنتجات الجديدة
      categoryProductsMap[categoryId] = fetchedProducts;
    } catch (e) {
      print("Error loading products for category ($categoryId): $e");
    }
  }
}
