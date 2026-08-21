import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';

class EncryptionHelper {
  // 🔐 مفتاح تشفير ثابت (يجب أن يكون 32 حرفاً لـ AES-256)
  static const String _secretKey = "my-ultra-secret-key-for-aes-256!"; 
  
  static final _key = Key.fromUtf8(_secretKey);
  
  // 🔑 تم استخدام IV ثابت (16 بايت من الأصفار) لضمان توافق التشفير بين التطبيقات
  // استخدام IV.fromLength(16) كان ينتج IV عشوائي يمنع فك التشفير في تطبيق Admin
  static final _iv = IV(Uint8List(16)); 
  
  static final _encrypter = Encrypter(AES(_key, mode: AESMode.cbc));

  /// دالة تشفير كلمة السر
  static String encryptPassword(String password) {
    if (password.isEmpty) return "";
    final encrypted = _encrypter.encrypt(password, iv: _iv);
    return encrypted.base64;
  }

  /// دالة فك التشفير
  static String decryptPassword(String encryptedBase64) {
    if (encryptedBase64.isEmpty) return "";
    try {
      return _encrypter.decrypt(Encrypted.fromBase64(encryptedBase64), iv: _iv);
    } catch (e) {
      return encryptedBase64;
    }
  }
}
