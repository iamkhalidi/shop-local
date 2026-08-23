import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
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
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Obx(() {
          if (productsController.isSearchMode.value) {
            return Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                autofocus: true,
                onChanged: (val) => productsController.searchQuery.value = val,
                decoration: const InputDecoration(
                  hintText: 'ابحث عن اسم المنتج، الوصف...',
                  hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                  prefixIcon: Icon(Icons.search, size: 20, color: Colors.blue),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            );
          }
          return Text(
            controller.selectedCategoryDisplay.value,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis, // حماية من الأسماء الطويلة
          );
        }),
        leading: Obx(() => IconButton(
          icon: Icon(productsController.isSearchMode.value ? Icons.close : Icons.arrow_back_ios_new),
          onPressed: () {
            if (productsController.isSearchMode.value) {
              productsController.toggleSearchMode();
            } else {
              if (controller.isComingFromHome.value) {
                controller.isComingFromHome.value = false;
                controller.changePage(0);
              } else {
                controller.goBackInCategories();
              }
            }
          },
        )),
        actions: [
          Obx(() => !productsController.isSearchMode.value 
            ? IconButton(
                icon: const Icon(Icons.search, color: Colors.blue),
                onPressed: () => productsController.toggleSearchMode(),
              )
            : const SizedBox.shrink()
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 90.0),
        child: Obx(() {
          // 1. حالة التحميل والانتظار
          if (productsController.isLoadingProducts.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = productsController.displayedProducts;

          // 2. حالة عدم وجود منتجات في الفئة
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    productsController.searchQuery.isEmpty
                        ? "لا توجد منتجات متوفرة في هذه الفئة حالياً."
                        : "لم يتم العثور على نتائج للبحث عن '${productsController.searchQuery.value}'",
                    style: const TextStyle(color: Colors.grey, fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // 3. عرض المنتجات الحقيقية مع دعم التمرير اللانهائي والبحث
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
                    final product = items[index];
                    return Directionality(
                      textDirection: TextDirection.rtl,
                      child: _buildProductCard(context, product, productsController),
                    );
                  },
                  childCount: items.length,
                ),
              ),
              // 🚀 عرض مؤشر تحميل عند جلب المزيد (يختفي في وضع البحث لضمان الدقة)
              if (productsController.isFetchingMore.value && !productsController.isSearchMode.value)
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
        // 🚀 تغيير: الانتقال عبر نظام المسارات (Routes) لتفعيل الـ Hero Animation
        controller.isComingFromHome.value = true; // نعتبرها قادمة من مسار مستقل
        // 🚀 تمرير Tag فريد لصفحة المنتجات لتجنب تكرار الـ Hero Tag في الذاكرة
        Get.toNamed(Routes.PRODUCT_INFO, arguments: 'products_${product.id}');
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
                            ? Hero(
                                tag: 'products_${product.id}',
                                child: Image.network(
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
                                ),
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
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              '${product.currentPrice} ريال',
                              style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14)
                          ),
                          if (product.hasDiscount)
                            Text(
                              '${product.originalPrice} ريال',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
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
