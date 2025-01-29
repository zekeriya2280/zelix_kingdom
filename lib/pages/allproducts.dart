import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zelix_kingdom/models/product.dart';
import 'package:vector_math/vector_math_64.dart' as vectorMath;

class Allproducts extends StatefulWidget {
  const Allproducts({super.key});

  @override
  State<Allproducts> createState() => _AllproductsState();
}

class _AllproductsState extends State<Allproducts>
    with TickerProviderStateMixin {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  List<Product> products = []; // Ürünler
  //Map<int, bool> addingProduct = {}; // Ürün ekleme durumu kontrolü
  double userMoney = 0;
  int selectedindex = -1;
  List<Product> unlockedProducts = [];
  //List<Color> cardColors = List.generate(
  //  99,
  //  (index) => const Color.fromARGB(255, 240, 158, 34),
  //);
  CollectionReference<Map<String, dynamic>> productsRef = FirebaseFirestore
      .instance
      .collection('products');

  @override
  void initState() {
    findusermoney();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 20),
    );
    _rotationAnimation = Tween<double>(
      begin: 364,
      end: 365,
    ).animate(_animationController);
    _animationController.forward();
    super.initState();
  }

  Future<double> findusermoneyFB() async {
    try {
      final snapshot =
          await _db
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get();
      if (snapshot.exists) {
        return double.parse((snapshot.data()!)['money'].toString());
      }
    } on FirebaseException catch (e) {
      print('Error fetching user money: $e');
    } catch (e) {
      print('An unexpected error occurred: $e');
    }
    return 0;
  }

  Future<void> findusermoney() async {
    await findusermoneyFB().then((value) {
      if (mounted) {
        setState(() {
          userMoney = value;
        });
      }
    });
  }

  Future<void> addSelectedProductFromAllProductsToUserFBProducts(
    Product product,
  ) async {
    await _db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
          'products.${product.id}': {
            'remainingTime': product.remainingTime,
            'isProducing': product.isProducing,
            'startTime': product.startTime,
            'purchasePrice': product.purchasePrice,
            'id': product.id,
            'name': product.name,
            'productionTime': product.productionTime,
            'productLevel': product.productLevel,
            'amount': product.amount,
            'unlocked': product.unlocked,
          },
        });
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: productsRef.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 1000,
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 1000,
          );
        } else if (snapshot.hasError) {
          return const Text('An error occurred.');
        } else {
          products =
              snapshot.data!.docs
                  .map((doc) => Product.fromJson(doc.data()))
                  .toList();
          unlockedProducts =
              products.where((product) => product.unlocked).toList();
          unlockedProducts.sort((a, b) => a.productLevel.compareTo(b.productLevel));
          //addingProduct = {
          //  for (int i = 0; i < unlockedProducts.length; i++) i: false,
          //};
        }
        return Stack(
          children: [
            Opacity(
              opacity:
                  0.8, // Change this value to adjust the opacity (0.0 to 1.0)
              child: Image(
                image: AssetImage('assets/arkaplan3.jpeg'),
                alignment: Alignment.center,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                leading: Padding(
                  padding: const EdgeInsets.only(left: 1),
                  child: Text(
                    '   Money\n\n  ${userMoney.toStringAsFixed(1)}\$',
                    style: GoogleFonts.lato(color: Colors.white, fontSize: 11),
                  ),
                ),
                title: Text(
                  'Add Products',
                  style: GoogleFonts.lato(color: Colors.white),
                ), // Başlık
                centerTitle: true,
                backgroundColor: const Color.fromARGB(
                  210,
                  13,
                  72,
                  161,
                ), // Mavi arka plan
                actions: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart, color: Colors.white),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/userproducts');
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.account_tree_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/userproducts');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.home, color: Colors.white),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/intro');
                    },
                  ),
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: const Color.fromARGB(
                  210,
                  13,
                  72,
                  161,
                ),
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.industry, color: Colors.white, size: 30),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.truck, color: Colors.white, size: 30),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.city, color: Colors.white, size: 30),
                    label: '',
                  ),
                ],
              ),
              body: SafeArea(
                child: ListView.builder(
                  itemCount: unlockedProducts.length, // Ürün sayısı
                  padding: const EdgeInsets.symmetric(
                    vertical: 100,
                    horizontal: 0,
                  ),
                  itemBuilder: (context, index) {
                    final product = unlockedProducts[index]; // Mevcut ürün
                    return SingleChildScrollView(
                      child: InkWell(
                        onTap:
                            () => showDialog(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: Center(
                                      child: Text(
                                        product.name,
                                        style: GoogleFonts.lato(
                                          color: const Color.fromARGB(
                                            255,
                                            179,
                                            255,
                                            0,
                                          ),
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                          wordSpacing: 1.5,
                                          shadows: const <Shadow>[
                                            Shadow(
                                              offset: Offset(2.0, 2.0),
                                              blurRadius: 3.0,
                                              color: Color.fromARGB(
                                                255,
                                                255,
                                                0,
                                                0,
                                              ),
                                            ),
                                          ],
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
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
                                          'Level:   ${product.productLevel}',
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'Remaining Time:  ${product.remainingTime}',
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'Started At:   ${product.startTime}',
                                        ),
                                        SizedBox(height: 5),
                                        Text('Amount:   ${product.amount}'),
                                        SizedBox(height: 5),
                                        Text(
                                          'Is Producing:  ${product.isProducing}',
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'Purchase Price:  ${product.purchasePrice}',
                                        ),
                                        SizedBox(height: 5),
                                        Text('Unlocked:  ${product.unlocked}'),
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
                                    backgroundColor: const Color.fromARGB(
                                      222,
                                      34,
                                      61,
                                      102,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    titleTextStyle: GoogleFonts.lato(
                                      color: Colors.orange,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    alignment: Alignment.center,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 20,
                                    ),
                                    titlePadding: const EdgeInsets.all(20),
                                    actionsAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    contentTextStyle: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                            ),
                        child: AnimatedBuilder(
                          animation: _rotationAnimation,
                          child: Container(),
                          builder: (context, child) {
                            return TweenAnimationBuilder<double>(
                              tween: Tween(
                                begin: 270,
                                end: _rotationAnimation.value,
                              ),
                              duration: const Duration(milliseconds: 500),
                              builder: (context, double value, child) {
                                return Transform(
                                  alignment: Alignment.centerLeft,
                                  transform:
                                      Matrix4.identity()
                                        ..setEntry(3, 2, 0.001)
                                        ..rotateX(vectorMath.radians(value)),
                                  origin: const Offset(45, 10),
                                  child: Card(
                                    color:
                                        index == selectedindex
                                            ? Colors.green
                                            : const Color.fromARGB(
                                              255,
                                              240,
                                              158,
                                              34,
                                            ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 8,
                                    child: ListTile(
                                      title: Text(
                                        product.name,
                                        style: GoogleFonts.lato(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                          wordSpacing: 1.5,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Time: ${product.productionTime}s \nAmount: ${product.amount} \nPrice: ${product.purchasePrice.toInt()}\$ \nLevel: ${product.productLevel}',
                                        style: GoogleFonts.lato(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                          wordSpacing: 1.5,
                                        ),
                                      ),
                                      trailing: ElevatedButton(
                                        onPressed:
                                            index == selectedindex
                                                ? null
                                                : () async {
                                                  setState(() {
                                                    selectedindex = index;
                                                  });
                                                  Future.delayed(
                                                    const Duration(seconds: 2),
                                                    () {
                                                      setState(() {
                                                        selectedindex = -1;
                                                      });
                                                    },
                                                  );
                                                  await addSelectedProductFromAllProductsToUserFBProducts(
                                                    product,
                                                  );
                                                },
                                        child: const Text('Add'),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
