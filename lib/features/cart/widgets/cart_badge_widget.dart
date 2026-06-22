import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/cart_controller.dart';

class CartBadgeWidget extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final double iconSize;

  const CartBadgeWidget({
    Key? key,
    required this.icon,
    required this.iconColor,
    this.iconSize = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // جلب نسخة الكنترولر للتفاعل مع مصفوفة السلة
    final cartController = Get.find<CartController>();

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none, // للسماح للدائرة بالخروج قليلاً خارج حدود الأيقونة
      children: [
        // الأيقونة الأساسية لزر السلة
        Icon(
          icon,
          color: iconColor,
          size: iconSize,
        ),

        // مراقبة عدد العناصر وبناء الدائرة تلقائياً عند وجود منتجات
        Obx(() {
          final int count = cartController.totalItemsCount;

          // إذا كانت السلة فارغة تماماً، لا تعرض الدائرة الحمراء
          if (count == 0) {
            return const SizedBox.shrink();
          }

          return Positioned(
            top: -4,  // رفع الدائرة قليلاً لأعلى الأيقونة
            right: -6, // إزاحة الدائرة قليلاً لليمين
            child: AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: count > 0 ? 1.0 : 0.0,
              child: Container(
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5), // إطار أبيض أنيق يعزل الدائرة عن الخلفية
                ),
                child: Center(
                  child: Text(
                    // إذا زاد العدد عن 99 يفضل كتابة +99 كحركة احترافية
                    count > 99 ? '+99' : '$count',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      height: 1.0, // لتوسيط النص تماماً عمودياً
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}