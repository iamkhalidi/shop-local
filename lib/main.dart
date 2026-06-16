
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_pages.dart';
import 'features/auth/binding/auth_binding.dart'; // <--- أضفنا هذا الإستيراد للـ Binding الجديد

void main() async {
  // للتأكد من تهيئة الـ Flutter Widgets قبل تشغيل أي شيء آخر
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    // يمنع المتصفح من التخمين ويجبره على تشغيل محرك متوافق مع الأيقونات
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Shop Local",
      debugShowCheckedModeBanner: false,
      // الـ initialBinding يضمن حقن الـ AuthController فور تشغيل التطبيق لفحص حالة المستخدم
      initialBinding: AuthBinding(), // <--- هذا هو السطر الذي أضفناه لتفعيل الـ Binding
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
          textTheme: GoogleFonts.cairoTextTheme(Theme.of(context).textTheme),
      ),
    );
  }
}
