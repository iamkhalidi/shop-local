import 'package:flutter/material.dart';

class ClearCartDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const ClearCartDialog({
    Key? key,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // زوايا دائرية ناعمة تطابق الـ LogoutDialog
      ),
      title: const Row(
        children: [
          Icon(Icons.delete_sweep, color: Colors.redAccent),
          SizedBox(width: 10),
          Text(
            'تفريغ السلة',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: const Text(
        'هل أنت متأكد من أنك تريد حذف جميع الأصناف والمنتجات من السلة؟',
        style: TextStyle(fontSize: 16),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      actions: [
        // زر التراجع والإلغاء
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // إغلاق الديالوج فقط
          child: const Text(
            'إلغاء',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
        // زر تأكيد الحذف والتفريغ
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(); // إغلاق الديالوج أولاً
            onConfirm(); // تنفيذ دالة مسح السلة
          },
          child: const Text(
            'حذف الكل',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}