import 'dart:async'; // Stream için gerekli
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart'; // Flutter UI bileşen
import 'package:zelix_kingdom/managements/productmanagements.dart'; // Ürün yönetimi
import 'package:zelix_kingdom/models/product.dart'; // Ürün modeli
import 'package:google_fonts/google_fonts.dart'; // Özel fontlar

class ProductionPage extends StatefulWidget {
  // Üretim sayfası
  const ProductionPage({super.key});

  @override
  ProductionPageState createState() => ProductionPageState();
}

class ProductionPageState extends State<ProductionPage> {
  ProductManagement _productManagement = ProductManagement(); // Ürün yönetimi
  Timer? _timer; // Zamanlayıcı
  List<Product> products = []; // Ürünler
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference allproducts = FirebaseFirestore.instance.collection('products');

  @override
  void initState() {
    _productManagement = ProductManagement();
    super.initState();
  }
Future<void> _startTimer(Product product) async {
  _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
    int remainingTime = await _calculateRemainingTime(product);
    if (remainingTime <= 0) {
      await _productManagement.syncProductsToUserFirebaseAndIncreaseAmount(product);
      _timer?.cancel();
    } else {
      await _productManagement.updateProductRemainingTime(product, remainingTime);
    }
  });
}

Future<int> _calculateRemainingTime(Product product) async {
  int productionTime = product.productionTime;
  DateTime startTime = product.startTime!;
  int remainingTime = productionTime - DateTime.now().difference(startTime).inSeconds;
  return remainingTime;
}

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    //final userProducts = _productManagement.fetchUserProductsFromFirebase().then((value) => value);
    //final allProducts = _productManagement.fetchProductsFromFirebase().then((value) => value);
    return StreamBuilder<QuerySnapshot<Object?>>(
      stream: users.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
         // return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('An error occurred.'));
        }
        products = snapshot.data!.docs.map((doc) => Product.fromJson((doc.data() as Map<String, dynamic>)['products'].values.first as Map<String, dynamic>)).toList();
         print('Snapshot data: ${products.map((e) => e.remainingTime)}');
        return Scaffold(
          
          appBar: AppBar(
            
            title: Text('Production', style: GoogleFonts.lato()), // Başlık
          ),
          body: ListView.builder(
                itemCount: products.length, // Ürün sayısı
                itemBuilder: (context, index) {
                  final product = products[index]; // Mevcut ürün
                  final cardColor =
                      product.isProducing
                          ? Colors.yellow
                          : Colors.red; // Kart rengi
        
                  return Card(
                    color: cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 8,
                    child: ListTile(
                      title: Text(product.name, style: GoogleFonts.lato()),
                      subtitle:
                          product.isProducing
                              ? Text(
                                'Producing... ${product.remainingTime} Started at: ${product.startTime}',
                                style: GoogleFonts.lato(),
                              )
                              : Text(
                                'Not producing...' '${product.remainingTime}',
                                style: GoogleFonts.lato(),
                              ),
                      trailing:
                          product.isProducing
                              ? IconButton(
                                icon: const Icon(Icons.cancel), // İptal butonu
                                onPressed: () => setState(() {
                                  product.isProducing = false;
                                  product.startTime = null;
                                }),
                              )
                              : ElevatedButton(
                                onPressed:
                                      () {
                                        product.isProducing = true;
                                        product.startTime = DateTime.now();
                                        _startTimer(product);
                                      },
                                child: const Text('Start'),
                              ),
                    ),
                  );
                },
              ),
        );
      }
    );
  }
}
