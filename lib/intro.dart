import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zelix_kingdom/auth/login.dart';
import 'package:zelix_kingdom/models/product.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  @override
  void initState() {
    addProductsToFirestore();  //   RESET ............................................
    super.initState();
  }

  Future<void> addProductsToFirestore() async {
    // Ürünleri PRODUCTS a ekler // RESET ............................................
    final allproducts = _db.collection('products');
    try {
      final snapshot = await allproducts.get();
      final oldproducts =
          snapshot.docs.isEmpty
              ? []
              : snapshot.docs
                  .map((doc) => Product.fromJson(doc.data()))
                  .toList();
      //if (snapshot.docs.isNotEmpty) {
      // Mevcut ürünler yoksa, yeni ürünleri ekleyin
      var newProducts = [
        Product(
          id: Random().nextInt(1000000000).toString(),
          name: 'water', 
          productionTime: Random().nextInt(100) + 3,
          remainingTime: Random().nextInt(100) + 3,
          purchasePrice: 2000,
          startTime: null,
          isProducing: false,
          amount: 0,
          unlocked: false,
          requiredMaterials: {},
          productLevel: 1,
        ),
        // Daha fazla ürün ekleyebilirsiniz
      ];
      newProducts =
          oldproducts == []
              ? newProducts
              : newProducts
                  .where(
                    (product) =>
                        !oldproducts.any(
                          (oldproduct) => oldproduct.id == product.id,
                        ),
                  )
                  .toList();
      for (final product in newProducts) {
        await allproducts.doc(product.id).set(product.toJson());
      }
      // }
    } catch (e) {
      print('Error adding products to Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
         Image(image: AssetImage('assets/arkaplan.jpeg'),alignment: Alignment.center, fit: BoxFit.cover, width: double.infinity, height: double.infinity,),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false, // Add this line
            backgroundColor: const Color.fromARGB(
              218,
              13,
              72,
              161,
            ), // Mavi arka plan
            title: const Text(
              'ZELIX KINGDOM',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontStyle: FontStyle.italic,
                letterSpacing: 5,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () {
                  _auth.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll<Color>(
                      const Color.fromARGB(215, 161, 77, 13),
                    ),
                    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                    padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                    ),
                    side: WidgetStatePropertyAll<BorderSide>(
                      BorderSide(color: Colors.grey, width: 2.0),
                    ),
                    minimumSize: WidgetStatePropertyAll<Size>(
                      Size(
                        MediaQuery.of(context).size.width / 1.2,
                        MediaQuery.of(context).size.height / 10,
                      ),
                    ),
                    maximumSize: WidgetStatePropertyAll<Size>(
                      Size(
                        MediaQuery.of(context).size.width / 1.2,
                        MediaQuery.of(context).size.height / 10,
                      ),
                    ),
                    alignment: Alignment.center,
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/techtree',
                      (route) => false,
                    );
                  },
                  child: Text(
                    'Game',
                    style: GoogleFonts.roboto(
                      fontSize: 24.0,
                      letterSpacing: 2,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll<Color>(
                      const Color.fromARGB(215, 161, 77, 13),
                    ),
                    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                    padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                    ),
                    side: WidgetStatePropertyAll<BorderSide>(
                      BorderSide(color: Colors.grey, width: 2.0),
                    ),
                    minimumSize: WidgetStatePropertyAll<Size>(
                      Size(
                        MediaQuery.of(context).size.width / 1.2,
                        MediaQuery.of(context).size.height / 10,
                      ),
                    ),
                    maximumSize: WidgetStatePropertyAll<Size>(
                      Size(
                        MediaQuery.of(context).size.width / 1.2,
                        MediaQuery.of(context).size.height / 10,
                      ),
                    ),
                    alignment: Alignment.center,
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/howtoplay',
                      (route) => false,
                    );
                  },
                  child: Text(
                    'How to Play',
                    style: GoogleFonts.roboto(
                      fontSize: 24.0,
                      letterSpacing: 2,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll<Color>(
                      const Color.fromARGB(215, 161, 77, 13),
                    ),
                    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                    padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                    ),
                    side: WidgetStatePropertyAll<BorderSide>(
                      BorderSide(color: Colors.grey, width: 2.0),
                    ),
                    minimumSize: WidgetStatePropertyAll<Size>(
                      Size(
                        MediaQuery.of(context).size.width / 1.2,
                        MediaQuery.of(context).size.height / 10,
                      ),
                    ),
                    maximumSize: WidgetStatePropertyAll<Size>(
                      Size(
                        MediaQuery.of(context).size.width / 1.2,
                        MediaQuery.of(context).size.height / 10,
                      ),
                    ),
                    alignment: Alignment.center,
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/options',
                      (route) => false,
                    );
                  },
                  child: Text(
                    'Options',
                    style: GoogleFonts.roboto(
                      fontSize: 24.0,
                      letterSpacing: 2,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
       
      ],
    );
  }
}
