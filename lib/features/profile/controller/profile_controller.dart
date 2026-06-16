import 'package:get/get.dart';
import '../../auth/controller/auth_controller.dart';

class ProfileController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();

  // 📧 جلب البريد الإلكتروني
  String get userEmail => _authController.firebaseUser.value?.email ?? "جاري تحميل البريد...";



// 👤 جلب الاسم الكامل بعد فصله
  String get userName {
    final displayName = _authController.firebaseUser.value?.displayName ?? "";
    if (displayName.contains('|')) {
      return displayName.split('|')[0]; // يأخذ الجزء الأول وهو الاسم
    }
    return displayName.isNotEmpty ? displayName : "جاري تحميل الاسم...";
  }





// 📱 جلب رقم الجوال بعد فصله
  String get userPhone {
    final displayName = _authController.firebaseUser.value?.displayName ?? "";
    if (displayName.contains('|')) {
      return displayName.split('|')[1]; // يأخذ الجزء الثاني وهو الرقم
    }
    return "لم يتم ربط رقم الجوال";
  }

  void logout() {
    _authController.signOut();
  }
}