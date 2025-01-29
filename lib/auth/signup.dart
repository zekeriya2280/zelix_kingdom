import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zelix_kingdom/constants/userconstants.dart';
import 'package:zelix_kingdom/models/city.dart';
import 'package:zelix_kingdom/models/factory.dart';
import 'package:zelix_kingdom/models/product.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signUp() async {
    try {
      if (emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          nicknameController.text.isNotEmpty) {
        await _auth
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .then((UserCredential result) async {
          final user = result.user;
          if (user != null) {
            await user.updateDisplayName(nicknameController.text);
            await signUpToFirebaseUsers(
                user.uid, nicknameController.text, emailController.text, {}, {}, {});
            if (mounted) {
              Navigator.pushNamed(context, '/intro');
            }
          } else {
            throw Exception('Failed to create user.');
          }
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("E-mail ve sifrenizi kontrol ediniz."),
          ));
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("sifre zayıf"),
          ));
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Bu e-mail adresi kullanımda."),
          ));
        }
      }
    } catch (e) {
      print('An unexpected error occurred: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Bir hata oluştu."),
        ));
      }
    }
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
      final userData = Userconstants().createUserFirstInfos(id, nickname, email, factories, products, cities);
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D47A1), // Mavi arka plan
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nicknameController,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                labelText: 'Nickname',
                hintText: 'Enter your nickname',
                hintStyle: const TextStyle(color: Color.fromARGB(146, 255, 255, 255)),
                labelStyle: const TextStyle(color: Colors.white),
                prefixIcon: const Icon(Icons.person, color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                hintStyle: const TextStyle(color: Color.fromARGB(146, 255, 255, 255)),
                labelStyle: const TextStyle(color: Colors.white),
                prefixIcon: const Icon(Icons.email, color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              cursorColor: Colors.white,
              controller: passwordController,
              style: const TextStyle(color: Colors.white),
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                hintStyle: const TextStyle(color: Color.fromARGB(146, 255, 255, 255)),
                labelStyle: const TextStyle(color: Colors.white),
                prefixIcon: const Icon(Icons.lock, color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: signUp,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: const Text('Sign Up'),
            ),
            TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpScreen()),
                    );
                  },
                  child: const Text("Already have an account?     Login", style: TextStyle(color: Colors.orange,fontSize: 18, fontWeight: FontWeight.bold),),
                ),
          ],
        ),
      ),
    );
  }
}
