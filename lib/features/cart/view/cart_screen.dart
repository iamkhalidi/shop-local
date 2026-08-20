import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../orders/controller/orders_controller.dart';
import '../controller/cart_controller.dart';
import '../model/cart_item_model.dart';
import '../widgets/clear_cart_dialog.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();
    final ordersController = Get.find<OrdersController>();

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
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return ClearCartDialog(
                    onConfirm: () {
                      controller.clearAll();
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.displayedItems.isEmpty) {
          return const Center(
            child: Text('السلة فارغة حالياً، ابدأ بالتسوق!'),
          );
        }

        return Column(
          children: [
            Expanded(
              child: CustomScrollView(
                controller: controller.scrollController,
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 0.65,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final CartItemModel item = controller.displayedItems[index];
                          return _buildCartGridItem(context, item, controller);
                        },
                        childCount: controller.displayedItems.length,
                      ),
                    ),
                  ),
                  // 🚀 مؤشر تحميل عند جلب المزيد من السلة
                  if (controller.isFetchingMore.value)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                ],
              ),
            ),

            // لوحة عرض الإجمالي وإتمام الطلب
            Container(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -10),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('إجمالي المنتجات:', style: TextStyle(fontSize: 15, color: Colors.grey)),
                      Text('${controller.totalItemsCount}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('المبلغ الإجمالي:', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                      Text('${controller.totalPrice.toStringAsFixed(2)} ريال', style: const TextStyle(fontSize: 19, color: Colors.blue, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: Obx(() {
                      return ordersController.isLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 0,
                        ),
                        onPressed: () {
                          ordersController.placeOrder(deliveryFee: 0.0);
                        },
                        child: const Text('تأكيد الطلب الآن', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      );
                    }),
                  ),
                  const SizedBox(height: 75),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  // 🚀 بناء كارت المنتج في السلة بنظام الشبكة (Grid) متناسق مع صفحة المنتجات
  Widget _buildCartGridItem(BuildContext context, CartItemModel item, CartController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // صورة المنتج
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        item.image,
                        fit: BoxFit.cover,
                        cacheWidth: 300,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.shopping_bag_outlined, color: Colors.blue),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // اسم المنتج
                Text(
                  item.productName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                
                // السعر الإجمالي للمنتج بناءً على الكمية
                Text(
                  '${(item.price * item.quantity).toStringAsFixed(2)} ريال',
                  style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // أزرار التحكم بالكمية في الأسفل
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildQtyBtn(Icons.remove, () => controller.decreaseQuantity(item)),
                      Text(
                        '${item.quantity}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      _buildQtyBtn(Icons.add, () => controller.increaseQuantity(item)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 🗑️ زر حذف المنتج (أصبح الآن سلة مهملات حمراء واضحة في الزاوية)
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                Get.defaultDialog(
                  title: 'تأكيد الحذف',
                  titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  middleText: 'هل تريد إزالة هذا المنتج من السلة؟',
                  textConfirm: 'نعم، حذف',
                  textCancel: 'تراجع',
                  confirmTextColor: Colors.white,
                  buttonColor: Colors.redAccent,
                  cancelTextColor: Colors.black54,
                  onConfirm: () {
                    controller.removeItem(item.id);
                    Get.back();
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: const Icon(Icons.delete_forever, color: Colors.redAccent, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // زر تحكم بالكمية دائري صغير
  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Icon(icon, size: 16, color: Colors.black87),
      ),
    );
  }
}
