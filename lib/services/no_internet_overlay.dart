import 'package:flutter/material.dart';

class NoInternetOverlay extends StatelessWidget {
  const NoInternetOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.85), // خلفية داكنة تحجب الرؤية والتفاعل
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.wifi_off_rounded,
                size: 80,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 24),
              const Text(
                'انقطع الاتصال بالإنترنت',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'يرجى التحقق من اتصال شبكة الجوال أو الواي فاي لديك.\nسيتم إعادة تشغيل الموقع تلقائياً فور عودة الإشارة.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade400,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),
              const SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  color: Colors.blue,
                  strokeWidth: 2.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}