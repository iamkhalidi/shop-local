import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/order_model.dart';

class OrderInfoScreen extends StatelessWidget {
  const OrderInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // استقبال بيانات الطلب الممررة عبر الـ arguments
    final OrderModel order = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل طلب #${order.id.substring(0, 8).toUpperCase()}'),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl, // تنسيق المحتوى بالكامل للغة العربية
        child: Column(
          children: [
            // ملخص حالة الطلب في الأعلى
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.grey[100],
              child: Column(
                children: [
                  Text(
                    'الحالة الحالية: ${order.status.arabicName}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'إجمالي الفاتورة: \$${order.totalPrice.toStringAsFixed(2)} (شاملة رسوم التوصيل: \$${order.deliveryFee.toStringAsFixed(2)})',
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            // قائمة الأصناف المكونة للطلب
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: order.items.length,
                itemBuilder: (context, index) {
                  final item = order.items[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.image,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 40),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.productName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'السعر: \$${item.price.toStringAsFixed(2)} × ${item.quantity}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}