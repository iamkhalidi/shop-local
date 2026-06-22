import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_local/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Rxn<User> firebaseUser = Rxn<User>();
  var isLoading = false.obs;

  // 🌟 السطور  الجديدة: نقل حقول النص إلى الكنترولر للحفاظ على ثباتها أثناء الـ Rebuild
  final emailController = TextEditingController();
  final passwordController = TextEditingController();



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
      Get.offAllNamed(Routes.DASHBOARD);
      // Get.offAllNamed(Routes.HOME);
    }
  }


  // --- 1. تسجيل الدخول ---
  void login() async { // قمنا بإزالة الباراميترز لأنها أصبحت متوفرة محلياً في الكنترولر
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        Get.snackbar(
          'تنبيه',
          'الرجاء تعبئة جميع الحقول',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      await Future.delayed(const Duration(seconds: 1));

      // 🌟 خطوة ذكية: تنظيف الحقول بعد نجاح تسجيل الدخول لكي لا تظل مكتوبة إذا سجل خروج مستقبلاً
      emailController.clear();
      passwordController.clear();

      checkUserStatus();
    } on FirebaseAuthException catch (e) {
      _showErrorSnackBar(_getArabicErrorMessage(e.code));
    } finally {
      isLoading.value = false;
    }
  }



  // --- 2. إنشاء حساب جديد ---
// --- 2. إنشاء حساب جديد مع فحص تكرار رقم الجوال ---
  void register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      // 👇 1. الفحص الذكي: نتحقق أولاً في قاعدة البيانات Firestore هل الرقم موجود؟
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: phone)
          .get();

      // إذا وجدنا أي مستخدم مسجل بنفس هذا الرقم، نوقف التسجيل فوراً
      if (snapshot.docs.isNotEmpty) {
        _showErrorSnackBar("رقم الجوال هذا مستخدم بالفعل من قبل مستخدم آخر!");
        isLoading.value = false; // نطفئ مؤشر التحميل
        return; // 🛑 أمر الخروج: يمنع الكود بالأسفل من العمل ويوقف الدالة هنا
      }

      // --------------------------------------------------------------------
      // إذا لم يجد الرقم مكرراً، سيتخطى الشرط الأعلى ويكمل باقي الكود طبيعي:
      // --------------------------------------------------------------------

      // 2. إنشاء الحساب بالبريد وكلمة السر في Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 3. تحديث الاسم والرقم مدمجين داخل الـ DisplayName
      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName("$name|$phone");

        // 4. خطوة احترافية: حفظ بيانات المستخدم في Firestore لكي ينجح الفحص في المرات القادمة
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'name': name,
          'phone': phone,
          'email': email,
          'createdAt': DateTime.now(),
        });
      }

      Get.snackbar('تم بنجاح', 'تم إنشاء الحساب بنجاح، مرحباً بك يا $name',
          backgroundColor: Colors.green, colorText: Colors.white);

      checkUserStatus();
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
      default: return 'حدث خطأ غير متوقع، تأكد من المدخلات و حاول مرة أخرى.';
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
