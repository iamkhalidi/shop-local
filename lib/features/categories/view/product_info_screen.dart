import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../../favorites/widgets/favorite_button_widget.dart';
import '../controller/products_controller.dart'; // استيراد الكنترولر الجديد للمنتجات

class ProductInfoScreen extends GetView<DashboardController> {
  const ProductInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // العثور على نسخة الـ ProductsController المفتوحة مسبقاً لجلب تفاصيل المنتج المختار
    final ProductsController productsController = Get.find<ProductsController>();
    final product = productsController.selectedProduct.value;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('تفاصيل المنتج', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            // إغلاق شاشة التفاصيل الحالية والعودة للشاشة السابقة أياً كانت (هوم أو مفضلة)
            Get.back();
            // // إذا كان المؤشر الرئيسي للتبويب يقف على شاشة الرئيسية (0)، نعيده إلى الهوم مباشرة
            // if (controller.isComingFromHome.value) {
            //   controller.changePage(0); // العودة لتبويب الرئيسية
            // } else {
            //   controller.goBackInCategories(); // العودة الطبيعية لصفحة المنتجات داخل قسم الفئات
            // }
          },
        ),
      ),
      body: product == null
          ? const Center(child: Text("لم يتم العثور على بيانات المنتج!"))
          : Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 90.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // حاوية محاكاة لصورة المنتج
              Stack(
                children: [
                  // 🌟 عرض صورة المنتج الكبيرة الحقيقية بدل أيقونة الـ Photo المؤقتة 🌟
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: product.imageUrl.isNotEmpty
                          ? Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.insert_photo_outlined, size: 100, color: Colors.grey);
                        },
                      )
                          : const Icon(Icons.insert_photo_outlined, size: 100, color: Colors.grey),
                    ),
                  ),
                  // زر المفضلة في زاوية الصورة
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(4),
                      child: FavoriteButton(product: product, size: 28), // حجم أكبر يتناسب مع شاشة التفاصيل
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // اسم المنتج الحقيقي مستدعى برمجياً
              Text(
                product.name,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),

              // الحجم والوزن الخاص بالمنتج
              Text(
                "الحجم / الوزن: ${product.sizeVolume > 0 ? product.sizeVolume : ''} ${product.unitType}",
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 10),

              // السعر الحقيقي والقديم في حال وجود خصم
              Row(
                children: [
                  Text(
                    "${product.currentPrice} ريال",
                    style: const TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  if (product.hasDiscount) ...[
                    const SizedBox(width: 15),
                    Text(
                      "${product.originalPrice} ريال",
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough
                      ),
                    ),
                  ]
                ],
              ),
              const Divider(height: 30, thickness: 1),

              const Text(
                'وصف المنتج:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // الوصف الحقيقي المجلوب من الفايربيس لكل صنف
              Text(
                product.description,
                style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
              ),
              const SizedBox(height: 20),

              // عرض كمية المخزون المتبقية لتعطي موثوقية للتطبيق
              Row(
                children: [
                  const Icon(Icons.storefront, size: 18, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    "الالكمية المتاحة في المخزن: ${product.stockQuantity}",
                    style: const TextStyle(fontSize: 13, color: Colors.blueGrey),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // زر إضافة إلى السلة الديناميكي بحسب المخزن
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: product.stockQuantity <= 0 ? Colors.grey : Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
                label: Text(
                  product.stockQuantity <= 0 ? 'نفدت الكمية' : 'إضافة إلى السلة',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: product.stockQuantity <= 0
                    ? null // تعطيل الزر تماماً إذا كان المخزون 0
                    : () {
                  Get.snackbar(
                    'نجاح',
                    'تمت إضافة (${product.name}) إلى السلة بنجاح',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.TOP,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

