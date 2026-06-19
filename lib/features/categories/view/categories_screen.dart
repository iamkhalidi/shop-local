import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../controller/categories_controller.dart'; // استيراد الكنترولر الجديد
import 'products_screen.dart';
import 'product_info_screen.dart';

class CategoriesScreen extends GetView<DashboardController> {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // حقن الكنترولر الخاص بالفئات للوصول لبيانات الفايربيس
    final CategoriesController categoriesController = Get.put(CategoriesController());

    return Obx(() {
      if (controller.currentCategoryPage.value == 1) {
        return const ProductsScreen(); // عرض صفحة المنتجات
      } else if (controller.currentCategoryPage.value == 2) {
        return const ProductInfoScreen(); // عرض صفحة تفاصيل المنتج
      }

      // الافتراضي (0): عرض قائمة الفئات الأساسية من الفايربيس
      return Scaffold(
        appBar: AppBar(title: const Text('الفئات'), centerTitle: true),
        body: Obx(() {
          // 1. عرض مؤشر انتظار في حال كانت البيانات قيد التحميل من السيرفر
          if (categoriesController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. في حال فرغت قاعدة البيانات أو لا يوجد اتصال
          if (categoriesController.categories.isEmpty) {
            return const Center(
              child: Text(
                'لا توجد فئات متاحة حالياً، تحقق من السيرفر',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          // 3. عرض شبكة الفئات بالتصميم الأصلي الخاص بك
          return Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 90.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              itemCount: categoriesController.categories.length,
              itemBuilder: (context, index) {
                final category = categoriesController.categories[index];

                // تحويل كود الـ Hex النصي القادم من فايربيس (مثل FFFCEBE2) إلى لون حقيقي داخل فلاتر
                final int colorHex = int.parse(category.color, radix: 16);

                return GestureDetector(
                  onTap: () {
                    // الانتقال لصفحة المنتجات وتمرير الـ ID الفرعي للفئة لجلب منتجاتها الـ 10
                    controller.goToProducts(category.id);
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
                          backgroundColor: Color(colorHex), // اللون الديناميكي الحقيقي
                          child: Icon(
                            categoriesController.convertStringToIcon(category.icon), // الأيقونة الحية
                            color: Colors.black87,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          category.nameAr, // الاسم العربي القادم من الفايربيس
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }),
      );
    });
  }
}