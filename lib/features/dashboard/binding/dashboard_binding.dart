import 'package:get/get.dart';
import '../controller/dashboard_controller.dart';
// 🛑 تأكد من استيراد الـ HomeController الخاص بك هنا:
import '../../home/controller/home_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // حقن كنترولر اللوحة الرئيسية
    Get.lazyPut<DashboardController>(() => DashboardController());

    // 👇 السطر السحري: حقن كنترولر الشاشة الرئيسية ليكون جاهزاً فور فتح الـ Dashboard
    Get.lazyPut<HomeController>(() => HomeController());
  }
}