import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SnackBarType { success, error, warning, info }

class SnackbarService extends GetxService {
  static SnackbarService get instance => Get.find();

  final RxString message = ''.obs;
  final RxString title = ''.obs;
  final Rx<SnackBarType> type = SnackBarType.info.obs;
  final RxBool isVisible = false.obs;

  void show({
    required String title,
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    this.title.value = title;
    this.message.value = message;
    this.type.value = type;
    isVisible.value = true;

    Future.delayed(duration, () {
      if (this.message.value == message) {
        isVisible.value = false;
      }
    });
  }

  void hide() {
    isVisible.value = false;
  }
}
