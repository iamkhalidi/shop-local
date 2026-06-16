import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_local/routes/app_pages.dart'; // تأكد من صحة مسار الاستيراد للمشروع

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Rxn<User> firebaseUser = Rxn<User>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // نربط الحساب بالخلفية فقط بدون دالة ever التلقائية المستعجلة
    firebaseUser.bindStream(_auth.userChanges());
  }

  // هذه الدالة الذكية التي سيستدعيها الـ SplashController بعد انتهاء الـ 3 ثوانٍ للأنيميشن
  void checkUserStatus() {
    if (_auth.currentUser == null) {
      Get.offAllNamed(Routes.LOGIN);
    } else {
      Get.offAllNamed(Routes.HOME);
    }
  }

  // --- 1. تسجيل الدخول ---
  void login(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      checkUserStatus(); // التوجيه الصحيح بعد نجاح تسجيل الدخول
    } on FirebaseAuthException catch (e) {
      _showErrorSnackBar(_getArabicErrorMessage(e.code));
    } finally {
      isLoading.value = false;
    }
  }

  // --- 2. إنشاء حساب جديد ---
  void register(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      Get.snackbar('تم بنجاح', 'تم إنشاء الحساب بنجاح',
          backgroundColor: Colors.green, colorText: Colors.white);
      checkUserStatus(); // التوجيه بعد نجاح التسجيل مباشرة
    } on FirebaseAuthException catch (e) {
      print("Firebase Register Error Code: ${e.code}");
      _showErrorSnackBar(_getArabicErrorMessage(e.code));
    } finally {
      isLoading.value = false;
    }
  }

  // --- 3. نسيان كلمة السر ---
  void resetPassword(String email) async {
    try {
      isLoading.value = true;
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar(
        'رابط الاستعادة',
        'تم إرسال رابط إعادة تعيين كلمة السر إلى بريدك الإلكتروني',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } on FirebaseAuthException catch (e) {
      _showErrorSnackBar(_getArabicErrorMessage(e.code));
    } finally {
      isLoading.value = false;
    }
  }

  // --- 4. تسجيل الخروج ---
  void signOut() async {
    await _auth.signOut();
    Get.offAllNamed(Routes.LOGIN); // نرجعه لصفحة تسجيل الدخول فوراً عند الخروج
  }

  String _getArabicErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found': return 'لا يوجد مستخدم بهذا البريد الإلكتروني.';
      case 'wrong-password': return 'كلمة المرور غير صحيحة.';
      case 'email-already-in-use': return 'هذا البريد الإلكتروني مستخدم بالفعل.';
      case 'invalid-email': return 'صيغة البريد الإلكتروني غير صحيحة.';
      case 'weak-password': return 'كلمة المرور ضعيفة جداً.';
      default: return 'حدث خطأ غير متوقع، حاول مرة أخرى.';
    }
  }

  void _showErrorSnackBar(String message) {
    Get.snackbar(
      'خطأ', message,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(15),
    );
  }
}