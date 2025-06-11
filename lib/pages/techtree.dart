import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zelix_kingdom/constants/productconstants.dart';
import 'package:zelix_kingdom/models/product.dart';
import 'package:vector_math/vector_math_64.dart' as vectorMath;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math';

class Techtree extends StatefulWidget {
  const Techtree({super.key});

  @override
  State<Techtree> createState() => _TechtreeState();
}

class _TechtreeState extends State<Techtree> with TickerProviderStateMixin {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  bool unlockWhenUnderMaterialsAreUnlocked = false;
  List<Map<Product, bool>> productsRequiredMaterialChecks = [];
  List<Product> products = []; // Ürünler
  //ProductManagement _productManagement = ProductManagement(); // Ürün yönetimi
  double userMoney = 0;
  List<int> productIndexes = [];
  int selectedindex = -1;
  CollectionReference<Map<String, dynamic>> productsRef = FirebaseFirestore
      .instance
      .collection('products');

  @override
  void initState() {
    findusermoney();
    findRequiredMaterialsUnlocked();
    productIndexes = List.generate(99, (index) => -1);
    //_productManagement = ProductManagement();
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

  Future<void> findusermoney() async {
    await findusermoneyFB().then((value) {
      if (mounted) {
        setState(() {
          userMoney = value;
        });
      }
    });
  }

  Future<void> findRequiredMaterialsUnlocked() async {
    await isAllRequiredMaterialsUnlocked().then((value) {
      if (mounted) {
        setState(() {
          productsRequiredMaterialChecks = value;
        });
      }
    });
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

  Future<void> setProductUnlocked(Product product) async {
    await _db.collection('products').doc(product.id).update({'unlocked': true});
  }

  List<Product> findProductsWithLevels(List<Product> prducts, int level) {
    return prducts
        .where((product) => product.productLevel == level + 1)
        .toList();
  }

  Future<void> updateUserMoneyInFirebase(double newMoney) async => await _db
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .update({'money': newMoney})
      .then((value) {
        print('User money updated successfully!');
      })
      .catchError((error) {
        print('Failed to update user money: $error');
      });
  Future<void> updateUserProductsInFirebase(Product product) async {
    await _db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
          'products.${product.id}': ProductConstants()
              .createProductMapOnlyUpdateAll(product),
        });
  }

  Future<List<Map<Product, bool>>> isAllRequiredMaterialsUnlocked() async {
    final products = await _db
        .collection('products')
        .get()
        .then(
          (snapshot) =>
              snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList(),
        );
    return products.map((product) {
      final requiredMaterials = product.requiredMaterials;
      final allUnlocked = requiredMaterials.entries.every(
        (entry) => products.any(
          (p) => p.requiredMaterials.containsKey(entry.key) && !p.unlocked,
        ),
      );
      return {product: allUnlocked};
    }).toList();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: productsRef.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
              color: Colors.white,
              strokeWidth: 10,
            ),
          );
        }
        if (snapshot.hasError) {
          return const Center(child: Text('An error occurred.'));
        }
        products =
            snapshot.data!.docs
                .map((doc) => Product.fromJson(doc.data()))
                .toList();
        productsRequiredMaterialChecks.any(
              (element) => element.values.any((value) => value == false),
            )
            ? print(
              'Some products have required materials that are not unlocked.',
            )
            : print('All products have required materials that are unlocked.');
        return Stack(
          children: [
            Opacity(
              opacity:
                  0.8, // Change this value to adjust the opacity (0.0 to 1.0)
              child: Image(
                image: AssetImage('assets/arkaplan2.jpeg'),
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
                  'Tech Tree',
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
                    icon: const Icon(Icons.list_alt, color: Colors.white),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/allproducts');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.shopping_cart, color: Colors.white),
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
                backgroundColor: const Color.fromARGB(210, 13, 72, 161),
                items: [
                  BottomNavigationBarItem(
                    icon: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/factory');
                      },
                      child: Icon(
                        FontAwesomeIcons.industry,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      FontAwesomeIcons.truck,
                      color: Colors.white,
                      size: 30,
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      FontAwesomeIcons.city,
                      color: Colors.white,
                      size: 30,
                    ),
                    label: '',
                  ),
                ],
              ),
              body: CustomScrollView(
                cacheExtent: 10,
                scrollDirection: Axis.horizontal,
                slivers: [
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: MediaQuery.of(context).size.width / 1.2,
                      crossAxisCount: 1, // Number of columns
                      mainAxisSpacing: 10, // Spacing between rows
                      crossAxisSpacing: 10, // Spacing between columns
                    ),
                    delegate: SliverChildBuilderDelegate(childCount: 5, (
                      context,
                      levelindex,
                    ) {
                      final List<Product> productslevellist =
                          findProductsWithLevels(products, levelindex);
                      return Stack(
                        children: [
                          Center(
                            heightFactor: 1,
                            child: Opacity(
                              opacity: 1,
                              child: Text(
                                'Level ${levelindex + 1}',
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                  wordSpacing: 1.5,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            color: Color.fromARGB(
                              110,
                              Random().nextInt(255),
                              Random().nextInt(255),
                              Random().nextInt(255),
                            ),
                            child: ListView.builder(
                              itemCount:
                                  productslevellist.length, // Ürün sayısı
                              padding: const EdgeInsets.symmetric(
                                vertical: 100,
                                horizontal: 0,
                              ),
                              itemBuilder: (context, index) {
                                final product =
                                    productslevellist[index]; // Mevcut ürün

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
                                                      color:
                                                          const Color.fromARGB(
                                                            255,
                                                            179,
                                                            255,
                                                            0,
                                                          ),
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 1.5,
                                                      wordSpacing: 1.5,
                                                      shadows: const <Shadow>[
                                                        Shadow(
                                                          offset: Offset(
                                                            2.0,
                                                            2.0,
                                                          ),
                                                          blurRadius: 3.0,
                                                          color: Color.fromARGB(
                                                            255,
                                                            255,
                                                            0,
                                                            0,
                                                          ),
                                                        ),
                                                      ],
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                  ),
                                                ),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Text(
                                                      'Name:  ${product.name}',
                                                    ),
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
                                                    Text(
                                                      'Amount:   ${product.amount}',
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      'Is Producing:  ${product.isProducing}',
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      'Price:   ${product.purchasePrice}',
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      'Required Materials:   ${product.requiredMaterials}',
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      'Unlocked:   ${product.unlocked}',
                                                    ),
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                        ),
                                                  ),
                                                ],
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                      210,
                                                      62,
                                                      96,
                                                      146,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                titleTextStyle:
                                                    GoogleFonts.lato(
                                                      color: Colors.orange,
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                alignment: Alignment.center,
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 20,
                                                    ),
                                                titlePadding:
                                                    const EdgeInsets.all(20),
                                                actionsAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                contentTextStyle:
                                                    GoogleFonts.lato(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                          duration: const Duration(
                                            milliseconds: 500,
                                          ),
                                          builder: (
                                            context,
                                            double value,
                                            child,
                                          ) {
                                            return Transform(
                                              alignment: Alignment.centerLeft,
                                              transform:
                                                  Matrix4.identity()
                                                    ..setEntry(3, 2, 0.001)
                                                    ..rotateX(
                                                      vectorMath.radians(value),
                                                    ),
                                              origin: const Offset(45, 10),
                                              child: Card(
                                                color:
                                                    selectedindex != -1
                                                        ? Colors.green
                                                        : const Color.fromARGB(
                                                          255,
                                                          240,
                                                          158,
                                                          34,
                                                        ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                elevation: 8,
                                                child: ListTile(
                                                  title: Text(
                                                    product.name,
                                                    style: GoogleFonts.lato(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 1.5,
                                                      wordSpacing: 1.5,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    'ProductionTime: ${product.productionTime}s \nPrice: ${product.purchasePrice.toInt()}\$ \nLevel: ${product.productLevel}',
                                                    style: GoogleFonts.lato(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 1.5,
                                                      wordSpacing: 1.5,
                                                    ),
                                                  ),
                                                  trailing:
                                                      product.unlocked == true
                                                          ? Padding(
                                                            padding:
                                                                const EdgeInsets.only(
                                                                  right: 18.0,
                                                                ),
                                                            child: const Icon(
                                                              Icons.lock_open,
                                                              color:
                                                                  Colors.white,
                                                              size: 30,
                                                            ),
                                                          )
                                                          : ElevatedButton(
                                                            style: ButtonStyle(
                                                              backgroundColor:
                                                                  (userMoney <
                                                                              product.purchasePrice ||
                                                                          productsRequiredMaterialChecks.any(
                                                                            (
                                                                              element,
                                                                            ) => element.values.any(
                                                                              (
                                                                                value,
                                                                              ) =>
                                                                                  value ==
                                                                                  false,
                                                                            ),
                                                                          ))
                                                                      ? WidgetStatePropertyAll<
                                                                        Color
                                                                      >(
                                                                        Colors
                                                                            .grey,
                                                                      )
                                                                      : WidgetStatePropertyAll<
                                                                        Color
                                                                      >(
                                                                        Colors
                                                                            .white,
                                                                      ),
                                                            ),
                                                            onPressed:
                                                                (userMoney <
                                                                            product.purchasePrice ||
                                                                        productsRequiredMaterialChecks.any(
                                                                          (
                                                                            element,
                                                                          ) => element.values.any(
                                                                            (
                                                                              value,
                                                                            ) =>
                                                                                value ==
                                                                                false,
                                                                          ),
                                                                        ))
                                                                    ? null
                                                                    : () async {
                                                                      print(
                                                                        'starting selected $selectedindex',
                                                                      );
                                                                      setState(() {
                                                                        selectedindex =
                                                                            index;
                                                                        // times[index] = DateTime.now();
                                                                      });
                                                                      await Future.delayed(
                                                                        const Duration(
                                                                          milliseconds:
                                                                              1000,
                                                                        ),
                                                                        () async {
                                                                          setState(() {
                                                                            selectedindex =
                                                                                -1;
                                                                          });
                                                                          await setProductUnlocked(
                                                                            product,
                                                                          );
                                                                          await updateUserMoneyInFirebase(
                                                                            userMoney -
                                                                                product.purchasePrice,
                                                                          );
                                                                          await findusermoney();
                                                                          await updateUserProductsInFirebase(
                                                                            product,
                                                                          );
                                                                        },
                                                                      );
                                                                      print(
                                                                        'finished selected $selectedindex',
                                                                      );
                                                                    },
                                                            child:
                                                                selectedindex ==
                                                                        index
                                                                    ? const CircularProgressIndicator()
                                                                    : Text(
                                                                      'Unlock',
                                                                      style:
                                                                          userMoney <
                                                                                  product.purchasePrice
                                                                              ? TextStyle(
                                                                                color:
                                                                                    Colors.purple,
                                                                                fontSize:
                                                                                    15,
                                                                                fontWeight:
                                                                                    FontWeight.w400,
                                                                                letterSpacing:
                                                                                    1.5,
                                                                              )
                                                                              : TextStyle(
                                                                                color:
                                                                                    Colors.black,
                                                                                fontSize:
                                                                                    15,
                                                                                fontWeight:
                                                                                    FontWeight.w400,
                                                                                letterSpacing:
                                                                                    1.5,
                                                                              ),
                                                                    ),
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
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
