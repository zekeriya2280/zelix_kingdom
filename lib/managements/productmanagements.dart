import 'package:firebase_auth/firebase_auth.dart';
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

    print('Fetching products from Firebase...');
    try {
      final snapshot = await _db.collection('products').get();
      print('Fetched ${snapshot.docs.length} products from Firebase.');
      for (var doc in snapshot.docs) {
        final product = Product.fromJson(doc.id, doc.data());
        print('Saving product ${product.name} to Hive...');
        box.put(product.id, product);
      }
      print('All products saved to Hive.');
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
  Future<void> syncProductToFirebase(Product product) async {
    try {
      await _db
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('userProducts').add(product.toJson());
    } catch (e) {
      print('Error syncing product to Firebase: $e');
    }
  }
}
