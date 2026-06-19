import '../../categories/model/category_model.dart';
import '../../categories/model/product_model.dart';

class HomeModel {
  final List<CategoryModel> featuredCategories;
  final List<ProductModel> displayedProducts;

  HomeModel({
    required this.featuredCategories,
    required this.displayedProducts,
  });
}