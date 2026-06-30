import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/orders_controller.dart';
import '../model/order_model.dart';
import '../widgets/delete_order_dialog.dart';

class OrderInfoScreen extends StatelessWidget {
  const OrderInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderModel order = Get.arguments;
    final OrdersController ordersController = Get.find<OrdersController>();

    return Scaffold(
      backgroundColor: Colors.grey[50], // خلفية ناعمة مريحة للعين
      appBar: AppBar(
        title: Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'تفاصيل ',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              TextSpan(
                text: '#${order.id.substring(0, 8).toUpperCase()}',
                style: const TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
          textDirection: TextDirection.rtl,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            // ✨ ملخص حالة الطلب والفاتورة بتصميم كارت حديث وعائم
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withOpacity(0.12)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.orange, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'حالة الطلب الحالي:',
                            style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          order.status.arabicName,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.orange),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1, thickness: 0.8),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'إجمالي الفاتورة',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      Text(
                        '${order.totalPrice.toStringAsFixed(2)} ريال',
                        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'شاملة رسوم التوصيل: ${order.deliveryFee.toStringAsFixed(2)} ريال',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),

            // عنوان قائمة الأصناف
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'الأصناف المطلوبة',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ),
            ),

            // 📦 قائمة الأصناف المكونة للطلب محسنة وعصرية
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: order.items.length,
                itemBuilder: (context, index) {
                  final item = order.items[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.withOpacity(0.1)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              item.image,
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 64,
                                height: 64,
                                color: Colors.grey[100],
                                child: const Icon(Icons.shopping_bag_outlined, size: 30, color: Colors.blue),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.productName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${item.price.toStringAsFixed(2)} ريال × ${item.quantity}',
                                  style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${(item.price * item.quantity).toStringAsFixed(2)} ريال',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // 🚀 زر حذف الطلب المثبت في أسفل الصفحة بشكل منسق وجذاب
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red[50],
                    foregroundColor: Colors.red[700],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.delete_sweep_outlined, size: 22),
                  label: const Text(
                    'إلغاء وحذف هذا الطلب',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Get.dialog(
                      DeleteOrderDialog(
                        onDeleteConfirmed: () async {
                          return await ordersController.deleteOrderById(order.id);
                        },
                      ),
                      barrierDismissible: false,

                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}













// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controller/orders_controller.dart'; // تأكد من صحة مسار الكنترولر عندك
// import '../model/order_model.dart';
// import '../widgets/delete_order_dialog.dart';
//
// class OrderInfoScreen extends StatelessWidget {
//   const OrderInfoScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final OrderModel order = Get.arguments;
//     // استدعاء الكنترولر لإطلاق دالة الحذف
//     final OrdersController ordersController = Get.find<OrdersController>();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('تفاصيل طلب #${order.id.substring(0, 8).toUpperCase()}'),
//         centerTitle: true,
//       ),
//       body: Directionality(
//         textDirection: TextDirection.rtl,
//         child: Column(
//           children: [
//             // ملخص حالة الطلب في الأعلى
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(16),
//               color: Colors.grey[100],
//               child: Column(
//                 children: [
//                   Text(
//                     'الحالة الحالية: ${order.status.arabicName}',
//                     style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 5),
//                   Text(
//                     'إجمالي الفاتورة: \$${order.totalPrice.toStringAsFixed(2)} (شاملة رسوم التوصيل: \$${order.deliveryFee.toStringAsFixed(2)})',
//                     style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
//                   ),
//                 ],
//               ),
//             ),
//
//             // قائمة الأصناف المكونة للطلب
//             Expanded(
//               child: ListView.builder(
//                 padding: const EdgeInsets.all(12),
//                 itemCount: order.items.length,
//                 itemBuilder: (context, index) {
//                   final item = order.items[index];
//                   return Card(
//                     margin: const EdgeInsets.only(bottom: 8),
//                     child: Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Row(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: Image.network(
//                               item.image,
//                               width: 60,
//                               height: 60,
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 40),
//                             ),
//                           ),
//                           const SizedBox(width: 15),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start, // تم الإصلاح هنا 🚀
//                               children: [
//                                 Text(
//                                   item.productName,
//                                   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//                                 ),
//                                 const SizedBox(height: 5),
//                                 Text(
//                                   'السعر: \$${item.price.toStringAsFixed(2)} × ${item.quantity}',
//                                   style: const TextStyle(color: Colors.grey),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Text(
//                             '\$${(item.price * item.quantity).toStringAsFixed(2)}',
//                             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//
//             // 🚀 زر حذف الطلب المثبت في أسفل الصفحة
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton.icon(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                   ),
//                   icon: const Icon(Icons.delete_outline),
//                   label: const Text(
//                     'حذف هذا الطلب',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   onPressed: () {
//                     // إظهار ديالوج تأكيد الحذف
//                     Get.dialog(
//                       DeleteOrderDialog(
//                         onDeleteConfirmed: () async {
//                           // استدعاء دالة الحذف وتمرير الـ ID الخاص بالطلب الحالي
//                           return await ordersController.deleteOrderById(order.id);
//                         },
//                       ),
//                       barrierDismissible: false,
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
