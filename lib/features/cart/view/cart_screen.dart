import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/cart_controller.dart';
import '../model/cart_item_model.dart';
import '../widgets/clear_cart_dialog.dart';


class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // // جلب نسخة الكنترولر المحقونة
    // final controller = Get.find(CartController());
    // 🚀 جلب النسخة المجهزة مسبقاً بدلاً من إعادة إنشائها
    final controller = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('سلة التسوق'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false, // يمنع إغلاق الديالوج عند الضغط خارجه
                builder: (BuildContext context) {
                  return ClearCartDialog(
                    onConfirm: () {
                      controller.clearAll(); // استدعاء دالة المسح من الكنترولر عند التأكيد
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return const Center(
            child: Text('السلة فارغة حالياً، ابدأ بالتسوق!'),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: controller.cartItems.length,
                itemBuilder: (context, index) {
                  final CartItemModel item = controller.cartItems[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      leading: Image.network(
                        item.image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.image),
                      ),
                      title: Text(item.productName),
                      subtitle: Text('\$${item.price.toStringAsFixed(2)} × ${item.quantity} = \$${(item.price * item.quantity).toStringAsFixed(2)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () => controller.decreaseQuantity(item),
                          ),
                          Text('${item.quantity}', style: const TextStyle(fontSize: 16)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => controller.increaseQuantity(item),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => controller.removeItem(item.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // لوحة عرض الإجمالي وإتمام الطلب
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('إجمالي المنتجات:', style: TextStyle(fontSize: 16)),
                        Text('${controller.totalItemsCount}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('المبلغ الإجمالي:', style: TextStyle(fontSize: 18)),
                        Text('\$${controller.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // كود إتمام الطلب الشراء
                        },
                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                        child: const Text('إتمام عملية الشراء', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
