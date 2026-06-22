import '../../categories/model/product_model.dart';

class CartItemModel {
  final String id;
  final String productName;
  final double price;
  int quantity;
  final String image;

  CartItemModel({
    required this.id,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.image,
  });

  // تحويل من Map عادية (لأن البيانات ستأتي من داخل المصفوفة)
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] ?? '',
      productName: json['productName'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      quantity: json['quantity'] ?? 1,
      image: json['image'] ?? '',
    );
  }

  // تحويل إلى Map لحفظها داخل المصفوفة
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'image': image,
    };
  }

  factory CartItemModel.fromProduct(ProductModel product, {int quantity = 1}) {
    return CartItemModel(
      id: product.id,
      productName: product.name,
      price: product.currentPrice.toDouble(),
      quantity: quantity,
      image: product.imageUrl,
    );
  }
}