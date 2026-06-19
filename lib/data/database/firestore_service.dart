import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/categories/model/category_model.dart';
import '../../features/categories/model/product_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. جلب الفئات الأساسية
  Future<List<CategoryModel>> fetchAllCategories() async {
    try {
      var snapshot = await _db.collection('categories').get();
      return snapshot.docs
          .map((doc) => CategoryModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print("Error Fetching Categories: $e");
      return [];
    }
  }


  // جلب قائمة المنتجات التابعة لفئة معينة عبر الـ Subcollection
  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('categories')
          .doc(categoryId)
          .collection('products')
          .get();

      return snapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("❌ خطأ أثناء جلب المنتجات من الفايرستور: $e");
      return [];
    }
  }
}