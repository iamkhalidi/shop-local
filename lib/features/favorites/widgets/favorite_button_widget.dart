import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../categories/model/product_model.dart';
import '../controller/favorites_controller.dart';

class FavoriteButton extends StatelessWidget {
  final ProductModel product;
  final double size;

  const FavoriteButton({
    Key? key,
    required this.product,
    this.size = 22,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // التأكد من عمل Injection أو إيجاد الكنترولر بأمان
    final favoritesController = Get.put(FavoritesController());

    return Obx(() {
      final isFav = favoritesController.isFavorite(product.id);
      return IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        icon: Icon(
          isFav ? Icons.favorite : Icons.favorite_border,
          color: isFav ? Colors.red : Colors.grey,
          size: size,
        ),
        onPressed: () {
          favoritesController.toggleFavorite(product);
        },
      );
    });
  }
}