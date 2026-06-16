import 'package:get/get.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // يحقن مرة واحدة بشكل دائم لمنع التكرار واللوب
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<SplashController>(SplashController());
  }
}