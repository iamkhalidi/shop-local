
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_mall, size: 80, color: Colors.blue),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}













//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shop_local/features/splash/controller/splash_controller.dart';
//
// class SplashScreen extends GetView<SplashController> {
//   const SplashScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         // استخدام AnimatedBuilder لربط الـ UI بالحركة المباشرة داخل الـ Controller
//         child: AnimatedBuilder(
//           animation: controller.animationController,
//           builder: (context, child) {
//             return Opacity(
//               opacity: controller.opacityAnimation.value, // تطبيق قيمة الـ Opacity
//               child: Transform.translate(
//                 offset: Offset(0, controller.translateAnimation.value), // تطبيق قيمة النزول من الأعلى
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const Text(
//                       "Shop Local",
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 16), // بديل للـ spacing إذا كانت تدعم الـ Column في إصدارك
//                     const CircularProgressIndicator(
//                       color: Colors.amber,
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
