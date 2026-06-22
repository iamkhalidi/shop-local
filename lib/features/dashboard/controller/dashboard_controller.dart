import 'package:get/get.dart';

import '../../categories/controller/products_controller.dart';

class DashboardController extends GetxController {
  var currentIndex = 0.obs;

  // 0: قائمة الفئات، 1: المنتجات، 2: تفاصيل المنتج
  var currentCategoryPage = 0.obs;

  var selectedCategoryName = ''.obs;
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
  void goToProducts(String categoryName) {
    selectedCategoryName.value = categoryName;
    currentCategoryPage.value = 1;

    // 🚀 جلب المنتجات هنا لمرة واحدة فقط عند الضغط على الفئة
    Get.find<ProductsController>().fetchProducts(categoryName);
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
