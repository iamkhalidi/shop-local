import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../dashboard/controller/dashboard_controller.dart';

class ProductsScreen extends GetView<DashboardController> {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.selectedCategoryName.value)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => controller.goBackInCategories(), // الرجوع لصفحة الفئات السابقة
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 90.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 0.75,
          ),
          itemCount: 6, // عدد منتجات تجريبي داخل الفئة المحددة
          itemBuilder: (context, index) {
            String productName = 'منتج ${controller.selectedCategoryName.value} ${index + 1}';
            String productPrice = '${(index + 1) * 75} ريال';

            return GestureDetector(
              onTap: () {
                // الانتقال لصفحة تفاصيل المنتج داخل الـ Bottom Nav Bar
                controller.goToProductInfo(productName, productPrice);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, spreadRadius: 2)],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_bag_outlined, size: 50, color: Colors.blue),
                    const SizedBox(height: 10),
                    Text(productName, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    const SizedBox(height: 5),
                    Text(productPrice, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}