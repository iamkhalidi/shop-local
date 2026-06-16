import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../dashboard/controller/dashboard_controller.dart';

class ProductInfoScreen extends GetView<DashboardController> {
  const ProductInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل المنتج'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => controller.goBackInCategories(), // الرجوع لصفحة المنتجات السابقة
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 90.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // حاوية محاكاة لصورة المنتج
              Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.insert_photo_outlined, size: 100, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // اسم المنتج وسعره مستدعى برمجياً
              Obx(() => Text(
                controller.selectedProductName.value,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              )),
              const SizedBox(height: 10),
              Obx(() => Text(
                controller.selectedProductPrice.value,
                style: const TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold),
              )),

              const SizedBox(height: 20),
              const Text(
                'وصف المنتج:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'هذا النص هو مثال لوصف المنتج المستهدف. المنتج يتميز بجودة عالية وصناعة محلية ممتازة تناسب تطلعاتك وضمان الشراء الآمن.',
                style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
              ),
              const SizedBox(height: 30),

              // زر إضافة إلى السلة
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('إضافة إلى السلة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                onPressed: () {
                  Get.snackbar(
                    'نجاح',
                    'تمت إضافة المنتج إلى السلة بنجاح',
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