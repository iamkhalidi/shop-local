import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/database/firestore_service.dart';
import '../model/product_model.dart';

class ProductsController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  final ScrollController scrollController = ScrollController();

  // متغيرات مراقبة تفاعلية خاصة بالمنتجات فقط
  var productsList = <ProductModel>[].obs;
  var isLoadingProducts = false.obs;

  // متغيرات التجزئة (Pagination)
  DocumentSnapshot? _lastDocument;
  var isFetchingMore = false.obs;
  var hasNextPage = true.obs;
  final int _limit = 6;
  String _currentCategoryId = '';

  // للاحتفاظ بالمنتج المختار حالياً لعرضه في صفحة التفاصيل (ProductInfoScreen)
  var selectedProduct = Rxn<ProductModel>();

  @override
  void onInit() {
    super.onInit();
    // إعداد مستمع التمرير للكشف عن الوصول للنهاية
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        fetchMoreProducts();
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  // دالة جلب المنتجات (التحميل الأول للفئة)
  Future<void> fetchProducts(String categoryId) async {
    try {
      _currentCategoryId = categoryId;
      _lastDocument = null;
      hasNextPage.value = true;
      isLoadingProducts.value = true;
      
      var result = await _firestoreService.getProductsByCategory(
        categoryId,
        limit: _limit,
      );

      productsList.assignAll(result.products);
      _lastDocument = result.lastDoc;
      
      if (result.products.length < _limit) {
        hasNextPage.value = false;
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في جلب منتجات هذه الفئة',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoadingProducts.value = false;
    }
  }

  // دالة جلب المزيد من المنتجات عند السكرول (Pagination)
  Future<void> fetchMoreProducts() async {
    if (isFetchingMore.value || !hasNextPage.value || isLoadingProducts.value) return;

    try {
      isFetchingMore.value = true;
      
      var result = await _firestoreService.getProductsByCategory(
        _currentCategoryId,
        limit: _limit,
        lastDocument: _lastDocument,
      );

      if (result.products.isNotEmpty) {
        productsList.addAll(result.products);
        _lastDocument = result.lastDoc;
      }

      if (result.products.length < _limit) {
        hasNextPage.value = false;
      }
    } catch (e) {
      print("❌ خطأ في جلب المزيد من المنتجات: $e");
    } finally {
      isFetchingMore.value = false;
    }
  }
}
