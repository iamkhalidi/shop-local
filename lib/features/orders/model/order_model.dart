import 'package:cloud_firestore/cloud_firestore.dart';
import '../../cart/model/cart_item_model.dart'; // تأكد من مسار مودل السلة لديك

// 1️⃣ تعريف حالات الطلب كـ Enum لضمان حماية البيانات وسهولة إدارتها للـ Admin
enum OrderStatus {
  pending,      // معلق "بانتظار التأكيد"
  processing,   // قيد التجهيز
  delivering,   // قيد التوصيل
  delivered,    // تم التسليم
  canceled      // ملغي
}

// إضافة ملحق (Extension) للـ Enum للحصول على النص العربي بسهولة عند العرض في الـ UI
extension OrderStatusExtension on OrderStatus {
  String get arabicName {
    switch (this) {
      case OrderStatus.pending:
        return 'معلق "بانتظار التأكيد"';
      case OrderStatus.processing:
        return 'قيد التجهيز';
      case OrderStatus.delivering:
        return 'قيد التوصيل';
      case OrderStatus.delivered:
        return 'تم التسليم';
      case OrderStatus.canceled:
        return 'ملغي';
    }
  }
}

class OrderModel {
  final String id;
  final List<CartItemModel> items;
  final double totalPrice;
  final double deliveryFee;
  final OrderStatus status; // تعديل النوع هنا ليكون من نوع الـ Enum الجديد
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.items,
    required this.totalPrice,
    required this.deliveryFee,
    required this.status,
    required this.createdAt,
  });

  // 2️⃣ قائمة ثابتة (Static List) تحتوي على جميع الحالات باللغة العربية
  // يمكنك استدعاؤها في أي مكان عبر: OrderModel.allStatuses
  static const List<String> allStatuses = [
    'معلق "بانتظار التأكيد"',
    'قيد التجهيز',
    'قيد التوصيل',
    'تم التسليم',
    'ملغي'
  ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'totalPrice': totalPrice,
      'deliveryFee': deliveryFee,
      'status': status.name, // يتم تخزينها في الفايرستور كنص إنجليزي فريد وثابت (مثلاً: "pending")
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // جلب النص من الفايرستور وتحويله إلى قيمة الـ Enum المقابلة، وإذا لم يجد شيئاً يضعها pending كحالة افتراضية
    final statusName = json['status'] ?? '';
    final orderStatus = OrderStatus.values.firstWhere(
          (e) => e.name == statusName,
      orElse: () => OrderStatus.pending,
    );

    return OrderModel(
      id: json['id'] ?? '',
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      status: orderStatus, // إسناد حالة الـ Enum المستخلصة
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}