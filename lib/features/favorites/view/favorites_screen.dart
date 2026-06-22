// lib/features/favorites/view/favorites_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../categories/controller/products_controller.dart'; // استيراد كنترولر المنتجات لتمرير المنتج المختار
import '../../dashboard/controller/dashboard_controller.dart'; // استيراد دالة التنقل للتفاصيل
import '../controller/favorites_controller.dart';

class FavoritesScreen extends GetView<FavoritesController> {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // إيجاد الكنترولرز المطلوبة لإدارة التفاعلات بسلاسة عند الضغط والتنقل
    final DashboardController dashboardController = Get.find<DashboardController>();
    final ProductsController productsController = Get.find<ProductsController>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('الأصناف المفضلة', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.favoriteProducts.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 70, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  "قائمة المفضلة فارغة حالياً.",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          );
        }

        // 🌟 تحويل العرض إلى تصميم شبكي متجاور (GridView) مطابق تماماً لـ ProductsScreen 🌟
        return GridView.builder(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 90.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 0.72, // الحفاظ على التناسق الطولي والعرضي للكارت
          ),
          itemCount: controller.favoriteProducts.length,
          itemBuilder: (context, index) {
            final product = controller.favoriteProducts[index];

            return GestureDetector(
              onTap: () {

                productsController.selectedProduct.value = product;
                dashboardController.isComingFromHome.value = false; // لم نأتِ من الهوم

                Get.toNamed(Routes.PRODUCT_INFO);

                // // عند الضغط، يتم تحديد المنتج الحالي لفتحه في صفحة التفاصيل بشكل صحيح
                // productsController.selectedProduct.value = product;
                // dashboardController.goToProductInfo(product.name, "${product.currentPrice} ريال");
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
                          // مساحة عرض صورة المنتج الحقيقية مع التأمين ضد الأخطاء
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: product.imageUrl.isNotEmpty
                                    ? Image.network(
                                  product.imageUrl,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.shopping_bag_outlined, size: 50, color: Colors.blue);
                                  },
                                )
                                    : const Icon(Icons.shopping_bag_outlined, size: 50, color: Colors.blue),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // اسم المنتج المفضّل
                          Text(
                            product.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),

                          // الحجم / الوزن
                          Text(
                            "${product.sizeVolume > 0 ? product.sizeVolume : ''} ${product.unitType}",
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(height: 5),

                          // السعر الحالي وأيقونة الإضافة السريعة للسلة
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${product.currentPrice} ريال',
                                style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              Icon(Icons.add_circle, color: Colors.blue.withOpacity(0.8), size: 24),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // شارة الخصم الذكية (تظهر إذا كان للمنتج خصم فعلي في Firestore)
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

                    // زر القلب التفاعلي الأحمر في أعلى اليمين للقدرة على إلغاء التفضيل فوراُ
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.favorite, color: Colors.red, size: 22),
                        onPressed: () {
                          controller.toggleFavorite(product);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

