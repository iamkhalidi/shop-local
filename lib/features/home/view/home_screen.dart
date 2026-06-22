// lib/features/home/view/home_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../cart/controller/cart_controller.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../../categories/controller/products_controller.dart';
import '../controller/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.find<DashboardController>();
    final productsController = Get.find<ProductsController>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
            'Shop Local',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.redAccent, size: 26),
            onPressed: () {
              Get.toNamed(Routes.FAVORITES);
            },
          ),
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
      body: Obx(() {
        // 1. مراقبة حالة تحميل الفئات
        if (controller.isLoadingCategories.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2. التحقق من وجود فئات
        if (controller.categories.isEmpty) {
          return const Center(
            child: Text(
              "لا توجد فئات معروضة حالياً.",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }

        // 3. بناء المصفوفة الرأسية لجميع الفئات أسفل بعضها
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          itemCount: controller.categories.length,
          itemBuilder: (context, categoryIndex) {
            final category = controller.categories[categoryIndex];

            // جلب المنتجات المفلترة الخاصة بهذه الفئة فقط من خريطة الكنترولر
            final categoryProducts = controller.categoryProductsMap[category.id.toLowerCase()] ?? [];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // رأس الفئة (اسم الفئة + زر عرض الكل)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        category.nameAr,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          dashboardController.selectedCategoryName.value = category.id;
                          dashboardController.isComingFromHome.value = true;
                          dashboardController.currentCategoryPage.value = 1;
                          dashboardController.currentIndex.value = 1;
                        },
                        child: const Row(
                          children: [
                            Text('عرض الكل', style: TextStyle(color: Colors.blue, fontSize: 13)),
                            Icon(Icons.arrow_forward_ios, size: 11, color: Colors.blue),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // مصفوفة المنتجات الأفقية الخاصة بالفئة الحالية
                SizedBox(
                  height: 240,
                  child: controller.isLoadingProducts.value
                      ? const Center(child: CircularProgressIndicator())
                      : categoryProducts.isEmpty
                      ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'لا توجد منتجات متوفرة في هذه الفئة.',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ),
                  )
                      : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    itemCount: categoryProducts.length,
                    itemBuilder: (context, productIndex) {
                      final product = categoryProducts[productIndex];

                      return GestureDetector(
                        onTap: () {

                          // 1. تحديد المنتج المختار فوراً في الكنترولر المخصص له
                          Get.find<ProductsController>().selectedProduct.value = product;

                          // 2. إخبار شاشة التفاصيل أننا جئنا من الهوم (لأجل زر الرجوع)
                          dashboardController.isComingFromHome.value = true;

                          // 3. 🚀 الانتقال الاحترافي المباشر كشاشة كاملة دون تداخل التبويبات
                          Get.toNamed(Routes.PRODUCT_INFO);
                        },
                        child: Container(
                          width: 160,
                          margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.withOpacity(0.12)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.06),
                                blurRadius: 6,
                                spreadRadius: 1,
                                offset: const Offset(0, 2),
                              )
                            ],
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[50],
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        // 🌟 تطبيق كود حماية ومعالجة أخطاء روابط الصور بنجاح 🌟
                                        child: product.imageUrl.isNotEmpty
                                            ? ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.network(
                                            product.imageUrl,
                                            fit: BoxFit.cover,
                                            // معالجة التحميل وإظهار مؤشر تقدم دائري صغير
                                            loadingBuilder: (context, child, loadingProgress) {
                                              if (loadingProgress == null) return child;
                                              return const Center(
                                                child: SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: CircularProgressIndicator(strokeWidth: 2),
                                                ),
                                              );
                                            },
                                            // صمام الأمان: إذا فشل الرابط أو منعته الحماية تظهر أيقونة الحقيبة الأنيقة تلقائياً
                                            errorBuilder: (context, error, stackTrace) {
                                              return const Icon(
                                                  Icons.shopping_bag_outlined,
                                                  size: 44,
                                                  color: Colors.blue
                                              );
                                            },
                                          ),
                                        )
                                            : const Icon(
                                            Icons.shopping_bag_outlined,
                                            size: 44,
                                            color: Colors.blue
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),

                                    Text(
                                      product.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.black87
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),

                                    Text(
                                      "${product.sizeVolume > 0 ? product.sizeVolume : ''} ${product.unitType}",
                                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                                    ),
                                    const SizedBox(height: 8),

                        // داخل home_screen.dart ابحث عن الـ Row الخاص بالسعر والزر واستبدله بالآتي:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${product.currentPrice} ريال',
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13
                              ),
                            ),
                            // 🛠️ التعديل السحري هنا: فصل حدث الضغط لمنع التداخل مع كارت المنتج
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () async {
                                // استدعاء السلة مباشرة دون التأثير على تفاصيل المنتج المختار
                                await Get.find<CartController>().addProductToCart(product);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0), // لتوسيع مساحة اللمس للزر
                                child: Icon(
                                    Icons.add_circle,
                                    color: Colors.blue.withOpacity(0.8),
                                    size: 22
                                ),
                              ),
                            ),
                          ],
                        ),
                                  ],
                                ),
                              ),

                              if (product.hasDiscount)
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      "خصم",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
              ],
            );
          },
        );
      }),
    );
  }
}



//
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Text(
// '${product.currentPrice} ريال',
// style: const TextStyle(
// color: Colors.blue,
// fontWeight: FontWeight.bold,
// fontSize: 13
// ),
// ),
// Icon(
// Icons.add_circle,
// color: Colors.blue.withOpacity(0.8),
// size: 22
// ),
// ],
// )