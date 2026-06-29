import 'package:flutter/material.dart';

class DeleteOrderDialog extends StatefulWidget {
  final Future<bool> Function() onDeleteConfirmed;

  const DeleteOrderDialog({
    Key? key,
    required this.onDeleteConfirmed,
  }) : super(key: key);

  @override
  State<DeleteOrderDialog> createState() => _DeleteOrderDialogState();
}

class _DeleteOrderDialogState extends State<DeleteOrderDialog> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.delete_forever, color: Colors.red, size: 28),
            SizedBox(width: 10),
            Text('حذف الطلب ⚠️', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          'هل أنت متأكد تماماً من رغبتك في حذف هذا الطلب؟ لا يمكن التراجع عن هذه العملية لاحقاً.',
          style: TextStyle(fontSize: 16, height: 1.4),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: _isDeleting ? null : () => Navigator.of(context).pop(),
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey, fontSize: 16)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            ),
            onPressed: _isDeleting
                ? null
                : () async {
              setState(() => _isDeleting = true);

              bool success = await widget.onDeleteConfirmed();

              if (mounted) {
                setState(() => _isDeleting = false);
                if (success) {
                  Navigator.of(context).pop(); // إغلاق الديالوج
                  Navigator.of(context).pop(); // الرجوع للشاشة السابقة لأن الطلب حُذف
                }
              }
            },
            child: _isDeleting
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            )
                : const Text('نعم، احذف', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}