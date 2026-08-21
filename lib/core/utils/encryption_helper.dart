import 'package:encrypt/encrypt.dart';

class EncryptionHelper {
  // 🔐 مفتاح تشفير ثابت (يجب أن يكون 32 حرفاً لـ AES-256)
  // ⚠️ تنبيه: يجب استخدام نفس هذا المفتاح في تطبيق Admin Panel لكي يستطيع فك التشفير
  static const String _secretKey = "my-ultra-secret-key-for-aes-256!"; 
  
  static final _key = Key.fromUtf8(_secretKey);
  static final _iv = IV.fromLength(16); // Initialization Vector
  static final _encrypter = Encrypter(AES(_key, mode: AESMode.cbc)); // نستخدم CBC لسهولة التوافق

  /// دالة تشفير كلمة السر
  static String encryptPassword(String password) {
    if (password.isEmpty) return "";
    final encrypted = _encrypter.encrypt(password, iv: _iv);
    return encrypted.base64;
  }

  /// دالة فك التشفير (اختياري للاختبار)
  static String decryptPassword(String encryptedBase64) {
    if (encryptedBase64.isEmpty) return "";
    return _encrypter.decrypt(Encrypted.fromBase64(encryptedBase64), iv: _iv);
  }
}
