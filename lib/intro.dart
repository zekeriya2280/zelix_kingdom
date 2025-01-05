import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zelix_kingdom/auth/signup.dart';
//import 'package:zelix_empire/firebase/fbcontroller.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // DEV. RESET ----- Fbcontroller().addProductsToFirestore();
    // DEV. RESET ----- Fbcontroller().deleteRepeatedProducts();
    // DEV. RESET ----- Fbcontroller().firebaseChangeWordsInCollections('products', 'inflation', 'demandindex', <String, int>{});
    // DEV. RESET ----- Fbcontroller().updateRequredMaterialsAsMap();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            backgroundColor: const Color(0xFF0D47A1), // Mavi arka plan
            title: const Text('ZELIX EMPIRE', style: TextStyle(color: Colors.white, fontSize: 25, fontStyle: FontStyle.italic,letterSpacing: 5, fontWeight: FontWeight.bold)),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/allproducts', (route) => false);
              },
              child: const Text('Game'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/howtoplay', (route) => false);
              },
              child: const Text('How to Play'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/options', (route) => false);
              },
              child: const Text('Options'),
            ),
          ],
        ),
      ),
    );
  }
}
