import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zelix_kingdom/models/city.dart';
import 'package:zelix_kingdom/models/factory.dart';
import 'package:zelix_kingdom/models/product.dart';

class ProductManagement {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Firebase'den tüm ürünleri çek ve Hive'a kaydet
  Future<List<Product>> fetchProductsFromFirebase() async {
    try {
      final snapshot = await _db.collection('products').get();
      print('Fetched ${snapshot.docs.length} products from Firebase.');
      return snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList();
    } catch (e) {
      print('Error fetching products: $e');
    }
    return [];
  }
  Future<List<Product>> fetchUserProductsFromFirebase(DocumentSnapshot<Map<String, dynamic>> snapshot) async {
    try {
      final snapshot = await _db.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
      if (snapshot.exists) {
        final Map<String, dynamic>? productidanduserProductsmap = snapshot.data()!['products'];
        print('Fetched $productidanduserProductsmap products from Firebase.');
        if (productidanduserProductsmap != null) {
          print('Fetched $productidanduserProductsmap products from Firebase.');
          return productidanduserProductsmap.map((key, value) => MapEntry(key, Product.fromJson(value))).values.toList();
        }
      }
    } on FirebaseException catch (e) {
      print('Error fetching products: $e');
    } catch (e) {
      print('An unexpected error occurred: $e');
    }
    return [];
  }

  // Firebase'de kullanıcı ürün durumlarını güncelle
 Future<void> updateProductRemainingTime(Product product, int remainingTime) async {
  await _db
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .update({
        'products.${product.id}': {
          'remainingTime': remainingTime,
          'isProducing': product.isProducing,
          'startTime': product.startTime,
          'id': product.id,
          'name': product.name,
          'productionTime': product.productionTime,
          'amount': product.amount
        }
      });
}
Future<void> addSelectedProductFromAllProductsToUserFBProducts(Product product) async {
  await _db
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .update({
        'products.${product.id}': {
          'remainingTime': product.remainingTime,
          'isProducing': product.isProducing,
          'startTime': product.startTime,
          'id': product.id,
          'name': product.name,
          'productionTime': product.productionTime,
          'amount': product.amount
        }
      });
}
 Future<void> addProductsToFirestore() async { // Ürünleri PRODUCTS a ekler // RESET ............................................
    final allproducts = _db.collection('products');
    try {
      final snapshot = await allproducts.get();
      final oldproducts = snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList();
      if (snapshot.docs.isNotEmpty) {
        // Mevcut ürünler yoksa, yeni ürünleri ekleyin
        var newProducts = [
          Product(
            id: Random().nextInt(1000000000).toString(),
            name: 'apple',
            startTime: null,
            isProducing: false, 
            productionTime: Random().nextInt(100)+3,
            remainingTime: Random().nextInt(100)+3, 
            amount: 0,
          ),
          Product(
            id: Random().nextInt(1000000000).toString(),
            name: 'water',
            productionTime: Random().nextInt(100)+3,
            remainingTime: Random().nextInt(100)+3,
            startTime: null,
            isProducing: false,
            amount: 0,
          ),
          // Daha fazla ürün ekleyebilirsiniz
        ];  
        newProducts = newProducts.where((product) => !oldproducts.any((oldproduct) => oldproduct.id == product.id)).toList();
        for (final product in newProducts) {
          await allproducts.doc(product.id).set(product.toJson());
        }
      }
    } catch (e) {
      print('Error adding products to Firestore: $e');
    }
  }

Future<void> syncProductsToUserFirebaseAndIncreaseAmount(Product product) async {
  await _db
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .update({
        'products.${product.id}': {
          'name': product.name,
          'productionTime': product.productionTime,
          'isProducing': false,
          'startTime': null,
          'id': product.id,
          'amount': product.amount + 1,
          'remainingTime': 0,
        }
      });
}
Future<void> addToAllProductsToFirebase(Product product) async {
  await _db.collection('products').doc(product.id).set(product.toJson());
}
  Future<int> fetchtheamountoftheproductfromUsersFirebase(Product product)async{
    try {
      final snapshot = await _db.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
      print('Fetched ${snapshot.data()} products from Firebase.');
      final userproducts = snapshot.data()!['products']; 
      for (var productandamountmap in userproducts) {
        productandamountmap.forEach((key, value) {return  key['name'] == product.name ? value : 0; });
        
      }
      return 0;
    } catch (e) {
      print('Error fetching products: $e');
    } 
    return 0;           
  }
  Future<void> signUpToFirebaseUsers(
      String id,
      String nickname,
      String email,
      Map<Factory, int> factories,
      Map< String , Product > products,
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
