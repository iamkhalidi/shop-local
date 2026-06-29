// داخل ملف lib/features/orders/controller/orders_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../data/repositories/orders_repository.dart';
import '../../cart/controller/cart_controller.dart';
import '../../cart/widgets/clear_cart_dialog.dart'; // استيراد الـ الديالوج الخاص بك هنا
import '../model/order_model.dart';
import '../widgets/order_success_dialog.dart';

class OrdersController extends GetxController {
  final OrdersRepository _ordersRepository = OrdersRepository();
  final CartController _cartController = Get.find<CartController>();

  var orders = <OrderModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    // fetchOrders();
    // ربط القائمة بالـ Stream مباشرة للاستماع اللحظي
    bindOrdersStream();
    super.onInit();
  }

  // Future<void> fetchOrders() async {
  //   try {
  //     isLoading.value = true;
  //     final fetchedOrders = await _ordersRepository.getUserOrders();
  //     fetchedOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  //     orders.assignAll(fetchedOrders);
  //   } catch (e) {
  //     Get.snackbar("خطأ", "لم نتمكن من تحميل طلباتك السابقة.");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }


  void bindOrdersStream() {
    isLoading.value = true;

    // ربط دالة المستودع الحية بالقائمة الملاحظة (Reactive List)
    orders.bindStream(
        _ordersRepository.listenToUserOrders().map((fetchedOrders) {
          // ترتيب الطلبات من الأحدث للأقدم تلقائياً داخل الـ Stream
          fetchedOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return fetchedOrders;
        })
    );

    // نوقف مؤشر التحميل بمجرد بدء الاستماع أو وصول أول تدفق بيانات
    orders.listen((_) {
      if (isLoading.value) isLoading.value = false;
    });
  }




// دالة الشراء واعتماد الطلب (Checkout) بعد التعديل
  Future<void> placeOrder({double deliveryFee = 0.0}) async {
    if (_cartController.cartItems.isEmpty) {
      Get.snackbar("تنبيه", "سلتك فارغة حالياً! لا يمكن إتمام الطلب.");
      return;
    }

    try {
      isLoading.value = true;

      double itemsTotal = _cartController.totalPrice;
      double finalPrice = itemsTotal + deliveryFee;

      final newOrder = OrderModel(
        id: const Uuid().v4(),
        items: List.from(_cartController.cartItems),
        totalPrice: finalPrice,
        deliveryFee: deliveryFee,
        status: OrderStatus.pending, // ✅ التعديل هنا: مررنا الـ Enum الجديد بدلاً من النص
        createdAt: DateTime.now(),
      );

      // 1. حفظ الطلب في الفايرستور أولاً
      await _ordersRepository.saveOrderOnly(newOrder);

      // 2. تحديث قائمة الطلبات محلياً في التطبيق فوراً
      orders.insert(0, newOrder);

      isLoading.value = false; // نوقف مؤشر التحميل قبل إظهار الديالوج




      // // 3. إظهار الديالوج الجاهز الخاص بك لسؤال المستخدم عن تفريغ السلة
      // Get.dialog(
      //   ClearCartDialog(
      //     onConfirm: () async {
      //       await _executeCartClearing(); // استدعاء دالة المسح عند التأكيد
      //     },
      //   ),
      //   barrierDismissible: false,
      // );
      // 3. إظهار الديالوج الجديد باللهجة السعودية
      Get.dialog(
        OrderSuccessDialog(
          onConfirm: () async {
            // إذا اختار "فضّي السلة"
            await _executeCartClearing();
          },
          onCancel: () {
            // إذا اختار "خليها بالسلة" نكتفي برسالة سريعة بنجاح العملية فقط دون مسح الفايرستور
            Get.snackbar("نجاح العملية", "تم حفظ طلبك، تسوق ممتع!");
          },
        ),
        barrierDismissible: false,
      );




    } catch (e) {
      isLoading.value = false;
      Get.snackbar("فشل الطلب", "حدث خطأ أثناء اعتماد الطلب، يرجى المحاولة لاحقاً.");
    }
  }

  // دالة داخلية لتنفيذ مسح السلة سحابياً ومحلياً عند موافقة المستخدم
  Future<void> _executeCartClearing() async {
    try {
      isLoading.value = true;
      // تفريغ السلة من الفايرستور
      await _ordersRepository.clearFirestoreCart();
      // تفريغ السلة محلياً من الـ GetX State لتحديث شاشة السلة فوراً
      _cartController.cartItems.clear();

      Get.snackbar("نجاح", "تم اعتماد طلبك وتفريغ السلة بنجاح.");
    } catch (e) {
      Get.snackbar("تنبيه", "تم حفظ الطلب ولكن فشل تفريغ السلة سحابياً.");
    } finally {
      isLoading.value = false;
    }
  }
}