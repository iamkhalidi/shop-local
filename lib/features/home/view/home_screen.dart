import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controller/home_controller.dart';
import '../../auth/controller/auth_controller.dart';
import '../../dashboard/controller/dashboard_controller.dart'; // استيراد كنترولر الداشبورد للتحكم بالصفحات
import '../../categories/controller/products_controller.dart'; // استيراد متحكم المنتجات لحفظ المنتج المختار

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    // جلب الـ DashboardController والـ ProductsController لعملية التنقل وحفظ البيانات
    final dashboardController = Get.find<DashboardController>();
    final productsController = Get.find<ProductsController>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Shop Local', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
              icon: const Icon(Icons.person, color: Colors.blue),
              label: const Text(
                'الحساب',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blue),
              ),
              onPressed: () {
                Get.toNamed(Routes.PROFILE);
              },
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('مرحباً بك، استكشف المنتجات المحلية', style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 20),

            // عرض التصنيفات بشكل أفقي ديناميكي من الفايربيس
            SizedBox(
              height: 44,
              child: Obx(() {
                if (controller.isLoadingCategories.value) {
                  return const Center(child: LinearProgressIndicator());
                }

                if (controller.categories.isEmpty) {
                  return const Text("لا توجد فئات");
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final category = controller.categories[index];
                    return Obx(() {
                      final isSelected = controller.selectedCategoryIndex.value == index;
                      return GestureDetector(
                        onTap: () => controller.changeCategory(index),
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: isSelected ? Colors.blue : Colors.grey.withOpacity(0.2)),
                          ),
                          child: Center(
                            child: Text(
                              category.nameAr,
                              style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black87,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      );
                    });
                  },
                );
              }),
            ),

            const SizedBox(height: 25),

            // واجهة المنتجات الديناميكية بالتصميم الكامل المتطابق
            Expanded(
              child: Obx(() {
                if (controller.isLoadingProducts.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.productsList.isEmpty) {
                  return const Center(
                    child: Text(
                      'لا توجد منتجات متوفرة في هذه الفئة حالياً.',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  );
                }

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.72, // نفس النسبة المتوافقة مع الحقول الجديدة في ProductsScreen
                  ),
                  itemCount: controller.productsList.length,
                  itemBuilder: (context, index) {
                    final product = controller.productsList[index];

                    return GestureDetector(
                      // ابحث عن الـ onTap الخاص ببطاقة المنتج داخل الـ GridView واستبدله بهذا:
                      onTap: () {
                        // 1. تخزين المنتج المختار
                        productsController.selectedProduct.value = product;

                        // 2. تحديث بيانات الاسم والسعر في الـ DashboardController
                        dashboardController.selectedProductName.value = product.name;
                        dashboardController.selectedProductPrice.value = "${product.currentPrice} ريال";

                        // 3. 🌟 إعلام الكنترولر أننا قادمون من الهوم
                        dashboardController.isComingFromHome.value = true;

                        // 4. التوجيه لصفحة تفاصيل المنتج داخل تبويب الفئات
                        dashboardController.currentIndex.value = 1;
                        dashboardController.currentCategoryPage.value = 2;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey.withOpacity(0.15)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 5,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // صورة محاكاة للمنتج
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(Icons.shopping_bag_outlined, size: 50, color: Colors.blue),
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  // اسم المنتج الحقيقي
                                  Text(
                                    product.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),

                                  // الحجم أو الوزن (مثال: 1.4 لتر)
                                  Text(
                                    "${product.sizeVolume > 0 ? product.sizeVolume : ''} ${product.unitType}",
                                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                                    textAlign: TextAlign.start,
                                  ),
                                  const SizedBox(height: 5),

                                  // السعر وزر الإضافة السريعة
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          '${product.currentPrice} ريال',
                                          style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14)
                                      ),
                                      Icon(Icons.add_circle, color: Colors.blue.withOpacity(0.8), size: 24),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // شارة الخصم تظهر ديناميكياً إذا وُجد خصم
                            if (product.hasDiscount)
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    "خصم",
                                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}







// onTap: () {
//                         // 1. تخزين المنتج الذي تم الضغط عليه في الـ ProductsController الموحد
//                         productsController.selectedProduct.value = product;
//
//                         // 2. تحديث بيانات الاسم والسعر في الـ DashboardController
//                         dashboardController.selectedProductName.value = product.name;
//                         dashboardController.selectedProductPrice.value = "${product.currentPrice} ريال";
//
//                         // 3. توجيه الداشبورد: الانتقال أولاً لتبويب "الفئات" (index = 1)
//                         dashboardController.currentIndex.value = 1;
//                         // 4. الانتقال مباشرة بداخل التبويب إلى شاشة تفاصيل المنتج (page = 2)
//                         dashboardController.currentCategoryPage.value = 2;
//                       },