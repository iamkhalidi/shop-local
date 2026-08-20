import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/snackbar_service.dart';

class CustomSnackbarHost extends StatelessWidget {
  const CustomSnackbarHost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = SnackbarService.instance;

    return Obx(() {
      final isVisible = service.isVisible.value;
      final type = service.type.value;
      
      Color bgColor;
      IconData icon;
      
      switch (type) {
        case SnackBarType.success:
          bgColor = Colors.green.shade600;
          icon = Icons.check_circle_outline;
          break;
        case SnackBarType.error:
          bgColor = Colors.red.shade600;
          icon = Icons.error_outline;
          break;
        case SnackBarType.warning:
          bgColor = Colors.orange.shade800;
          icon = Icons.warning_amber_rounded;
          break;
        case SnackBarType.info:
        default:
          bgColor = Colors.blue.shade600;
          icon = Icons.info_outline;
          break;
      }

      return AnimatedPositioned(
        duration: const Duration(milliseconds: 600),
        curve: Curves.fastOutSlowIn,
        // 🚀 التموضع الذكي: يبدأ من الصفر (خلف البار الزجاجي) ويصعد ليكون ملتصقاً بأعلاه
        // 65 (ارتفاع البار) + 10 (البادينج السفلي) = 75
        bottom: isVisible ? 75 : -80,
        left: 20,
        right: 20,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 400),
          opacity: isVisible ? 1.0 : 0.0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: bgColor.withOpacity(0.9),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(5), // حواف سفلية حادة لتبدو ملتصقة
                bottomRight: Radius.circular(5),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                )
              ],
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.title.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        service.message.value,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54, size: 18),
                  onPressed: () => service.hide(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
