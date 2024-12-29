import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zelix_kingdom/models/product.dart';

class ProductManagement {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _hiveBoxName = 'productsBox';

  // Hive kutusunu aç
  Future<void> initHive() async {
    await Hive.openBox<Product>(_hiveBoxName);
  }

  // Firebase'den tüm ürünleri çek ve Hive'a kaydet
  Future<void> fetchProductsFromFirebase() async {
    final box = Hive.box<Product>(_hiveBoxName);

    try {
      final snapshot = await _db.collection('products').get();
      for (var doc in snapshot.docs) {
        final product = Product.fromJson(doc.id, doc.data());
        box.put(product.id, product);
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  // Hive'dan tüm ürünleri getir
  List<Product> getProductsFromHive() {
    final box = Hive.box<Product>(_hiveBoxName);
    return box.values.toList();
  }

  // Ürün durumunu güncelle
  Future<void> updateProductInHive(Product product) async {
    final box = Hive.box<Product>(_hiveBoxName);
    box.put(product.id, product);
  }

  // Firebase'de kullanıcı ürün durumlarını güncelle
  Future<void> syncProductToFirebase(String userId, Product product) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('userProducts')
          .doc(product.id)
          .set(product.toJson());
    } catch (e) {
      print('Error syncing product to Firebase: $e');
    }
  }
}
