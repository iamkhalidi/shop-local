import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_local/features/splash/view/splash_screen.dart';

import 'features/splash/binding/splash_binding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop Local',
      initialRoute: '/splash',
      getPages: [
        GetPage(
          name: '/splash',
          page: () => const SplashScreen(),
          binding: SplashBinding(), // هنا قمنا بربط الـ Binding بالصفحة
        ),
        // باقي الصفحات...
      ],
    );
  }
}
