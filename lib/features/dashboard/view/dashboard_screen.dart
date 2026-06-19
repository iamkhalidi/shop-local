import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/view/home_screen.dart';
import '../../categories/view/categories_screen.dart';
import '../../cart/view/cart_screen.dart';
import '../controller/dashboard_controller.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // مصفوفة الشاشات الثلاثة المطلوبة
    final List<Widget> pages = [
      const HomeScreen(),
      const CategoriesScreen(),
      const CartScreen(),
    ];

    return Scaffold(
      // الـ extendBody يسمح للمحتوى بالنزول خلف الشريط السفلي الزجاجي ليعطي تأثير الشفافية العميق
      extendBody: true,
      body: Obx(() => IndexedStack(
        index: controller.currentIndex.value,
        children: pages,
      )),

      // 🛠️ التعديل الأول: إضافة الـ SafeArea هنا لحماية الأزرار من التداخل مع نظام الجوال
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10), // تم تقليل الـ bottom لتتكفل الـ SafeArea بالباقي
          child: Container(
            height: 65, // تم ضبط الارتفاع ليتناسق مع التصميم الجديد
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04), // ظل ناعم جداً يناسب الزجاج
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                // 🛠️ التعديل الثاني: زيادة الـ blur ليعطي تأثير الـ Liquid Glass الحقيقي
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  color: Colors.white.withOpacity(0.35), // 🌟 تقليل النسبة لـ 0.35 لتمرير الألوان الخلفية بوضوح
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(Icons.home_outlined, Icons.home, 'الرئيسية', 0),
                      _buildNavItem(Icons.grid_view_outlined, Icons.grid_view_rounded, 'الفئات', 1),
                      _buildNavItem(Icons.shopping_bag_outlined, Icons.shopping_bag, 'السلة', 2),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ويدجت لبناء أزرار شريط التنقل المحدثة بالمقاسات الجديدة
  Widget _buildNavItem(IconData unselectedIcon, IconData selectedIcon, String label, int index) {
    return Obx(() {
      final isSelected = controller.currentIndex.value == index;
      return GestureDetector(
        onTap: () => controller.changePage(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12), // 📐 تقليص الـ padding الداخلي للتناسب مع الارتفاع الجديد
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center, // توسيط المحتوى عمودياً
            children: [
              Icon(
                isSelected ? selectedIcon : unselectedIcon,
                color: isSelected ? Colors.blue.shade500 : Colors.grey.shade400,
                size: 24, // تم ضبط الحجم لـ 24
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11, // حجم خط مناسب يمنع التداخل أو النزول لأسفل
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.blue.shade700 : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
