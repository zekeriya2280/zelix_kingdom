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

  @override
  void initState() {
    _productManagement = ProductManagement();
    super.initState();
  }

  Future<void> _startTimer(Product product) async {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      int remainingTime = await _calculateRemainingTime(product);
      if (remainingTime <= 0) {
        await _productManagement.syncProductsToUserFirebaseAndIncreaseAmount(
          product,
        );
        _timer?.cancel();
      } else {
        await _productManagement.updateProductRemainingTime(
          product,
          remainingTime,
        );
      }
    });
  }

  Future<int> _calculateRemainingTime(Product product) async {
    int productionTime = product.productionTime;
    DateTime startTime = product.startTime!;
    int remainingTime =
        productionTime - DateTime.now().difference(startTime).inSeconds;
    return remainingTime;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Object?>>(
      stream: users.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator( color: Colors.white, strokeWidth: 1000,));
        }
        if (snapshot.hasError) {
          return const Center(child: Text('An error occurred.'));
        }
        products =
            snapshot.data!.docs
                .map((doc) {
                  final productMap = doc.data() as Map<String, dynamic>;
                  final productsMap =
                      productMap['products'] as Map<String, dynamic>;
                  List<dynamic> allproducts = productsMap.values.toList();
                  //print(
                  //  '.........................................................',
                  //);
                  //print('Product: $allproducts');
                  //print(
                  //  '.........................................................',
                  //);
                  return allproducts.map((e) => Product.fromJson(e)).toList();
                })
                .expand((list) => list)
                .toList();
        print('Snapshot data: ${products.map((e) => e.remainingTime)}');
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 200, 211, 219),
          appBar: AppBar(
            title: Text(
              'Owned Products',
              style: GoogleFonts.lato(color: Colors.white),
            ), // Başlık
            centerTitle: true,
            backgroundColor: const Color.fromARGB(216, 13, 72, 161), // Mavi arka plan
            actions: [
              IconButton(
                icon: const Icon(Icons.home, color: Colors.white),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/intro');
                },
              ),
            ],
          ),
          body: ListView.builder(
            itemCount: products.length, // Ürün sayısı
            itemBuilder: (context, index) {
              final product = products[index]; // Mevcut ürün
              final cardColor =
                  product.isProducing
                      ? const Color.fromARGB(122, 255, 230, 0)
                      : Colors.orange; // Kart rengi

              return SingleChildScrollView(
                child: InkWell(
                  onTap:
                      () => showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: Center(child: Text(product.name,
                                style: GoogleFonts.lato(
                                  fontFeatures: const [FontFeature.enable('smcp')],
                                  color: const Color.fromARGB(255, 246, 255, 0),
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                  wordSpacing: 1.5,
                                  shadows: const <Shadow>[
                                    Shadow(
                                      offset: Offset(2.0, 2.0),
                                      blurRadius: 3.0,
                                      color: Color.fromARGB(255, 255, 0, 0),
                                    ),
                                  ],
                                  fontStyle: FontStyle.italic,
                                ),
                              )),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text('Name:  ${product.name}'),
                                  SizedBox(height: 5),
                                  Text('ID:  ${product.id}'),
                                  SizedBox(height: 5),
                                  Text(
                                    'Production Time:   ${product.productionTime}',
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Remaining Time:  ${product.remainingTime}',
                                  ),
                                  SizedBox(height: 5),
                                  Text('Started At:   ${product.startTime}'),
                                  SizedBox(height: 5),
                                  Text('Amount:   ${product.amount}'),
                                  SizedBox(height: 5),
                                  Text('Is Producing:  ${product.isProducing}'),
                                  
                                ],
                              ),
                              actions: [
                                TextButton(
                                  child: Center(
                                    child: Text(
                                      'Close',
                                      style: GoogleFonts.lato(
                                        color: Colors.red,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                              backgroundColor: const Color.fromARGB(215, 34, 61, 102),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              titleTextStyle: GoogleFonts.lato(
                                color: const Color.fromARGB(255, 255, 247, 0),
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                
                              ),
                              alignment: Alignment.center,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              titlePadding: const EdgeInsets.all(20),
                              actionsAlignment: MainAxisAlignment.spaceBetween,
                              contentTextStyle: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                      ),
                  child: Card(
                    color: cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 8,
                    child: ListTile(
                      title: Text(product.name, style: GoogleFonts.lato(

                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        wordSpacing: 1.5,
                      )),
                      subtitle:
                          product.isProducing
                              ? Text(
                                'Producing... ${product.remainingTime} Started at: ${product.startTime}',
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                  wordSpacing: 1.5,
                                ),
                              )
                              : Text(
                                'Not producing...'
                                '${product.productionTime}',
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                  wordSpacing: 1.5,
                                ),
                              ),
                      trailing:
                          product.isProducing
                              ? IconButton(
                                icon: const Icon(Icons.cancel), // İptal butonu
                                onPressed:
                                    () => setState(() {
                                      product.isProducing = false;
                                      product.startTime = null;
                                    }),
                              )
                              : ElevatedButton(
                                onPressed: () {
                                  product.isProducing = true;
                                  product.startTime = DateTime.now();
                                  _startTimer(product);
                                },
                                child: const Text('Start'),
                              ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
