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
    // تم نقل حقن الكنترولر للـ DashboardBinding لضمان استهلاك ذاكرة أمثل
    final CategoriesController categoriesController = Get.find<CategoriesController>();

    return Obx(() {
      if (controller.currentCategoryPage.value == 1) {
        return const ProductsScreen(); // عرض صفحة المنتجات
      } else if (controller.currentCategoryPage.value == 2) {
        return const ProductInfoScreen(); // عرض صفحة تفاصيل المنتج
      }

      // الافتراضي (0): عرض قائمة الفئات الأساسية من الفايربيس
      return Scaffold(
        appBar: AppBar(
          title: Obx(() {
            if (categoriesController.isSearchMode.value) {
              return Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  autofocus: true,
                  onChanged: (val) => categoriesController.searchQuery.value = val,
                  decoration: const InputDecoration(
                    hintText: 'ابحث عن فئة...',
                    hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                    prefixIcon: Icon(Icons.search, size: 20, color: Colors.blue),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              );
            }
            return const Text('الفئات', style: TextStyle(fontWeight: FontWeight.bold));
          }),
          centerTitle: true,
          leading: Obx(() => categoriesController.isSearchMode.value
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => categoriesController.toggleSearchMode(),
                )
              : const SizedBox.shrink()),
          actions: [
            Obx(() => !categoriesController.isSearchMode.value
                ? IconButton(
                    icon: const Icon(Icons.search, color: Colors.blue),
                    onPressed: () => categoriesController.toggleSearchMode(),
                  )
                : const SizedBox.shrink()),
          ],
        ),
        body: Obx(() {
          // 1. عرض مؤشر انتظار في حال كانت البيانات قيد التحميل من السيرفر
          if (categoriesController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = categoriesController.displayedCategories;

          // 2. في حال فرغت قاعدة البيانات أو لا يوجد نتائج للبحث
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    categoriesController.searchQuery.isEmpty ? Icons.category_outlined : Icons.search_off,
                    size: 60,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    categoriesController.searchQuery.isEmpty
                        ? 'لا توجد فئات متاحة حالياً'
                        : "لم يتم العثور على نتائج لـ '${categoriesController.searchQuery.value}'",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
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
              itemCount: items.length,
              itemBuilder: (context, index) {
                final category = items[index];

                // تحويل كود الـ Hex النصي القادم من فايربيس (مثل FFFCEBE2) إلى لون حقيقي داخل فلاتر
                final int colorHex = int.parse(category.color, radix: 16);

                return GestureDetector(
                  onTap: () {
                    // الانتقال لصفحة المنتجات وتمرير الـ ID (للجلب) والاسم العربي (للعرض)
                    controller.goToProducts(category.id, category.nameAr);
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