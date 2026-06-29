import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../data/repositories/orders_repository.dart';
import '../../cart/controller/cart_controller.dart';
import '../model/order_model.dart';
import '../widgets/order_success_dialog.dart';

class OrdersController extends GetxController {
  final OrdersRepository _ordersRepository = OrdersRepository();
  final CartController _cartController = Get.find<CartController>();

  var orders = <OrderModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    bindOrdersStream();
    super.onInit();
  }

  void bindOrdersStream() {
    isLoading.value = true;
    orders.bindStream(
        _ordersRepository.listenToUserOrders().map((fetchedOrders) {
          fetchedOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return fetchedOrders;
        })
    );
    orders.listen((_) {
      if (isLoading.value) isLoading.value = false;
    });
  }

  // 🚀 دالة الشراء المحسنة: تفتح السؤال أولاً قبل أي عملية حفظ
  Future<void> placeOrder({double deliveryFee = 0.0}) async {
    if (_cartController.cartItems.isEmpty) {
      Get.snackbar("تنبيه", "سلتك فارغة حالياً! لا يمكن إتمام الطلب.");
      return;
    }

    // إظهار ديالوج التأكيد أولاً مباشرة
    Get.dialog(
      OrderSuccessDialog(
        onOrderConfirmed: () async {
          // هذه الدالة ستنفذ داخل الديالوج فقط إذا ضغط "نعم، متأكد"
          return await _executeOrderSaving(deliveryFee);
        },
        onConfirm: () async {
          await _executeCartClearing();
        },
        onCancel: () {
          Get.snackbar("نجاح العملية", "تم حفظ طلبك، تسوق ممتع!");
        },
      ),
      barrierDismissible: false,
    );
  }

  // 🚀 دالة داخلية جديدة لمعالجة التحميل وحفظ الطلب في الفايرستور
  Future<bool> _executeOrderSaving(double deliveryFee) async {
    try {
      isLoading.value = true;

      double itemsTotal = _cartController.totalPrice;
      double finalPrice = itemsTotal + deliveryFee;

      final String rawUuid = const Uuid().v4();
      final String uniqueOrderId = '${rawUuid.substring(0, 8).toUpperCase()}_$rawUuid';

      final newOrder = OrderModel(
        id: uniqueOrderId,
        items: List.from(_cartController.cartItems),
        totalPrice: finalPrice,
        deliveryFee: deliveryFee,
        status: OrderStatus.pending,
        createdAt: DateTime.now(),
      );

      // حفظ الطلب الفعلي في الفايرستور هنا
      await _ordersRepository.saveOrderOnly(newOrder);

      return true; // نجحت العملية
    } catch (e) {
      Get.snackbar("فشل الطلب", "حدث خطأ أثناء اعتماد الطلب، يرجى المحاولة لاحقاً.");
      return false; // فشلت العملية
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _executeCartClearing() async {
    try {
      isLoading.value = true;
      await _ordersRepository.clearFirestoreCart();
      _cartController.cartItems.clear();
      Get.snackbar("نجاح", "تم اعتماد طلبك وتفريغ السلة بنجاح.");
    } catch (e) {
      Get.snackbar("تنبيه", "تم حفظ الطلب ولكن فشل تفريغ السلة سحابياً.");
    } finally {
      isLoading.value = false;
    }
  }


  // 🚀 دالة معالجة حذف الطلب سحابياً
  Future<bool> deleteOrderById(String orderId) async {
    try {
      isLoading.value = true;
      await _ordersRepository.deleteOrder(orderId);
      Get.snackbar("نجاح", "تم حذف الطلب بنجاح.");
      return true;
    } catch (e) {
      Get.snackbar("خطأ", "فشل في حذف الطلب، يرجى المحاولة لاحقاً.");
      return false;
    } finally {
      isLoading.value = false;
    }
  }


}