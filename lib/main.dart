
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_pages.dart';
import 'features/auth/binding/auth_binding.dart'; // <--- أضفنا هذا الإستيراد للـ Binding الجديد
import 'package:web/web.dart' as web;
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  // للتأكد من تهيئة الـ Flutter Widgets قبل تشغيل أي شيء آخر
  WidgetsFlutterBinding.ensureInitialized();

  // 3. هذا الجزء يقوم بتصفير المسار وإجبار المتصفح على فتح صفحة الـ Splash عند عمل الـ Hot Restart
  if (kIsWeb) {
    usePathUrlStrategy(); // للتخلص من علامة /#/ المزعجة وجعل الروابط احترافية (مثل localhost:49537/)

    // 🌟 الحل الحاسم: تغيير مسار شريط عنوان المتصفح برمجياً إلى المسار الرئيسي '/'
    // هذا السطر يضمن أنه عند عمل Hot Restart، سيتغير الرابط في الأعلى فوراً ويصبح http://localhost:49537/
    web.window.history.replaceState(null, 'Home', '/');

    WidgetsBinding.instance.platformDispatcher.defaultRouteName; // تصفير الـ Route الأساسي في المحرك
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
    // 👇 2. أضف هذا السطر هنا ليقوم بالرفع الذكي التلقائي فور تشغيل التطبيق
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
