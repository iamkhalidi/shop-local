import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../cart/controller/cart_controller.dart';
import '../../cart/model/cart_item_model.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../../favorites/widgets/favorite_button_widget.dart';
import '../controller/products_controller.dart';

class ProductsScreen extends GetView<DashboardController> {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductsController productsController = Get.find<ProductsController>();


    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Obx(() => Text(
          controller.selectedCategoryDisplay.value, // 🌟 استخدام اسم الفئة العربي الجديد
          style: const TextStyle(fontWeight: FontWeight.bold),
        )),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            // // الرجوع لصفحة الفئات السابقة عبر الكنترولر الخاص بك
            // controller.goBackInCategories();

            if (controller.isComingFromHome.value) {
              // إذا كان قادماً من الهوم، يرجعه لتبويب الرئيسية ويصفر الشارة
              controller.isComingFromHome.value = false;
              controller.changePage(0);
            } else {
              // إذا كان يتصفح بشكل طبيعي من داخل تبويب الفئات، يرجعه لقائمة الفئات العامة
              controller.goBackInCategories();
            }


            },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 90.0),
        child: Obx(() {
          // 1. حالة التحميل والانتظار
          if (productsController.isLoadingProducts.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. حالة عدم وجود منتجات في الفئة
          if (productsController.productsList.isEmpty) {
            return const Center(
              child: Text(
                "لا توجد منتجات متوفرة في هذه الفئة حالياً.",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          // 3. عرض المنتجات الحقيقية مع دعم التمرير اللانهائي
          return CustomScrollView(
            controller: productsController.scrollController,
            slivers: [
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.72,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = productsController.productsList[index];
                    return _buildProductCard(context, product, productsController);
                  },
                  childCount: productsController.productsList.length,
                ),
              ),
              // 🚀 عرض مؤشر تحميل عند جلب المزيد من المنتجات في الأسفل
              if (productsController.isFetchingMore.value)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  // دالة مساعدة لبناء كارت المنتج للحفاظ على نظافة الكود
  Widget _buildProductCard(BuildContext context, dynamic product, dynamic productsController) {
    return GestureDetector(
      onTap: () {
        productsController.selectedProduct.value = product;
        controller.goToProductInfo(product.name, "${product.currentPrice} ريال");
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
                spreadRadius: 2
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
                          cacheWidth: 400,
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
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${product.sizeVolume > 0 ? product.sizeVolume : ''} ${product.unitType}",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          '${product.currentPrice} ريال',
                          style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14)
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.find<CartController>().addProductToCart(product);
                        },
                        child: Icon(Icons.add_circle, color: Colors.blue.withOpacity(0.8), size: 24),
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
            Positioned(
              top: 8,
              right: 8,
              child: FavoriteButton(product: product, size: 22),
            ),
          ],
        ),
      ),
    );
  }
}
