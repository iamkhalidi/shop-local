import 'package:get/get.dart';

import '../../categories/controller/products_controller.dart';

class DashboardController extends GetxController {
  var currentIndex = 0.obs;

  // 0: قائمة الفئات، 1: المنتجات، 2: تفاصيل المنتج
  var currentCategoryPage = 0.obs;

  var selectedCategoryName = ''.obs;
  var selectedCategoryDisplay = ''.obs; // 🌟 متغير جديد لحفظ الاسم العربي للعرض في الـ AppBar
  var selectedProductName = ''.obs;
  var selectedProductPrice = ''.obs;

  // القيمة المراقبة لتحديد مصدر الدخول
  var isComingFromHome = false.obs;

  void changePage(int index) {
    currentIndex.value = index;
    if (index == 1) {
      // عند الضغط على تبويب الفئات من الشريط السفلي، يبدأ دائماً من شاشة الفئات العامة (0)
      currentCategoryPage.value = 0;
    }
  }

  // للانتقال إلى صفحة المنتجات داخل قسم الفئات
  void goToProducts(String categoryId, String categoryName) {
    selectedCategoryName.value = categoryId;
    selectedCategoryDisplay.value = categoryName; // حفظ الاسم العربي
    currentCategoryPage.value = 1;

    // 🚀 جلب المنتجات باستخدام الـ ID الحقيقي
    Get.find<ProductsController>().fetchProducts(categoryId);
  }

  // للانتقال إلى صفحة تفاصيل المنتج داخل قسم الفئات
  void goToProductInfo(String productName, String price) {
    // 🛠️ تم إزالة سطر تصفير isComingFromHome من هنا ليتم التحكم به من الشاشات بحرية
    selectedProductName.value = productName;
    selectedProductPrice.value = price;
    currentCategoryPage.value = 2;
  }

  // للرجوع للخلف داخل قسم الفئات
  void goBackInCategories() {
    if (currentCategoryPage.value > 0) {
      currentCategoryPage.value--;
    }
  }
}
