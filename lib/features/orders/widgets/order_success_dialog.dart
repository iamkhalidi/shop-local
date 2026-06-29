import 'package:flutter/material.dart';

class OrderSuccessDialog extends StatefulWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const OrderSuccessDialog({
    Key? key,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<OrderSuccessDialog> createState() => _OrderSuccessDialogState();
}

class _OrderSuccessDialogState extends State<OrderSuccessDialog> {
  // متغير للتحكم في المرحلة الحالية للديالوج
  bool _isOrderConfirmed = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // لضمان التنسيق العربي الكامل من اليمين لليسار
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300), // أنيميشن ناعم أثناء الانتقال بين السؤالين
        child: !_isOrderConfirmed
            ? _buildConfirmationStage(context)
            : _buildSuccessStage(context),
      ),
    );
  }

  // 1️⃣ المرحلة الأولى: سؤال التأكيد قبل إرسال الطلب
  Widget _buildConfirmationStage(BuildContext context) {
    return AlertDialog(
      key: const ValueKey('confirm_stage'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Row(
        children: [
          Icon(Icons.shopping_bag_outlined, color: Colors.blue, size: 28),
          SizedBox(width: 10),
          Text(
            'تأكيد الطلب 🧾',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: const Text(
        'هل أنت متأكد من رغبتك في تأكيد وإرسال هذا الطلب؟',
        style: TextStyle(fontSize: 16, height: 1.4),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        // زر التراجع والإلغاء
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // إغلاق الديالوج مباشرة دون فعل شيء
          },
          child: const Text(
            'تراجع',
            style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        // زر مواصلة وتأكيد الطلب
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          ),
          onPressed: () {
            setState(() {
              _isOrderConfirmed = true; // الانتقال للمرحلة الثانية (النجاح)
            });
          },
          child: const Text(
            'نعم، متأكد',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // 2️⃣ المرحلة الثانية: ديالوج النجاح الحالي وسؤال تفريغ السلة
  Widget _buildSuccessStage(BuildContext context) {
    return AlertDialog(
      key: const ValueKey('success_stage'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 28),
          SizedBox(width: 10),
          Text(
            'تم طلبك بنجاح! 🎉',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'أبشرك طلبك وصل وسجلناه عندنا، وخلال أقرب وقت بيتواصل معك موظفنا لتأكيد التفاصيل وترتيب التوصيل.',
            style: TextStyle(fontSize: 16, height: 1.4),
          ),
          SizedBox(height: 15),
          Divider(),
          SizedBox(height: 10),
          Text(
            'حاب تفضّي وتفرّغ السلة الحين ولا تخلي المنتجات فيها؟',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        // زر الاحتفاظ بالسلة
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // إغلاق الديالوج
            widget.onCancel(); // تنفيذ دالة الاحتفاظ بالسلة في الـ Controller
          },
          child: const Text(
            'خليها بالسلة',
            style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        // زر تأكيد الحذف والتفريغ
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          onPressed: () {
            Navigator.of(context).pop(); // إغلاق الديالوج
            widget.onConfirm(); // تنفيذ دالة مسح السلة في الـ Controller
          },
          child: const Text(
            'فضّي السلة',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}