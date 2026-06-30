import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';

class NotificationHelper {
  static final AudioPlayer _audioPlayer = AudioPlayer();

  static Future<void> triggerOrderSuccessNotification() async {
    try {
      // 1. تشغيل صوت الإشعار من الـ assets
      // await _audioPlayer.play(AssetSource('assets/lib/core/assets/sounds/mixkit-noti-sound.mp3'));
      await _audioPlayer.play(UrlSource('assets/lib/core/assets/sounds/mixkit-noti-sound.mp3'));
    } catch (e) {
      debugPrint("خطأ في تشغيل صوت الإشعار: $e");
    }

    // 2. إظهار سناك بار صغير وخفيف أسفل الشاشة باللهجة السعودية
    Get.rawSnackbar(
      messageText: const Text(
        "طلبك تأكد وجالس يتجهز! تلاقيه في صفحة 'طلباتي'",
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontFamily: 'Cairo', // أو الخط المستخدم في تطبيقك
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.black87,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      borderRadius: 30,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    );
  }

  // 2️⃣ 🚀 إشعار حذف الطلب (الجديد)
  static Future<void> triggerOrderDeleteNotification() async {
    try {
      // تشغيل الصوت المخصص لحذف الطلب باستخدام نفس مسار الويب الـ الحقيقي
      await _audioPlayer.play(UrlSource('assets/lib/core/assets/sounds/mixkit-delete-order-noti-sound.mp3'));
    } catch (e) {
      debugPrint("خطأ في تشغيل صوت حذف الطلب: $e");
    }

    // إظهار السناك بار الأنيق والملموم للحذف
    Get.rawSnackbar(
      messageText: const Text(
        "تم حذف الطلب بنجاح",
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontFamily: 'Cairo',
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.black87,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
      borderRadius: 30,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    );
  }



}