import 'package:get/get.dart';

import '../../auth/controller/auth_controller.dart';


class ProfileController extends GetxController {
  // جلب نسخة الـ AuthController المستقرة في الذاكرة للوصول لبيانات المستخدم وتسجيل الخروج
  final AuthController _authController = Get.find<AuthController>();

  // متغير للحصول على بريد المستخدم الحالي وعرضه في الشاشة
  String get userEmail => _authController.firebaseUser.value?.email ?? "لا يوجد بريد إلكتروني";

  // دالة تسجيل الخروج التي ستستدعى عند الضغط على الزر
  void logout() {
    _authController.signOut();
  }
}