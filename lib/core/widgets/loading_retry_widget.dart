import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingRetryWidget extends StatefulWidget {
  final RxBool isLoading;
  final VoidCallback onRetry;
  final int timeoutSeconds;
  final Widget child;

  const LoadingRetryWidget({
    Key? key,
    required this.isLoading,
    required this.onRetry,
    required this.child,
    this.timeoutSeconds = 7, // جعلناه 7 ثواني ليكون أكثر واقعية لشبكات الإنترنت
  }) : super(key: key);

  @override
  State<LoadingRetryWidget> createState() => _LoadingRetryWidgetState();
}

class _LoadingRetryWidgetState extends State<LoadingRetryWidget> {
  Timer? _timer;
  final RxBool _showRetry = false.obs;
  late Worker _worker;

  @override
  void initState() {
    super.initState();
    _startTimerIfNeeded(widget.isLoading.value);
    
    // مراقبة حالة التحميل لإعادة ضبط المؤقت عند الحاجة
    _worker = ever(widget.isLoading, (bool loading) {
      _startTimerIfNeeded(loading);
    });
  }

  void _startTimerIfNeeded(bool loading) {
    _timer?.cancel();
    _showRetry.value = false;
    
    if (loading) {
      _timer = Timer(Duration(seconds: widget.timeoutSeconds), () {
        if (widget.isLoading.value) {
          _showRetry.value = true;
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _worker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (widget.isLoading.value) {
        if (_showRetry.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_off, size: 50, color: Colors.grey[400]),
                const SizedBox(height: 12),
                const Text(
                  "عذراً، استغرق التحميل وقتاً طويلاً",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    _showRetry.value = false;
                    widget.onRetry();
                  },
                  icon: const Icon(Icons.refresh, size: 20),
                  label: const Text("إعادة المحاولة", style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      }
      return widget.child;
    });
  }
}
