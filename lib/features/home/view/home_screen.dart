// lib/features/home/view/home_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../cart/controller/cart_controller.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../../categories/controller/products_controller.dart';
import '../controller/home_controller.dart';
import '../../../services/store_service.dart';
import '../../favorites/controller/favorites_controller.dart'; // 👈 استيراد كنترولر المفضلة

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.find<DashboardController>();
    final productsController = Get.find<ProductsController>();
    final favoritesController = Get.find<FavoritesController>(); // 👈 جلب نسخة كنترولر المفضلة
    final storeService = StoreService.instance;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Obx(() => Text(
            storeService.storeName.value,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            maxLines: 1,
            overflow: TextOverflow.ellipsis, // 🚀 منع الـ Overflow بنقاط
        )),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 140, // 👈 تقليل العرض لإعطاء مساحة أكبر للعنوان
        // 🕒 عرض أوقات العمل كمستطيل متدلي أسفل الـ AppBar
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Obx(() {
            final config = storeService.storeConfig.value;
            if (config == null || config.openTime.isEmpty) return const SizedBox.shrink();
            return Container(
              margin: const EdgeInsets.only(bottom: 5),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade600,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.access_time_filled, size: 12, color: Colors.white),
                  const SizedBox(width: 6),
                  Text(
                    'نستقبلكم من ${config.openTime} إلى ${config.closeTime}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. زر طلباتي
            TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              icon: const Icon(Icons.receipt_long, color: Colors.orange, size: 18),
              label: const Text(
                'طلباتي',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
              ),
              onPressed: () => Get.toNamed(Routes.ORDERS),
            ),
            // 2. زر المفضلة
            Obx(() {
              final count = favoritesController.favoriteProducts.length;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.redAccent, size: 22),
                    onPressed: () => Get.toNamed(Routes.FAVORITES),
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  if (count > 0)
                    Positioned(
                      top: -2,
                      right: 2,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade700,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                        child: Text(
                          '$count',
                          style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            }),
          ],
        ),
        actions: [
          // 3. زر عن المتجر
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: Colors.blueGrey,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: const Icon(Icons.storefront_outlined, color: Colors.blueGrey, size: 18),
            label: const Text(
              'عن المتجر',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.blueGrey),
            ),
            onPressed: () => Get.toNamed(Routes.ABOUT),
          ),
          // 4. زر الحساب
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              icon: const Icon(Icons.person, color: Colors.blue, size: 18),
              label: const Text(
                'الحساب',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.blue),
              ),
              onPressed: () => Get.toNamed(Routes.PROFILE),
            ),
          )
        ],
      ),
      body: Obx(() {
        if (controller.isLoadingCategories.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.categories.isEmpty) {
          return const Center(
            child: Text(
              "لا توجد فئات معروضة حالياً.",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          itemCount: controller.categories.length + 1, // 🚀 إضافة 1 لعرض العبارة الختامية
          itemBuilder: (context, categoryIndex) {
            // التحقق هل وصلنا لنهاية قائمة الفئات
            if (categoryIndex == controller.categories.length) {
              return _buildFooter(dashboardController, storeService);
            }

            final category = controller.categories[categoryIndex];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
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
                      ],
                    ),
                  ),
                ),

                // 🚀 تحسين: جعل كل قائمة منتجات تفاعلية بشكل مستقل
                Obx(() {
                  final categoryProducts = controller.categoryProductsMap[category.id] ?? [];
                  
                  return SizedBox(
                    height: 240,
                    child: categoryProducts.isEmpty 
                        ? (controller.categoryProductsMap.containsKey(category.id) 
                            ? const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text('لا توجد منتجات حالياً.', style: TextStyle(color: Colors.grey, fontSize: 13)),
                                ),
                              )
                            : const Center(child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator(strokeWidth: 2)))) // لودر صغير خاص بالفئة
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            itemCount: categoryProducts.length,
                            itemBuilder: (context, productIndex) {
                              final product = categoryProducts[productIndex];
                              return _buildProductCard(product, dashboardController);
                            },
                          ),
                  );
                }),
                const SizedBox(height: 12),
              ],
            );
          },
        );
      }),
    );
  }

  // 🚀 بناء العبارة الختامية وتفاصيل المتجر الاحترافية
  Widget _buildFooter(DashboardController dashboardController, StoreService storeService) {
    return Obx(() {
      final config = storeService.storeConfig.value;
      
      return Container(
        padding: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0, bottom: 120.0),
        color: Colors.white,
        child: Column(
          children: [

            // الانتقال للفئات
            GestureDetector(
              onTap: () => dashboardController.changePage(1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "انتقل إلى صفحة الفئات لرؤية جميع المنتجات",
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios, size: 14, color: Colors.blue.shade700),
                ],
              ),
            ),
            const SizedBox(height: 40),

            const Divider(color: Colors.grey, thickness: 0.2),

            const SizedBox(height: 20),
            
            // تفاصيل الحقوق والمتجر
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                "جميع الحقوق محفوظة لـ ${storeService.storeName.value} 2026 ©",
                style:  TextStyle(fontSize: 13, color: Colors.grey.shade500, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // أرقام التواصل والبريد
            if (config != null)
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                runSpacing: 10,
                children: [
                  // رقم الاتصال
                  _buildFooterContactItem(
                    icon: Icons.phone_android,
                    color: Colors.green,
                    text: config.callNumber,
                  ),
                  // واتساب
                  _buildFooterContactItem(
                    icon: Icons.chat,
                    color: Colors.teal,
                    text: config.whatsappNumber,
                  ),
                  // البريد الإلكتروني
                  _buildFooterContactItem(
                    icon: Icons.alternate_email,
                    color: Colors.orange,
                    text: config.email,
                  ),
                ],
              ),
            
            const SizedBox(height: 30),
            
            // المطور
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "تطوير وتصميم: خالد",
                style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFooterContactItem({required IconData icon, required Color color, required String text}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 12, color: Colors.blueGrey, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  // دالة مساعدة لبناء الكارت لتقليل حجم الكود داخل الـ build
  Widget _buildProductCard(dynamic product, dynamic dashboardController) {
    return GestureDetector(
      onTap: () {
        Get.find<ProductsController>().selectedProduct.value = product;
        dashboardController.isComingFromHome.value = true;
        // 🚀 تمرير Tag فريد للصفحة الرئيسية لتجنب التكرار في الذاكرة
        Get.toNamed(Routes.PRODUCT_INFO, arguments: 'home_${product.id}');
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
              child: Directionality(
                textDirection: TextDirection.rtl,
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
                        child: product.imageUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Hero(
                                  tag: 'home_${product.id}',
                                  child: Image.network(
                                    product.imageUrl,
                                    fit: BoxFit.cover,
                                    cacheWidth: 300,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)));
                                    },
                                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.shopping_bag_outlined, size: 44, color: Colors.blue),
                                  ),
                                ),
                              )
                            : const Icon(Icons.shopping_bag_outlined, size: 44, color: Colors.blue),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text("${product.sizeVolume > 0 ? product.sizeVolume : ''} ${product.unitType}", style: const TextStyle(color: Colors.grey, fontSize: 11)),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.local_shipping, size: 12, color: Colors.indigo),
                            SizedBox(width: 4),
                            Text(
                              "توصيل",
                              style: TextStyle(
                                color: Colors.indigo,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${product.currentPrice} ريال', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 13)),
                            if (product.hasDiscount)
                              Text(
                                '${product.originalPrice} ريال',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () async => await Get.find<CartController>().addProductToCart(product),
                          child: const Icon(Icons.add_circle, color: Colors.blue, size: 22),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (product.hasDiscount)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(8)),
                  child: const Text("خصم", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
