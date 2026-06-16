class CartItemModel {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  int quantity;

  CartItemModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  // تحويل البيانات من وإلى JSON (جاهزة لربطها بالـ Logic مستقبلاً)
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
    };
  }
}