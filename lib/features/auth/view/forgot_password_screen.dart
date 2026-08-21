import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';

class ForgotPasswordScreen extends GetView<AuthController> {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('استعادة كلمة السر'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.lock_reset, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              'هل نسيت كلمة المرور؟',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'أدخل بريدك الإلكتروني المسجل وسنقوم بإرسال رابط مخصص لإعادة تعيين كلمة السر الخاصة بك.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // حقل البريد
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'البريد الإلكتروني',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 25),

            // زر إرسال الرابط
            Obx(() => controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                if (emailController.text.isNotEmpty) {
                  controller.resetPassword(emailController.text.trim());
                } else {
                  Get.snackbar('تنبيه', 'الرجاء إدخال البريد الإلكتروني أولاً', backgroundColor: Colors.orange, colorText: Colors.white);
                }
              },
              child: const Text('إرسال رابط إعادة التعيين', style: TextStyle(fontSize: 16)),
            )),

            const SizedBox(height: 20),
            
            // 🌟 رسالة توضيحية بخصوص البريد غير المرغوب فيه
            const Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: [
                  Text(
                    '>> تنبيه: في حال لم تصلك الرسالة في "البريد الوارد"، يرجى التحقق من مجلد "البريد غير المرغوب فيه" (Spam) <<',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12, 
                      color: Colors.orange, 
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'في حال فقدت كلمة السر تواصل مع المشرف من خلال رقم المتجر.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}