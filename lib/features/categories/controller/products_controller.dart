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

  // متغيرات البحث
  var isSearchMode = false.obs;
  var searchQuery = ''.obs;
  var allProductsForSearch = <ProductModel>[].obs; // قائمة لكل المنتجات لضمان شمولية البحث

  // للاحتفاظ بالمنتج المختار حالياً لعرضه في صفحة التفاصيل (ProductInfoScreen)
  var selectedProduct = Rxn<ProductModel>();

  // قائمة العرض النهائية (تختار بين القائمة العادية أو المفلترة)
  List<ProductModel> get displayedProducts {
    if (searchQuery.isEmpty) {
      return productsList;
    } else {
      final query = searchQuery.value.toLowerCase();
      // منطق البحث الاحترافي: الاسم أولاً ثم البيانات الأخرى
      return allProductsForSearch.where((p) {
        final nameMatch = p.name.toLowerCase().contains(query);
        final descMatch = p.description.toLowerCase().contains(query);
        final typeMatch = p.unitType.toLowerCase().contains(query);
        return nameMatch || descMatch || typeMatch;
      }).toList();
    }
  }

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

  // دالة تفعيل/إلغاء وضع البحث
  void toggleSearchMode() {
    isSearchMode.value = !isSearchMode.value;
    if (!isSearchMode.value) {
      searchQuery.value = '';
    } else {
      // عند بدء البحث، نجلب منتجات الفئة لضمان دقة البحث
      _fetchAllProductsForSearch();
    }
  }

  Future<void> _fetchAllProductsForSearch() async {
    try {
      var result = await _firestoreService.getProductsByCategory(_currentCategoryId, limit: 100);
      allProductsForSearch.assignAll(result.products);
    } catch (e) {
      print("Error fetching all products for search: $e");
    }
  }

  // دالة جلب المنتجات (التحميل الأول للفئة)
  Future<void> fetchProducts(String categoryId) async {
    try {
      _currentCategoryId = categoryId;
      _lastDocument = null;
      hasNextPage.value = true;
      isLoadingProducts.value = true;
      allProductsForSearch.clear(); 
      searchQuery.value = '';
      isSearchMode.value = false;
      
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
    if (isSearchMode.value || isFetchingMore.value || !hasNextPage.value || isLoadingProducts.value) return;

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
