import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../core/utils/notification_helper.dart';
import '../../../data/repositories/orders_repository.dart';
import '../../cart/controller/cart_controller.dart';
import '../model/order_model.dart';
import '../widgets/order_success_dialog.dart';
import '../../../core/utils/app_snack.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../core/utils/notification_helper.dart';
import '../../../data/repositories/orders_repository.dart';
import '../../cart/controller/cart_controller.dart';
import '../model/order_model.dart';
import '../widgets/order_success_dialog.dart';
import '../../../core/utils/app_snack.dart';

class OrdersController extends GetxController {
  final OrdersRepository _ordersRepository = OrdersRepository();
  final CartController _cartController = Get.find<CartController>();
  final ScrollController scrollController = ScrollController();

  var orders = <OrderModel>[].obs;
  var isLoading = false.obs;

  // 🌟 متغيرات التجزئة (Pagination)
  DocumentSnapshot? _lastDocument;
  var isFetchingMore = false.obs;
  var hasNextPage = true.obs;
  final int _limit = 7;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();

    // إعداد مستمع التمرير
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100) {
        fetchMoreOrders();
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  // جلب الطلبات (التحميل الأول)
  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      _lastDocument = null;
      hasNextPage.value = true;

      var result = await _ordersRepository.getOrdersPaginated(limit: _limit);

      orders.assignAll(result.orders);
      _lastDocument = result.lastDoc;

      if (result.orders.length < _limit) {
        hasNextPage.value = false;
      }
    } catch (e) {
      print("Error fetching orders: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // جلب المزيد من الطلبات عند السكرول
  Future<void> fetchMoreOrders() async {
    if (isFetchingMore.value || !hasNextPage.value || isLoading.value) return;

    try {
      isFetchingMore.value = true;

      var result = await _ordersRepository.getOrdersPaginated(
        limit: _limit,
        lastDocument: _lastDocument,
      );

      if (result.orders.isNotEmpty) {
        orders.addAll(result.orders);
        _lastDocument = result.lastDoc;
      }

      if (result.orders.length < _limit) {
        hasNextPage.value = false;
      }
    } catch (e) {
      print("Error fetching more orders: $e");
    } finally {
      isFetchingMore.value = false;
    }
  }

  // 🚀 دالة الشراء المحسنة: تفتح السؤال أولاً قبل أي عملية حفظ
  Future<void> placeOrder({double deliveryFee = 0.0}) async {
    if (_cartController.cartItems.isEmpty) {
      AppSnack.warning("سلتك فارغة حالياً! لا يمكن إتمام الطلب.");
      return;
    }

    // إظهار ديالوج التأكيد أولاً مباشرة
    Get.dialog(
      OrderSuccessDialog(
        onOrderConfirmed: () async {
          // هذه الدالة ستنفذ داخل الديالوج فقط إذا ضغط "نعم، متأكد"
          bool success = await _executeOrderSaving(deliveryFee);
          if (success) {
            fetchOrders(); // تحديث القائمة بعد نجاح الطلب
          }
          return success;
        },
        onConfirm: () async {
          await _executeCartClearing();
        },
        onCancel: () {
          AppSnack.success("تم حفظ طلبك، تسوق ممتع!", title: "نجاح العملية");
        },
      ),
      barrierDismissible: false,
    );
  }

  // 🚀 دالة داخلية جديدة لمعالجة التحميل وحفظ الطلب في الفايرستور
  Future<bool> _executeOrderSaving(double deliveryFee) async {
    try {
      isLoading.value = true;


      // 🚀 استدعاء الإشعار الصوتي والسناك بار السعودي هنا مباشرة بعد تفريغ السلة بنجاح
      await NotificationHelper.triggerOrderSuccessNotification();

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
      AppSnack.error("حدث خطأ أثناء اعتماد الطلب، يرجى المحاولة لاحقاً.", title: "فشل الطلب");
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

      // // 🚀 استدعاء الإشعار الصوتي والسناك بار السعودي هنا مباشرة بعد تفريغ السلة بنجاح
      // await NotificationHelper.triggerOrderSuccessNotification();
      // Get.snackbar("نجاح", "تم اعتماد طلبك وتفريغ السلة بنجاح.");
    } catch (e) {
      AppSnack.warning("تم حفظ الطلب ولكن فشل تفريغ السلة سحابياً.");
    } finally {
      isLoading.value = false;
    }
  }


  // 🚀 دالة معالجة حذف الطلب سحابياً
  Future<bool> deleteOrderById(String orderId) async {
    try {
      isLoading.value = true;
      await _ordersRepository.deleteOrder(orderId);
      // Get.snackbar("نجاح", "تم حذف الطلب بنجاح.",);
      // 🚀 سناك بار أنيق وصغير مخصص لنجاح حذف الطلب

// 🎵 🚀 استدعاء صوت الحذف والسناك بار المخصص مباشرة هنا
      await NotificationHelper.triggerOrderDeleteNotification();


      return true;
    } catch (e) {
      AppSnack.error("فشل في حذف الطلب، يرجى المحاولة لاحقاً.");
      return false;
    } finally {
      isLoading.value = false;
    }
  }



}