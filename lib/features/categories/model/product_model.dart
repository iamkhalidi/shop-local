class ProductModel {
  final String id;
  final String name;
  final String description;
  final double originalPrice;
  final double currentPrice;
  final bool hasDiscount;
  final int stockQuantity;
  final String unitType;
  final double sizeVolume;
  final String imageUrl;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.originalPrice,
    required this.currentPrice,
    required this.hasDiscount,
    required this.stockQuantity,
    required this.unitType,
    required this.sizeVolume,
    required this.imageUrl,
  });

  // حساب نسبة الخصم تلقائياً
  int get discountPercentage {
    if (hasDiscount && originalPrice > 0) {
      return (((originalPrice - currentPrice) / originalPrice) * 100).round();
    }
    return 0;
  }

  // تحويل البيانات القادمة من Firestore (Map) إلى Object
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final double original = (json['original_price'] as num?)?.toDouble() ?? 0.0;
    final double current = (json['current_price'] as num?)?.toDouble() ?? 0.0;

    return ProductModel(
      id: json['id'] ?? '',
      name: json['name_'] ?? '', // نلاحظ هنا أن الحقل المرفوع يسمى name_
      description: json['description'] ?? '',
      originalPrice: original,
      currentPrice: current,
      // الخصم يظهر فقط إذا كان السعر الأصلي (المشطوب) أكبر من الحالي (المعتمد)
      hasDiscount: original > current && current > 0,
      stockQuantity: json['stock_quantity'] ?? 0,
      unitType: json['unit_type'] ?? '',
      sizeVolume: (json['size_volume'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image_url'] ?? '',
    );
  }

  // تحويل الـ Object إلى Map في حال الحاجة مستقبلاً
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_': name,
      'description': description,
      'original_price': originalPrice,
      'current_price': currentPrice,
      'has_discount': hasDiscount,
      'stock_quantity': stockQuantity,
      'unit_type': unitType,
      'size_volume': sizeVolume,
      'image_url': imageUrl,
    };
  }
}