import 'package:flutter/material.dart';
import 'package:zelix_kingdom/auth/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:zelix_kingdom/auth/signup.dart';
import 'package:zelix_kingdom/intro.dart';
import 'package:zelix_kingdom/pages/allproducts.dart';
import 'package:zelix_kingdom/pages/userproductspage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
   options: const FirebaseOptions(
     apiKey: "AIzaSyAkzavil1xPqgpaqSJaZwPQuRRmuxSCQCg",
     appId: "1:852386245715:android:64fd47c891cb5f2a796aa6",
     messagingSenderId: "852386245715",
     projectId: "zelix-kingdom",
   ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/intro': (context) => const IntroScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/userproducts': (context) => const ProductionPage(),
        '/allproducts': (context) => const Allproducts()
      },
    );
  }
}
