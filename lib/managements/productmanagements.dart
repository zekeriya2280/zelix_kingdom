import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zelix_kingdom/models/city.dart';
import 'package:zelix_kingdom/models/factory.dart';
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
  Future<void> signUpToFirebaseUsers(
      String id,
      String nickname,
      String email,
      Map<Factory, int> factories,
      Map< String , Map< Product, int > > products,
      Map<City, int> cities) async {
    if ([id, nickname, email].any((element) => element.isEmpty)) {
      print('Invalid input: all fields must be non-empty.');
      return;
    }
    try {
      final userData = {
        'id': id,
        'nickname': nickname,
        'email': email,
        'money': 1000,
        'factories': factories,
        'products': products,
        'cities': cities
      };
      await FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .set(userData);
      print('User successfully created.');
    } on FirebaseException catch (e) {
      print(e.code == 'permission-denied'
          ? 'Permission denied: $e'
          : 'Error creating user: $e');
    } catch (e) {
      print('An unexpected error occurred: $e');
    }
  }
}
