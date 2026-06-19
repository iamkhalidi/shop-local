import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_local/features/home/view/home_screen.dart';

import '../../../data/database/firestore_seeder.dart';
import '../../auth/controller/auth_controller.dart';

class SplashController extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> opacityAnimation;
  late Animation<double> translateAnimation;

  @override
  void onInit() {
    super.onInit();

    // إعداد الـ AnimationController بمدة 1.5 ثانية للأنيميشن بالكامل
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // إعداد حركة الشفافية (Opacity) من 0.0 إلى 1.0
    opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn), // تبدأ أولاً
      ),
    );

    // إعداد حركة الإزاحة (Vertical Translation) من أعلى (-130) إلى مكانها الطبيعي (0)
    translateAnimation = Tween<double>(begin: -130.0, end: 0.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut), // تتداخل مع الشفافية بشكل ناعم
      ),
    );

    // بدء تشغيل الأنميشن
    animationController.forward();

    // // 2. 🔥 تشغيل حقن البيانات في الخلفية فوراً عند فتح التطبيق
    // injectDataOnStartup();

    // تشغيل مؤقت الانتقال إلى الصفحة الرئيسية
    navigateToHome();
  }


  // // 👇 دالة مستقلة للحقن حتى لا تعطل الأنميشن أو الانتقال
  // Future<void> injectDataOnStartup() async {
  //   try {
  //     print("⏳ [Seeder] بدأت عملية حقن البيانات من الـ SplashController خلف الكواليس...");
  //     await FirestoreSeeder.seedAllGroceryData();
  //     print("🏁 [Seeder] اكتملت محاولة حقن البيانات بنجاح.");
  //   } catch (e) {
  //     print("❌ [Seeder] فشل الحقن من الـ Splash بسبب: $e");
  //   }
  // }




  Future<void> navigateToHome() async {
    // انتظر 3 ثوانٍ كاملة لعرض الشاشة والأنيميشن
    await Future.delayed(const Duration(seconds: 3));

    // استدعاء دالة الفحص التي أضفناها بالأعلى في الـ AuthController
    Get.find<AuthController>().checkUserStatus();
  }

  @override
  void onClose() {
    // تنظيف الذاكرة وإغلاق الـ AnimationController لحماية موارد الجهاز
    animationController.dispose();
    super.onClose();
  }
}




// import 'package:get/get.dart';
// import 'package:shop_local/features/home/view/home_screen.dart';
// import '../view/splash_screen.dart';
//
// class SplashController extends GetxController {
//   @override
//   void onReady() {
//     navigateToHome();
//     super.onReady();
//   }
//
//   Future navigateToHome() async {
//     await Future.delayed(const Duration(seconds: 3));
//     Get.to(()=>HomeScreen());
//   }
//
//
// }