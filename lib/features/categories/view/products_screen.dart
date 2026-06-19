import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../controller/products_controller.dart';

class ProductsScreen extends GetView<DashboardController> {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // حقن الـ ProductsController الجديد هنا ليعمل في هذه الشاشة
    // final ProductsController productsController = Get.put(ProductsController());

    //  هذا السطر :
    final ProductsController productsController = Get.find<ProductsController>();

    // استدعاء دالة جلب المنتجات فوراً بناءً على اسم الفئة المختارة من الـ DashboardController
    // نستخدم الـ ID الفعلي للفئة هنا ليتم الجلب بشكل سليم
    productsController.fetchProducts(controller.selectedCategoryName.value);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Obx(() => Text(
          controller.selectedCategoryName.value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        )),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => controller.goBackInCategories(), // الرجوع لصفحة الفئات السابقة عبر الكنترولر الخاص بك
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

          // 3. عرض المنتجات الحقيقية
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.72, // ضبط النسبة لتناسب التصميم الحقيقي مع الحقول الجديدة
            ),
            itemCount: productsController.productsList.length,
            itemBuilder: (context, index) {
              final product = productsController.productsList[index];

              return GestureDetector(
                onTap: () {
                  // حفظ المنتج الذي تم الضغط عليه داخل الـ ProductsController
                  productsController.selectedProduct.value = product;

                  // الانتقال لصفحة تفاصيل المنتج باستخدام دالتك الأصلية في الـ Dashboard
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
                            // أيقونة تمثل صورة المنتج مؤقتاً لحين ربط الروابط
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

                            // اسم المنتج الحقيقي القادم من الفايربيس
                            Text(
                              product.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),

                            // حجم أو وزن المنتج (مثال: 1.4 liter)
                            Text(
                              "${product.sizeVolume > 0 ? product.sizeVolume : ''} ${product.unitType}",
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5),

                            // السعر الحالي بعد الخصم
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    '${product.currentPrice} ريال',
                                    style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 14)
                                ),
                                // أيقونة إضافة سريعة بشكل جمالي منسق
                                Icon(Icons.add_circle, color: Colors.blue.withOpacity(0.8), size: 24),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // شارة "خصم" تظهر فقط إذا كان المنتج يملك خصماً فعلياً في قاعدة البيانات
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
    );
  }
}

