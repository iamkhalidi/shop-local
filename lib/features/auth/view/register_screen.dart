import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/countries.dart'; // 👈 تأكد من وجود هذا الاستيراد إذا لزم الأمر
import '../../../core/constants/countries_list.dart';
import '../controller/auth_controller.dart';
import '../../../routes/app_pages.dart';

class RegisterScreen extends GetView<AuthController> {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    // نستخدم متغير داخلي مخصص للحزمة لحفظ القيمة الكاملة تلقائياً مع المفتاح
    String fullPhoneNumber = '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء حساب جديد'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.person_add, size: 80, color: Colors.blue),
                const SizedBox(height: 20),
                const Text(
                  'انضم إلى Shop Local',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                // 1. حقل الاسم الكامل
                TextField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    labelText: 'الاسم الكامل',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),

                // 2. حقل رقم الجوال الذكي والمحدث بدون أخطاء
                IntlPhoneField(
                  keyboardType: TextInputType.phone,
                  languageCode: "ar", // قائمة البحث باللغة العربية
                  initialCountryCode: 'SA', // السعودية افتراضياً

                  // 🌍 تحديد قائمة الدول المتاحة (الخليج) بالنظام الجديد للحزمة لمنع خطأ الـ Country
                  countries: allCountries,

                  // 🛠️ التنسيق والتصميم الداخلي للحقل
                  decoration: const InputDecoration(
                    labelText: 'رقم الجوال',
                    border: OutlineInputBorder(),
                    counterText: "",
                  ),

                  // 🎨 تنسيق الخط الخاص بكود الدولة والعلم
                  dropdownTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 16
                  ),

                  // 📐 ضبط المسافات والأيقونة
                  flagsButtonPadding: const EdgeInsets.symmetric(horizontal: 8),
                  showDropdownIcon: true,
                  dropdownIconPosition: IconPosition.trailing,

                  // 📥 حفظ الرقم الكامل تلقائياً مع المفتاح عند الكتابة
                  onChanged: (phone) {
                    fullPhoneNumber = phone.completeNumber; // يعطيك الكود + الرقم معاً تلقائياً
                  },
                ),
                const SizedBox(height: 15),

                // 3. حقل البريد الإلكتروني
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),

                // 4. حقل كلمة المرور
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'كلمة المرور',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 25),

                // زر إنشاء الحساب التفاعلي
                Obx(() => controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    final name = nameController.text.trim();
                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();

                    // نتحقق من أن المتغيرات ممتلئة والرقم تم كتابته
                    if (name.isNotEmpty && fullPhoneNumber.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {

                      // نمرر الرقم الكامل المدمج تلقائياً بواسطة الحزمة للكنترولر
                      controller.register(
                        name: name,
                        phone: fullPhoneNumber,
                        email: email,
                        password: password,
                      );
                    } else {
                      Get.snackbar(
                        'تنبيه',
                        'الرجاء تعبئة جميع الحقول المطلوبة',
                        backgroundColor: Colors.orange,
                        colorText: Colors.white,
                      );
                    }
                  },
                  child: const Text('إنشاء الحساب', style: TextStyle(fontSize: 16)),
                )),
                const SizedBox(height: 20),

                // الرجوع لصفحة تسجيل الدخول
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('لديك حساب بالفعل؟'),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('تسجيل الدخول', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}