class CategoryModel {
  final String id;
  final String nameAr;
  final String nameEn;
  final String icon;
  final String color;

  CategoryModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.icon,
    required this.color,
  });

  // مصنع (Factory) لتحويل بيانات الفايرستور القادمة إلى كائن Dart
  factory CategoryModel.fromFirestore(Map<String, dynamic> json, String docId) {
    return CategoryModel(
      id: docId,
      nameAr: json['name_ar'] ?? '',
      nameEn: json['name_en'] ?? '',
      icon: json['icon'] ?? 'local_grocery_store',
      color: json['color'] ?? 'FFFCEBE2',
    );
  }
}