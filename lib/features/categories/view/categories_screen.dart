import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import 'products_screen.dart';
import 'product_info_screen.dart';

class CategoriesScreen extends GetView<DashboardController> {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // قائمة تجريبية للفئات لمحاكاة المتاجر الحقيقية
    final List<Map<String, dynamic>> categories = [
      {'name': 'الأزياء', 'icon': Icons.checkroom, 'color': Colors.orange.shade100},
      {'name': 'الإلكترونيات', 'icon': Icons.devices, 'color': Colors.blue.shade100},
      {'name': 'البقالة', 'icon': Icons.local_grocery_store, 'color': Colors.green.shade100},
      {'name': 'الصحة والجمال', 'icon': Icons.content_cut, 'color': Colors.purple.shade100},
      {'name': 'المنزل والمطبخ', 'icon': Icons.kitchen, 'color': Colors.teal.shade100},
      {'name': 'الألعاب', 'icon': Icons.sports_esports, 'color': Colors.pink.shade100},
    ];

    // هنا نقوم بالاستماع التلقائي لعرض الصفحة المطلوبة بناءً على اختيار المستخدم
    return Obx(() {
      // 🌟 تم تصحيح العلامة هنا لتصبح == واحدة فقط
      if (controller.currentCategoryPage.value == 1) {
        return const ProductsScreen(); // عرض صفحة المنتجات
      } else if (controller.currentCategoryPage.value == 2) {
        return const ProductInfoScreen(); // عرض صفحة تفاصيل المنتج
      }

      // الافتراضي (0): عرض قائمة الفئات الأساسية
      return Scaffold(
        appBar: AppBar(title: const Text('الفئات'), centerTitle: true),
        body: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 90.0), // مسافة أمان لكي لا يغطي عليها الـ Nav Bar
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // الانتقال لصفحة المنتجات وتمرير اسم الفئة
                  controller.goToProducts(categories[index]['name']);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: categories[index]['color'],
                        child: Icon(categories[index]['icon'], color: Colors.black87, size: 28),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        categories[index]['name'],
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }
}