import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/logout_dialog.dart';
import '../controller/profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // أيقونة المستخدم الرئيسية
              const Center(
                child: Icon(Icons.account_circle, size: 100, color: Colors.blue),
              ),
              const SizedBox(height: 30),

              // --- بطاقة البيانات الشخصية ---
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Obx(() => Column(
                    children: [
                      // 1. عرض الاسم الكامل
                      ListTile(
                        leading: const Icon(Icons.person, color: Colors.blue),
                        title: const Text('الاسم الكامل', style: TextStyle(fontSize: 14, color: Colors.grey)),
                        subtitle: Text(
                          controller.userName,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                      ),
                      const Divider(),

                      // 2. عرض البريد الإلكتروني
                      ListTile(
                        leading: const Icon(Icons.email, color: Colors.blue),
                        title: const Text('البريد الإلكتروني', style: TextStyle(fontSize: 14, color: Colors.grey)),
                        subtitle: Text(
                          controller.userEmail,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                      ),
                      const Divider(),

                      // 3. عرض رقم الجوال
                      ListTile(
                        leading: const Icon(Icons.phone, color: Colors.blue),
                        title: const Text('رقم الجوال', style: TextStyle(fontSize: 14, color: Colors.grey)),
                        subtitle: Text(
                          controller.userPhone,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                      ),
                    ],
                  )),
                ),
              ),

              const SizedBox(height: 40),

              // --- زر تسجيل الخروج ---
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.logout),
                label: const Text('تسجيل الخروج', style: TextStyle(fontSize: 16)),
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return LogoutDialog(
                        onConfirm: () {
                          controller.logout();
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}