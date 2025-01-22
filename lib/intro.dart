import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zelix_kingdom/auth/signup.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //ProductManagement _productManagement = ProductManagement(); // Ürün yönetimi
  @override
  void initState() {
   // _productManagement = ProductManagement(); // Ürün yönetimi
    //_productManagement.addProductsToFirestore(); // Ürünleri products a ekler // RESET
    super.initState();
  }
 //  Future<void> addProductsToFirestore() async { // Ürünleri PRODUCTS a ekler // RESET ............................................
 //   final allproducts = _db.collection('products');
 //   try {
 //     final snapshot = await allproducts.get();
 //     final oldproducts = snapshot.docs.isEmpty ? [] : snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList();
 //     //if (snapshot.docs.isNotEmpty) {
 //       // Mevcut ürünler yoksa, yeni ürünleri ekleyin
 //       var newProducts = [
 //         Product(
 //           id: Random().nextInt(1000000000).toString(),
 //           name: 'apple',
 //           startTime: null,
 //           isProducing: false, 
 //           purchasePrice: 3000,
 //           productionTime: Random().nextInt(100)+3,
 //           remainingTime: Random().nextInt(100)+3, 
 //           amount: 0,
 //           unlocked: false,
 //         ),
 //         Product(
 //           id: Random().nextInt(1000000000).toString(),
 //           name: 'sand',
 //           productionTime: Random().nextInt(100)+3,
 //           remainingTime: Random().nextInt(100)+3,
 //           purchasePrice: 4000,
 //           startTime: null,
 //           isProducing: false,
 //           amount: 0,
 //           unlocked: false,
 //         ),
 //         // Daha fazla ürün ekleyebilirsiniz
 //       ];  
 //       newProducts =  oldproducts == [] ? newProducts : newProducts.where((product) => !oldproducts.any((oldproduct) => oldproduct.id == product.id)).toList();
 //       for (final product in newProducts) {
 //         await allproducts.doc(product.id).set(product.toJson());
 //       }
 //    // }
 //   } catch (e) {
 //     print('Error adding products to Firestore: $e');
 //   }
 // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 191, 179, 149),
      appBar: AppBar(
            backgroundColor: const Color.fromARGB(218, 13, 72, 161), // Mavi arka plan
            title: const Text('ZELIX KINGDOM', style: TextStyle(color: Colors.white, fontSize: 25, fontStyle: FontStyle.italic,letterSpacing: 5, fontWeight: FontWeight.bold)),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () {
                  _auth.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpScreen()),
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
                backgroundColor: WidgetStatePropertyAll<Color>(const Color.fromARGB(215, 161, 77, 13)),
                shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
                padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                ),
                side: WidgetStatePropertyAll<BorderSide>(BorderSide(color: Colors.grey, width: 2.0)),
                minimumSize: WidgetStatePropertyAll<Size>(Size(MediaQuery.of(context).size.width / 1.2, MediaQuery.of(context).size.height / 10)),
                maximumSize: WidgetStatePropertyAll<Size>(Size(MediaQuery.of(context).size.width / 1.2, MediaQuery.of(context).size.height / 10)),
                alignment: Alignment.center,
              ),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/techtree', (route) => false);
              },
              child: Text('Game', style: GoogleFonts.roboto(
                fontSize: 24.0,
                letterSpacing: 2,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: Colors.white,)),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(const Color.fromARGB(215, 161, 77, 13)),
                shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
                padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                ),
                side: WidgetStatePropertyAll<BorderSide>(BorderSide(color: Colors.grey, width: 2.0)),
                minimumSize: WidgetStatePropertyAll<Size>(Size(MediaQuery.of(context).size.width / 1.2, MediaQuery.of(context).size.height / 10)),
                maximumSize: WidgetStatePropertyAll<Size>(Size(MediaQuery.of(context).size.width / 1.2, MediaQuery.of(context).size.height / 10)),
                alignment: Alignment.center,
              ),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/howtoplay', (route) => false);
              },
              child: Text('How to Play', style: GoogleFonts.roboto(
                fontSize: 24.0,
                letterSpacing: 2,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: Colors.white,)
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(const Color.fromARGB(215, 161, 77, 13)),
                shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
                padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                ),
                side: WidgetStatePropertyAll<BorderSide>(BorderSide(color: Colors.grey, width: 2.0)),
                minimumSize: WidgetStatePropertyAll<Size>(Size(MediaQuery.of(context).size.width / 1.2, MediaQuery.of(context).size.height / 10)),
                maximumSize: WidgetStatePropertyAll<Size>(Size(MediaQuery.of(context).size.width / 1.2, MediaQuery.of(context).size.height / 10)),
                alignment: Alignment.center,
              ),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/options', (route) => false);
              },
              child: Text('Options', style: GoogleFonts.roboto(
                fontSize: 24.0,
                letterSpacing: 2,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                color: Colors.white,))
            ),
          ],
        ),
      ),
    );
  }
}
