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


  // جلب قائمة المنتجات التابعة لفئة معينة مع دعم التجزئة (Pagination)
  Future<({List<ProductModel> products, DocumentSnapshot? lastDoc})> getProductsByCategory(
    String categoryId, {
    int? limit,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      Query query = _db
          .collection('categories')
          .doc(categoryId)
          .collection('products');
      
      // إذا كان هناك مستند سابق، نبدأ الجلب من بعده
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      QuerySnapshot snapshot = await query.get();

      List<ProductModel> products = snapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return (
        products: products,
        lastDoc: snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
      );
    } catch (e) {
      print("❌ خطأ أثناء جلب المنتجات من الفايرستور: $e");
      return (products: <ProductModel>[], lastDoc: null);
    }
  }


  // ====== 🌟 التحديث الجديد والمطور للمفضلة 🌟 ======

  // 1. إضافة كائن المنتج كاملاً إلى مصفوفة المفضلة داخل مستند المستخدم
  Future<void> addToFavorites(String uid, ProductModel product) async {
    try {
      await _db.collection('users').doc(uid).update({
        'favorites': FieldValue.arrayUnion([product.toJson()])
      });
    } catch (e) {
      print("❌ خطأ أثناء إضافة المنتج للمفضلة: $e");
    }
  }

  // 2. إزالة المنتج من المفضلة بناءً على الـ id الخاص به لضمان الدقة
  Future<void> removeFromFavorites(String uid, String productId) async {
    try {
      DocumentReference userDoc = _db.collection('users').doc(uid);

      // جلب المستند الحالي للمستخدم
      DocumentSnapshot snapshot = await userDoc.get();
      if (snapshot.exists && snapshot.data() != null) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        List<dynamic> favorites = data['favorites'] ?? [];

        // إزالة المنتج الذي يطابق الـ id المطلوب
        favorites.removeWhere((item) => item['id'] == productId);

        // تحديث القائمة بالكامل بعد الحذف محلياً
        await userDoc.update({'favorites': favorites});
      }
    } catch (e) {
      print("❌ خطأ أثناء إزالة المنتج من المفضلة: $e");
    }
  }

  // 3. جلب قائمة المنتجات المفضلة كاملة بطلب واحد فقط (Fast & Efficient)
  Future<List<ProductModel>> getUserFullFavorites(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data['favorites'] != null) {
          List<dynamic> favList = data['favorites'];
          // تحويل الخريطة القادمة مباشرة إلى كائنات ProductModel
          return favList.map((item) => ProductModel.fromJson(item as Map<String, dynamic>)).toList();
        }
      }
      return [];
    } catch (e) {
      print("❌ خطأ أثناء جلب قائمة المفضلة: $e");
      return [];
    }
  }





}
