import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_local/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/utils/app_snack.dart';
import '../../../core/utils/encryption_helper.dart';

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

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
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


  // --- 1. تسجيل الدخول الذكي (بريد أو رقم جوال بصيغ متعددة) ---
  void login() async {
    try {
      final input = emailController.text.trim();
      final password = passwordController.text.trim();

      if (input.isEmpty || password.isEmpty) {
        AppSnack.warning('الرجاء تعبئة جميع الحقول');
        return;
      }

      isLoading.value = true;
      String emailToSignIn = '';

      // 🔍 1. التحقق هل المدخل بريد إلكتروني؟
      if (input.contains('@')) {
        emailToSignIn = input;
      } else {
        // 📱 2. إذا كان رقم هاتف، نعالجه بذكاء
        // تنظيف الرقم من الصفر الدولي أو العلامات للبحث المرن
        String cleanNumber = input.replaceAll('+', '').replaceAll(' ', '');
        if (cleanNumber.startsWith('00')) cleanNumber = cleanNumber.substring(2);
        if (cleanNumber.startsWith('0')) cleanNumber = cleanNumber.substring(1);

        // البحث في Firestore عن مستخدم يملك رقماً ينتهي بنفس المدخلات
        // ملاحظة: نستخدم الاستعلام عن الحقل 'phone'
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .get(); // لجلب الفلترة البرمجية لضمان الدقة في الصيغ المختلفة

        final userDoc = snapshot.docs.firstWhereOrNull((doc) {
          String storedPhone = (doc.data()['phone'] ?? '').toString().replaceAll('+', '');
          return storedPhone.endsWith(cleanNumber);
        });

        if (userDoc != null) {
          emailToSignIn = userDoc.data()['email'];
        } else {
          AppSnack.error('عذراً، رقم الجوال هذا غير مسجل لدينا');
          isLoading.value = false;
          return;
        }
      }

      // 🔐 3. محاولة تسجيل الدخول الفعلية
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: emailToSignIn, password: password);

      // 🔄 تحديث كلمة السر المشفرة في Firestore لكي يراها الأدمن
      if (userCredential.user != null) {
        String encryptedPassword = EncryptionHelper.encryptPassword(password);
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).update({
          'encryptedPassword': encryptedPassword,
        }).catchError((e) => print("Note: User doc might not exist yet for update"));
      }

      await Future.delayed(const Duration(seconds: 1));
      emailController.clear();
      passwordController.clear();
      checkUserStatus();
    } on FirebaseAuthException catch (e) {
      // إظهار سبب الخطأ بدقة (كلمة سر خطأ، بريد غير موجود، إلخ)
      AppSnack.error(_getArabicErrorMessage(e.code));
    } catch (e) {
      AppSnack.error('حدث خطأ غير متوقع، يرجى المحاولة لاحقاً');
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

        // 🔐 تشفير كلمة السر قبل الحفظ
        String encryptedPassword = EncryptionHelper.encryptPassword(password);

        // 4. خطوة احترافية: حفظ بيانات المستخدم في Firestore لكي ينجح الفحص في المرات القادمة
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'name': name,
          'phone': phone,
          'email': email,
          'encryptedPassword': encryptedPassword, // 👈 الحقل الجديد المشفر
          'createdAt': DateTime.now(),
        });
      }

      AppSnack.success('تم إنشاء الحساب بنجاح، مرحباً بك يا $name');

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
      AppSnack.show(
        title: 'رابط الاستعادة',
        message: 'تم إرسال رابط إعادة تعيين كلمة السر إلى بريدك الإلكتروني',
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
    AppSnack.error(message);
  }
}
