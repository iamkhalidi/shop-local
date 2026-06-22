import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;
import 'dart:async';

enum ConnectivityStatus { online, offline, weak }

class ConnectivityService extends GetxService {
  static ConnectivityService get instance => Get.find();

  // متغير مراقب لحالة الإنترنت الحالية
  final Rx<ConnectivityStatus> status = ConnectivityStatus.online.obs;

  StreamSubscription? _onlineSub;
  StreamSubscription? _offlineSub;
  Timer? _pingTimer;

  @override
  void onInit() {
    super.onInit();
    _checkInitialStatus();
    _initWebListeners();
    _startPeriodicPing();
  }

  void _checkInitialStatus() {
    if (kIsWeb && html.window.navigator.onLine == false) {
      status.value = ConnectivityStatus.offline;
    }
  }

  void _initWebListeners() {
    if (kIsWeb) {
      _onlineSub = html.window.onOnline.listen((_) {
        _updateStatusAndShowSnackbar(ConnectivityStatus.online);
      });

      _offlineSub = html.window.onOffline.listen((_) {
        _updateStatusAndShowSnackbar(ConnectivityStatus.offline);
      });
    }
  }

  void _startPeriodicPing() {
    _pingTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      // نفعّل الفحص الدوري الذكي للموبايل دائماً، وللويب فقط إذا كان المتصفح يعتقد أنه متصل
      if (!kIsWeb || (kIsWeb && html.window.navigator.onLine != false)) {
        _executePingCheck();
      }
    });
  }

  Future<void> _executePingCheck() async {
    if (kIsWeb) {
      if (html.window.navigator.onLine == true) {
        _updateStatusAndShowSnackbar(ConnectivityStatus.online);
      } else {
        _updateStatusAndShowSnackbar(ConnectivityStatus.offline);
      }
      return;
    }

    // كود الموبايل
    final url = Uri.parse('https://www.gstatic.com/generate_204');
    final stopwatch = Stopwatch()..start();

    try {
      final response = await http.head(url).timeout(const Duration(milliseconds: 3000));
      stopwatch.stop();

      if (response.statusCode == 204 || response.statusCode == 200) {
        if (stopwatch.elapsedMilliseconds > 2200) {
          _updateStatusAndShowSnackbar(ConnectivityStatus.weak); // 👈 إنترنت ضعيف
        } else {
          _updateStatusAndShowSnackbar(ConnectivityStatus.online); // 👈 إنترنت ممتاز
        }
      } else {
        _updateStatusAndShowSnackbar(ConnectivityStatus.offline);
      }
    } catch (_) {
      stopwatch.stop();
      _updateStatusAndShowSnackbar(ConnectivityStatus.offline);
    }
  }

  // 🌟 الدالة السحرية لإدارة الحالات وإظهار الـ Snackbars في المكان الصحيح
  void _updateStatusAndShowSnackbar(ConnectivityStatus newStatus) {
    // نحفظ الحالة القديمة قبل التحديث
    ConnectivityStatus previousStatus = status.value;

    // إذا لم تتغير الحالة، لا نفعل شيئاً (لمنع تكرار الـ Snackbars المزعجة)
    if (previousStatus == newStatus) return;

    // تحديث الحالة الفعلية ليراها التطبيق وشاشة الحجب
    status.value = newStatus;

    // 1️⃣ حالة: عودة الإنترنت بعد انقطاعه
    if (previousStatus == ConnectivityStatus.offline && newStatus == ConnectivityStatus.online) {
      _showSuccessSnackbar('تم استعادة الاتصال بالإنترنت بنجاح.');
    }

    // 2️⃣ حالة: الإنترنت أصبح ضعيفاً
    else if (newStatus == ConnectivityStatus.weak) {
      _showWeakInternetSnackBar();
    }
  }

  // 🟢 سناك بار عودة الإنترنت (في الأسفل باللون الأخضر)
  void _showSuccessSnackbar(String message) {
    Get.closeCurrentSnackbar(); // إغلاق أي سناك بار مفتوح فوراً
    Get.snackbar(
      'متصل الآن',
      message,
      snackPosition: SnackPosition.BOTTOM, // 👈 في الأسفل كما طلبت
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      icon: const Icon(Icons.wifi, color: Colors.white),
      margin: const EdgeInsets.all(15),
      duration: const Duration(seconds: 3),
    );
  }

  // 🟠 سناك بار الإنترنت الضعيف (في الأسفل باللون البرتقالي)
  bool _isWeakSnackBarVisible = false;
  void _showWeakInternetSnackBar() {
    if (_isWeakSnackBarVisible) return;
    _isWeakSnackBarVisible = true;

    Get.closeCurrentSnackbar();
    Get.snackbar(
      'تنبيه الشبكة',
      'اتصال الإنترنت لديك ضعيف وغير مستقر حالياً.',
      snackPosition: SnackPosition.BOTTOM, // 👈 في الأسفل باللون البرتقالي كما طلبت
      backgroundColor: Colors.orange.shade800,
      colorText: Colors.white,
      icon: const Icon(Icons.signal_wifi_bad, color: Colors.white),
      margin: const EdgeInsets.all(15),
      duration: const Duration(seconds: 4),
    ).future.then((_) => _isWeakSnackBarVisible = false);
  }

  @override
  void onClose() {
    _onlineSub?.cancel();
    _offlineSub?.cancel();
    _pingTimer?.cancel();
    super.onClose();
  }
}












// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:universal_html/html.dart' as html;
// import 'dart:async';
// import 'package:flutter/foundation.dart'; // 👈 أضف هذا السطر في أعلى ملف الخدمة ليعمل kIsWeb
//
// enum ConnectivityStatus { online, offline, weak }
//
// class ConnectivityService extends GetxService {
//   static ConnectivityService get instance => Get.find();
//
//   // متغير مراقب لحالة الإنترنت الحالية
//   final Rx<ConnectivityStatus> status = ConnectivityStatus.online.obs;
//
//   StreamSubscription? _onlineSub;
//   StreamSubscription? _offlineSub;
//   Timer? _pingTimer;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _checkInitialStatus();
//     _initWebListeners();
//     _startPeriodicPing();
//   }
//
//   // الفحص الأولي الفوري عند تشغيل التطبيق
//   void _checkInitialStatus() {
//     if (html.window.navigator.onLine == false) {
//       status.value = ConnectivityStatus.offline;
//     }
//   }
//
//   // ربط مستمعات المتصفح الأصلية للويب (استجابة فورية بدون استهلاك بيانات)
//   void _initWebListeners() {
//     _onlineSub = html.window.onOnline.listen((_) {
//       _executePingCheck(); // للتأكد من جودة الإشارة فور عودتها
//     });
//
//     _offlineSub = html.window.onOffline.listen((_) {
//       status.value = ConnectivityStatus.offline;
//     });
//   }
//
//   // فحص دوري ذكي كل 10 ثوانٍ للتأكد من جودة الشبكة (إنترنت ضعيف أو معلق)
//   void _startPeriodicPing() {
//     _pingTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
//       if (status.value != ConnectivityStatus.offline) {
//         _executePingCheck();
//       }
//     });
//   }
//
// // دالة الفحص الذكية والمصححة للويب والموبايل معاً
//   Future<void> _executePingCheck() async {
//     // 🌟 أولاً: إذا كنا نعمل على بيئة الويب، المتصفح يعرف تماماً إن كان هناك إنترنت أم لا
//     if (kIsWeb) {
//       if (html.window.navigator.onLine == true) {
//         status.value = ConnectivityStatus.online;
//       } else {
//         status.value = ConnectivityStatus.offline;
//       }
//       return; // ننهي الدالة هنا للويب ولا نكمل لطلب الـ HTTP لتجنب خطأ الـ CORS
//     }
//
//     // 🌟 ثانياً: كود الموبايل (Android / iOS) - هنا يعمل الـ Ping بدون مشاكل CORS
//     final url = Uri.parse('https://www.gstatic.com/generate_204');
//     final stopwatch = Stopwatch()..start();
//
//     try {
//       final response = await http.head(url).timeout(const Duration(milliseconds: 3000));
//       stopwatch.stop();
//
//       if (response.statusCode == 204 || response.statusCode == 200) {
//         if (stopwatch.elapsedMilliseconds > 2200) {
//           status.value = ConnectivityStatus.online;
//           _showWeakInternetSnackBar();
//         } else {
//           status.value = ConnectivityStatus.online;
//         }
//       } else {
//         status.value = ConnectivityStatus.offline;
//       }
//     } catch (_) {
//       stopwatch.stop();
//       // في الموبايل إذا فشل الطلب تماماً، فالإنترنت مقطوع يقيناً
//       status.value = ConnectivityStatus.offline;
//     }
//   }
//
//   bool _isSnackBarVisible = false;
//   void _showWeakInternetSnackBar() {
//     if (_isSnackBarVisible) return;
//     _isSnackBarVisible = true;
//
//     Get.snackbar(
//       'تنبيه الشبكة',
//       'اتصال الإنترنت لديك غير مستقر حالياً، قد تواجه بطئاً في تحميل البيانات.',
//       snackPosition: SnackPosition.TOP,
//       backgroundColor: Colors.amber.shade700,
//       colorText: Colors.white,
//       duration: const Duration(seconds: 4),
//     ).future.then((_) => _isSnackBarVisible = false);
//   }
//
//   @override
//   void onClose() {
//     _onlineSub?.cancel();
//     _offlineSub?.cancel();
//     _pingTimer?.cancel();
//     super.onClose();
//   }
// }