import 'package:get/get.dart';
import '../../cart/controller/cart_controller.dart';
import '../../categories/controller/categories_controller.dart';
import '../../favorites/controller/favorites_controller.dart';
import '../../orders/controller/orders_controller.dart';
import '../controller/dashboard_controller.dart';
import '../../home/controller/home_controller.dart';
// 👇 استيراد الكنترولر الجديد للمنتجات
import '../../categories/controller/products_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // حقن كنترولر اللوحة الرئيسية
    Get.lazyPut<DashboardController>(() => DashboardController());

    // حقن كنترولر الشاشة الرئيسية ليكون جاهزاً فور فتح الـ Dashboard
    Get.lazyPut<HomeController>(() => HomeController());

    // 🌟 السطر السحري الجديد: حقن الـ ProductsController ليكون جاهزاً بشكل كسلان في الذاكرة
    Get.lazyPut<ProductsController>(() => ProductsController());

    // 🚀 إضافة الـ CartController والـ CategoriesController بآلية كسلانة لتقليل استهلاك الذاكرة الأولي
    Get.lazyPut<CartController>(() => CartController());
    Get.lazyPut<CategoriesController>(() => CategoriesController());
    Get.lazyPut<OrdersController>(() => OrdersController());
    Get.lazyPut<FavoritesController>(() => FavoritesController());
  }
}


