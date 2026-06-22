import 'package:get/get.dart';
import '../controller/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // استخدام Get.put يضمن حقن الكنترولر بشكل فوري وثابت بمجرد استدعاء الصفحة دون دورة الحذف والـ fenix المزعجة
    Get.put<AuthController>(AuthController(), permanent: false);
  }
}
