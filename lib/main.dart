import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:zelix_kingdom/auth/login.dart';
import 'package:zelix_kingdom/auth/signup.dart';
import 'package:zelix_kingdom/intro.dart';
import 'package:zelix_kingdom/pages/allproducts.dart';
import 'package:zelix_kingdom/pages/techtree.dart';
import 'package:zelix_kingdom/pages/userproductspage.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAkzavil1xPqgpaqSJaZwPQuRRmuxSCQCg",
      appId: "1:852386245715:android:64fd47c891cb5f2a796aa6",
      messagingSenderId: "852386245715",
      projectId: "zelix-kingdom",
      storageBucket: "zelix-kingdom.firebasestorage.app"
    )
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: LoginScreen(),
        routes: {
          '/login': (context) => LoginScreen(),
          '/intro': (context) => const IntroScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/userproducts': (context) => const ProductionPage(),
          '/allproducts': (context) => Allproducts(),
          '/techtree': (context) => Techtree(),
        },
      );
    
  }
}