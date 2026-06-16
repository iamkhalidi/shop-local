import 'package:get/get.dart';

class HomeController extends GetxController {
  // قائمة تصنيفات تجريبية للمتجر
  final categories = <String>[
    'الكل',
    'إلكترونيات',
    'ملابس',
    'أحذية',
    'عطور',
    'أثاث'
  ].obs;

  // متغير لمراقبة التصنيف المختار حالياً
  var selectedCategory = 0.obs;

  void changeCategory(int index) {
    selectedCategory.value = index;
  }
}