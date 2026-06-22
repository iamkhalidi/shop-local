import 'package:get/get.dart';

class DashboardController extends GetxController {
  var currentIndex = 0.obs;

  // متغيرات فرعية لإدارة التنقل داخل قسم الفئات
  var currentCategoryPage = 0.obs; // 0: قائمة الفئات، 1: المنتجات، 2: تفاصيل المنتج

  var selectedCategoryName = ''.obs; // لحفظ اسم الفئة المختارة ديناميكياً
  var selectedProductName = ''.obs;  // لحفظ اسم المنتج المختار ديناميكياً
  var selectedProductPrice = ''.obs; // لحفظ سعر المنتج المختار

  // القيمة المراقبة لتحديد مصدر الدخول (هل هو من الهوم أم لا)
  var isComingFromHome = false.obs;

  void changePage(int index) {
    currentIndex.value = index;
    // إذا ضغط المستخدم على زر "الفئات" في الـ Nav Bar مجدداً، نعيده للشاشة الرئيسية للفئات
    if (index == 1) {
      currentCategoryPage.value = 0;
    }
  }

  // للانتقال إلى صفحة المنتجات داخل قسم الفئات
  void goToProducts(String categoryName) {
    isComingFromHome.value = false; // تصفح طبيعي، تأكيد الإلغاء هنا أيضاً
    selectedCategoryName.value = categoryName;
    currentCategoryPage.value = 1;
  }

  // للانتقال إلى صفحة تفاصيل المنتج داخل قسم الفئات
  void goToProductInfo(String productName, String price) {
    // 🌟 السطر السحري الجديد لمنع المشكلة:
    // بما أن هذه الدالة تُستدعى فقط من داخل ProductsScreen، فإننا نؤكد هنا أن المستخدم لم يأتِ من الهوم
    isComingFromHome.value = false;

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



