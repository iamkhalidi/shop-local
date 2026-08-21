import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_local/services/connectivity_service.dart';
import 'package:shop_local/services/no_internet_overlay.dart';
import 'routes/app_pages.dart';
import 'features/auth/binding/auth_binding.dart';
import 'package:web/web.dart' as web;
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shop_local/services/store_service.dart';
import 'package:shop_local/services/snackbar_service.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/widgets/custom_snackbar_host.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  
  // إبقاء شاشة الترحيب ظاهرة فقط على الموبايل (أندرويد و iOS) لتجنب الخطأ في الويب
  if (!kIsWeb) {
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  }

  if (kIsWeb) {
    usePathUrlStrategy();
    web.window.history.replaceState(null, 'Home', '/');
    WidgetsBinding.instance.platformDispatcher.defaultRouteName;
  }

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyClYQMoFG_19uc-r0vX8bJ9DWVlaEJNfj4",
        authDomain: "shop-local-4d81d.firebaseapp.com",
        projectId: "shop-local-4d81d",
        storageBucket: "shop-local-4d81d.firebasestorage.app",
        messagingSenderId: "364379889376",
        appId: "1:364379889376:web:67c526725d08c6e1d7fa85",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  // حقن خدمات النظام الأساسية (بدون await لإسراع تشغيل التطبيق)
  Get.putAsync(() async => ConnectivityService());
  Get.putAsync(() async => StoreService());
  Get.put(SnackbarService(), permanent: true); 

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Shop Local",
      debugShowCheckedModeBanner: false,
      initialBinding: AuthBinding(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        fontFamily: 'Cairo', // 🚀 الحل الأكثر استقراراً لضمان عمل الأيقونات والخط العربي معاً
      ),
      builder: (context, child) {
        final connectivityService = ConnectivityService.instance;
        return Obx(() {
          final bool isOffline = connectivityService.status.value == ConnectivityStatus.offline;
          return Stack(
            children: [
              if (child != null) child,
              if (isOffline) const NoInternetOverlay(),
              // 🌟 إضافة مستضيف السناك بار الزجاجي ليظهر فوق كل الشاشات
              const CustomSnackbarHost(),
            ],
          );
        });
      },
    );
  }
} // 🌟 تم تعديل القوس هنا ليغلق الكلاس بشكل صحيح بدلاً من الفاصلة التي كانت موجودة بالخطأ

