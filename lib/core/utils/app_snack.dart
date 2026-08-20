import 'package:flutter/material.dart';
import '.././../services/snackbar_service.dart';

class AppSnack {
  static void show({
    required String title,
    required String message,
    SnackBarType type = SnackBarType.info,
  }) {
    SnackbarService.instance.show(
      title: title,
      message: message,
      type: type,
    );
  }

  static void success(String message, {String title = 'تم بنجاح'}) {
    show(title: title, message: message, type: SnackBarType.success);
  }

  static void error(String message, {String title = 'خطأ'}) {
    show(title: title, message: message, type: SnackBarType.error);
  }

  static void warning(String message, {String title = 'تنبيه'}) {
    show(title: title, message: message, type: SnackBarType.warning);
  }
}
