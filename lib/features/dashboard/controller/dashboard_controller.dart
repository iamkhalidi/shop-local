import 'package:get/get.dart';

class DashboardController extends GetxController {
  var currentIndex = 0.obs;

  // متغيرات فرعية لإدارة التنقل داخل قسم الفئات
  var currentCategoryPage = 0.obs; // 0: قائمة الفئات، 1: المنتجات، 2: تفاصيل المنتج

  var selectedCategoryName = ''.obs; // لحفظ اسم الفئة المختارة ديناميكياً
  var selectedProductName = ''.obs;  // لحفظ اسم المنتج المختار ديناميكياً
  var selectedProductPrice = ''.obs; // لحفظ سعر المنتج المختار

  void changePage(int index) {
    currentIndex.value = index;
    // إذا ضغط المستخدم على زر "الفئات" في الـ Nav Bar مجدداً، نعيده للشاشة الرئيسية للفئات
    if (index == 1) {
      currentCategoryPage.value = 0;
    }
  }

  // للانتقال إلى صفحة المنتجات داخل قسم الفئات
  void goToProducts(String categoryName) {
    selectedCategoryName.value = categoryName;
    currentCategoryPage.value = 1;
  }

  // للانتقال إلى صفحة تفاصيل المنتج داخل قسم الفئات
  void goToProductInfo(String productName, String price) {
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




// import 'package:get/get.dart';
//
// class DashboardController extends GetxController {
//   // المتغير المسؤول عن رقم الصفحة الحالية النشطة
//   var currentIndex = 0.obs;
//
//   // تغيير رقم الصفحة عند الضغط على الأيقونة
//   void changePage(int index) {
//     currentIndex.value = index;
//   }
// }