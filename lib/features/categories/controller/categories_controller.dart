import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/database/firestore_service.dart';
import '../model/category_model.dart';

class CategoriesController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();

  // متغيرات مراقبة تفاعلية من GetX
  var categories = <CategoryModel>[].obs;
  var isLoading = true.obs;

  // 🌟 متغيرات البحث الجديدة
  var isSearchMode = false.obs;
  var searchQuery = ''.obs;

  // قائمة الفئات المفلترة بناءً على البحث
  List<CategoryModel> get displayedCategories {
    if (searchQuery.isEmpty) {
      return categories;
    } else {
      final query = searchQuery.value.toLowerCase();
      return categories.where((cat) {
        return cat.nameAr.toLowerCase().contains(query) || 
               cat.nameEn.toLowerCase().contains(query);
      }).toList();
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadCategories(); // جلب الفئات عند تحميل الكنترولر تلقائياً
  }

  // دالة تفعيل/إلغاء وضع البحث
  void toggleSearchMode() {
    isSearchMode.value = !isSearchMode.value;
    if (!isSearchMode.value) {
      searchQuery.value = '';
    }
  }

  // استدعاء البيانات من سيرفر الفايربيس
  void loadCategories() async {
    try {
      isLoading.value = true;
      var fetchedData = await _firestoreService.fetchAllCategories();
      if (fetchedData.isNotEmpty) {
        categories.assignAll(fetchedData);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في الاتصال وجلب الفئات',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // دالة ذكية لتحويل الاسم النصي القادم من الفايربيس إلى أيقونة متطابقة من أندرويد
  IconData convertStringToIcon(String iconName) {
    switch (iconName) {
      case 'local_drink': return Icons.local_drink;
      case 'lunch_dining': return Icons.lunch_dining;
      case 'eco': return Icons.eco;
      case 'water_drop': return Icons.water_drop;
      case 'bakery_dining': return Icons.bakery_dining;
      case 'cookie': return Icons.cookie;
      default: return Icons.local_grocery_store;
    }
  }
}