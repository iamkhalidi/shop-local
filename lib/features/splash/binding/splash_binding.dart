import 'package:get/get.dart';
import 'package:shop_local/features/splash/controller/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // يتم حقن الـ Controller هنا ليعمل مع الصفحة بشكل مستقل
    Get.lazyPut<SplashController>(() => SplashController());
  }
}