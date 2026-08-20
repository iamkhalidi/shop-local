import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'app_snack.dart';

class NotificationHelper {
  static final AudioPlayer _audioPlayer = AudioPlayer();

  static Future<void> triggerOrderSuccessNotification() async {
    try {
      await _audioPlayer.play(UrlSource('assets/lib/core/assets/sounds/mixkit-noti-sound.mp3'));
    } catch (e) {
      debugPrint("خطأ في تشغيل صوت الإشعار: $e");
    }

    AppSnack.success("طلبك تأكد وجالس يتجهز! تلاقيه في صفحة 'طلباتي'", title: "نجاح الطلب");
  }

  // 2️⃣ 🚀 إشعار حذف الطلب (الجديد)
  static Future<void> triggerOrderDeleteNotification() async {
    try {
      await _audioPlayer.play(UrlSource('assets/lib/core/assets/sounds/mixkit-delete-order-noti-sound.mp3'));
    } catch (e) {
      debugPrint("خطأ في تشغيل صوت حذف الطلب: $e");
    }

    AppSnack.show(title: "تم الحذف", message: "تم حذف الطلب بنجاح");
  }
}
