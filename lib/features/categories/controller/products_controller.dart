import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/database/firestore_service.dart';
import '../model/product_model.dart';

class ProductsController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();

  // متغيرات مراقبة تفاعلية خاصة بالمنتجات فقط
  var productsList = <ProductModel>[].obs;
  var isLoadingProducts = false.obs;

  // للاحتفاظ بالمنتج المختار حالياً لعرضه في صفحة التفاصيل (ProductInfoScreen)
  var selectedProduct = Rxn<ProductModel>();

  // دالة جلب المنتجات بناءً على الـ id الخاص بالفئة القادم من الفايربيس
  Future<void> fetchProducts(String categoryId) async {
    try {
      isLoadingProducts.value = true;
      // تحويل الـ ID للأحرف الصغيرة ليطابق الفايربيس تماماً (مثلاً: Juices تصبح juices)
      var fetchedProducts = await _firestoreService.getProductsByCategory(categoryId.toLowerCase());

      productsList.assignAll(fetchedProducts);
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في جلب منتجات هذه الفئة',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoadingProducts.value = false;
    }
  }
}