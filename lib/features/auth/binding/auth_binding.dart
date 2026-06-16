import 'package:get/get.dart';
import '../controller/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // نستخدم fenix: true لضمان أن GetX يعيد تشغيل الكنترولر تلقائياً إذا تم حذفه من الذاكرة أثناء التنقل
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
  }
}