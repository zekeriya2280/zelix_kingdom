import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zelix_kingdom/models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  Future<void> fetchProducts() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('products').get();
    _products = querySnapshot.docs.map((doc) => Product.fromJson(doc.data())).toList();
    notifyListeners();
  }

  ProductProvider() {
    fetchProducts();
  }
}