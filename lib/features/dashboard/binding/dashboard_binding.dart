import 'package:get/get.dart';
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
  }
}


