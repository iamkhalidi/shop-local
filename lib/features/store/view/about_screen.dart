import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:web/web.dart' as web; // استيراد لدعم الويب المباشر
import '../../../services/store_service.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  // دالة احتياطية للويب لفتح الروابط
  void _openWebLink(String url) {
    if (kIsWeb) {
      web.window.open(url, '_blank');
    }
  }

  // دالة عامة لفتح الروابط (الموقع)
  Future<void> _launchUrl(String url) async {
    if (url.isEmpty) return;
    final cleanUrl = url.trim();
    final Uri uri = Uri.parse(cleanUrl);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        _openWebLink(cleanUrl);
      }
    } catch (e) {
      _openWebLink(cleanUrl);
    }
  }

  // دالة الاتصال الهاتفي
  Future<void> _makeCall(String phoneNumber) async {
    if (phoneNumber.isEmpty) return;
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'\s+'), '');
    final Uri uri = Uri.parse("tel:$cleanPhone");
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (kIsWeb) {
          Get.snackbar('رقم الهاتف', cleanPhone, snackPosition: SnackPosition.BOTTOM);
        }
      }
    } catch (e) {
      if (kIsWeb) {
        Get.snackbar('رقم الهاتف', cleanPhone, snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  // دالة فتح الواتساب
  Future<void> _launchWhatsApp(String phoneNumber) async {
    if (phoneNumber.isEmpty) return;
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'\D'), '');
    final url = "https://wa.me/$cleanNumber";
    final Uri uri = Uri.parse(url);
    
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        _openWebLink(url);
      }
    } catch (e) {
      _openWebLink(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final storeService = StoreService.instance;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Obx(() => Text(
          'عن ${storeService.storeName.value}',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 18),
        )),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl, // 👈 دعم اللغة العربية بالكامل
        child: Obx(() {
          final config = storeService.storeConfig.value;

          // حماية ضد الـ Null في حال لم تكتمل البيانات
          if (config == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // أيقونة المتجر
                Container(
                  height: 100,
                  width: 100,
                  margin: const EdgeInsets.only(top: 10, bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue.shade100, width: 2),
                  ),
                  child: Icon(Icons.storefront, size: 50, color: Colors.blue.shade700),
                ),
                
                Text(
                  config.storeName,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87, fontFamily: 'Cairo'),
                ),
                const SizedBox(height: 25),

                // قسم التواصل
                _buildSection(
                  title: 'معلومات التواصل',
                  children: [
                    _buildInfoTile(
                      icon: Icons.phone,
                      color: Colors.green,
                      title: 'رقم الهاتف',
                      subtitle: config.callNumber,
                      onTap: () => _makeCall(config.callNumber),
                    ),
                    _buildInfoTile(
                      icon: Icons.chat,
                      color: Colors.teal,
                      title: 'واتساب',
                      subtitle: config.whatsappNumber,
                      onTap: () => _launchWhatsApp(config.whatsappNumber),
                    ),
                    _buildInfoTile(
                      icon: Icons.email,
                      color: Colors.orange,
                      title: 'البريد الإلكتروني',
                      subtitle: config.email,
                      onTap: null, // 👈 غير قابل للضغط كما طلبت
                    ),
                    _buildInfoTile(
                      icon: Icons.location_on,
                      color: Colors.redAccent,
                      title: 'موقعنا على الخريطة',
                      subtitle: 'اضغط لفتح جوجل ماب',
                      onTap: () => _launchUrl(config.locationUrl),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // قسم التوصيل وأوقات العمل
                _buildSection(
                  title: 'التوصيل والعمل',
                  children: [
                    _buildInfoTile(
                      icon: Icons.access_time,
                      color: Colors.blue,
                      title: 'أوقات العمل',
                      subtitle: 'من ${config.openTime} إلى ${config.closeTime}',
                    ),
                    _buildInfoTile(
                      icon: Icons.delivery_dining,
                      color: Colors.purple,
                      title: 'معلومات التوصيل',
                      subtitle: config.deliveryInfo,
                    ),
                    _buildInfoTile(
                      icon: Icons.payments,
                      color: Colors.indigo,
                      title: 'رسوم التوصيل',
                      subtitle: '${config.deliveryFee} ريال', // 👈 عرض الرقم فقط
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // قسم سياسة الاسترجاع بتصميم جديد
                _buildReturnPolicyCard(config.returnPolicy),

                const SizedBox(height: 40),
                Text(
                  "جميع الحقوق محفوظة لـ ${config.storeName} © 2026",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontFamily: 'Cairo'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey, fontFamily: 'Cairo'),
          ),
        ),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          color: Colors.white,
          child: Column(children: children),
        ),
      ],
    );
  }

  // تصميم جديد ومرتب لسياسة الاسترجاع
  Widget _buildReturnPolicyCard(String policy) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 8.0, bottom: 8.0),
          child: Text(
            'سياسة الاسترجاع والاستبدال',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey, fontFamily: 'Cairo'),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.assignment_return, color: Colors.orange.shade800, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    'شروط وأحكام المتجر',
                    style: TextStyle(color: Colors.orange.shade900, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'Cairo'),
                  ),
                ],
              ),
              const Divider(height: 25, thickness: 0.5),
              Text(
                policy,
                style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.8, fontFamily: 'Cairo'),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'Cairo'),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: Colors.black54, fontFamily: 'Cairo'),
      ),
      trailing: onTap != null ? const Icon(Icons.arrow_back_ios, size: 14, color: Colors.grey) : null,
      onTap: onTap,
    );
  }
}
