import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zelix_kingdom/models/product.dart';

class ProductManagement {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Firebase'den tüm ürünleri çek ve Hive'a kaydet
  Future<Product> fetchProductsFromFirebase() async {
    var product = Product(name: '', productionTime: 0);
    try {
      final snapshot = await _db.collection('products').get();
      print('Fetched ${snapshot.docs.length} products from Firebase.');
      for (var doc in snapshot.docs) {
        product = Product.fromJson(doc.data());
      }
      return product;
    } catch (e) {
      print('Error fetching products: $e');
    }
    return product;
  }

  // Firebase'de kullanıcı ürün durumlarını güncelle
  Future<void> syncProductToUserFirebase(Product product, int amount) async {
    try {
      await _db
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid).
          update({
            'products':  {{
                'name': product.name,
                'productionTime': product.productionTime,
                'isProducing': product.isProducing,
                'startTime': product.startTime?.toIso8601String(),}, amount+1}
            
          });
    } catch (e) {
      print('Error syncing product to Firebase: $e');
    }
  }
}
