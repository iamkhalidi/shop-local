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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  await Get.putAsync(() async => ConnectivityService());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final connectivityService = ConnectivityService.instance;

    return Obx(() {
      final bool isOffline = connectivityService.status.value == ConnectivityStatus.offline;

      // 🌟 هنا تم إصلاح الخطأ بإضافة كملة return قبل الـ GetMaterialApp
      return GetMaterialApp(
        title: "Shop Local",
        debugShowCheckedModeBanner: false,
        initialBinding: AuthBinding(),
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          textTheme: GoogleFonts.cairoTextTheme(Theme.of(context).textTheme),
        ),
        builder: (context, child) {
          return Stack(
            children: [
              if (child != null) child,
              if (isOffline) const NoInternetOverlay(),
            ],
          );
        },
      );
    });
  }
} // 🌟 تم تعديل القوس هنا ليغلق الكلاس بشكل صحيح بدلاً من الفاصلة التي كانت موجودة بالخطأ

