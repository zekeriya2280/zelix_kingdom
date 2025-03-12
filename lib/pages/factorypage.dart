import 'dart:async'; // Stream için gerekli
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'; // Flutter UI bileşen
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zelix_kingdom/constants/productconstants.dart';
import 'package:zelix_kingdom/models/product.dart'; // Ürün modeli
import 'package:google_fonts/google_fonts.dart'; // Özel fontlar
import 'package:intl/intl.dart'; // Date formatting

class FactoryPage extends StatefulWidget {
  const FactoryPage({super.key});

  @override
  FactoryPageState createState() => FactoryPageState();
}

class FactoryPageState extends State<FactoryPage>
    with TickerProviderStateMixin {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Timer? _timer; // Zamanlayıcı
  List<Product> products = []; // Ürünler
  CollectionReference<Map<String, dynamic>> users = FirebaseFirestore.instance
      .collection('users');
  double userMoney = 0.0;
  Map<Product, bool> ismoneyEnough = {};
  NavigatorState? _navigator;

  @override
  void initState() {
    findusermoneyAndUserproducts();
    super.initState();
  }
  bool hasEnoughMaterials(Product product) {
    if (product.requiredMaterials.isEmpty) return true;
    for (var entry in product.requiredMaterials.entries) {
      String materialId = entry.key;
      int requiredAmount = entry.value;
      
      Product? material = products.firstWhere(
        (p) => p.id == materialId
      );
      
      if (material.amount < requiredAmount) return false;
    }
    return true;
  }
  void startProduction(Product product) async {
  for (var entry in product.requiredMaterials.entries) {
    String materialId = entry.key;
    int requiredAmount = entry.value;
    
    Product material = products.firstWhere((p) => p.id == materialId);
    setState(() => material.amount -= requiredAmount);
    await updateUserProductsInFirebase(material);
  }
}

  Future<void> findusermoneyAndUserproducts() async {
    // Retrieve the user's document snapshot from Firestore
    final snapshot = await users.doc(FirebaseAuth.instance.currentUser!.uid).get();
    
    // Update the state with the user's products and money information
    setState(() {
      // Extract the 'products' field from the document data
      final temp1 = (snapshot.data()!)['products'];
      
      // Cast the extracted data to a Map<String, dynamic>
      final temp2 = temp1 as Map<String, dynamic>;
      
      // Convert the map entries to Product objects and store them in a list
      products = temp2.map((key, value) => MapEntry(key, Product.fromJson(value)))
                      .values
                      .toList();
      
      // Sort the products list based on the product level
      products.sort((a, b) => a.productLevel.compareTo(b.productLevel));
      
      // Filter out products with an amount of 0
      products = products.where((product) => product.amount > 0).toList();
      print(products.map((product) => product.name));
    });

    // Check if the snapshot exists before accessing its data
    if (!snapshot.exists) {
      return; // Exit the function early if the snapshot does not exist
    }

    // Update the state with the user's money information
    setState(() {
      // Parse the 'money' field from the document data as a double
      userMoney = double.parse((snapshot.data()!)['money'].toString());
    });

    // Initialize a map to track if the user has enough money for each product
    ismoneyEnough = <Product, bool>{};
    
    // Iterate over each product and determine if the user has enough money
    for (var product in products) {
      setState(() {
        // Check if the user has enough money for the current product
        ismoneyEnough[product] = product.isMoneyEnough(userMoney);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _navigator = Navigator.of(context);
  }

  /// Updates a product in the user's document in the Firestore 'users' collection.
  ///
  /// Updates the product with the given [Product] object and updates the
  /// 'products' map in the user's document with the given product.
  Future<void> updateUserProductsInFirebase(Product product) async {
    await _db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
          'products.${product.id}': ProductConstants()
              .createProductMapOnlyUpdateAll(product),
        });
  }

  /// Updates the user's money in the Firestore 'users' collection.
  ///
  /// Takes a [double] value [money] and updates the 'money' field in the
  /// user's document with the given amount.
  ///
  /// This function assumes that a user is currently authenticated and
  /// their UID is accessible through FirebaseAuth.

  Future<void> updateUserMoneyInFirebase(double money) async {
    await _db
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'money': money});
  }

  /// Syncs the given [product] to the user's document in the Firestore 'users'
  /// collection and increases the product's amount by 1.
  ///
  /// This function assumes that a user is currently authenticated and
  /// their UID is accessible through FirebaseAuth.
  ///
  /// The updated product is saved to the 'products' map in the user's document
  /// with the given product's ID as the key.
  ///
  /// This function returns a [Future] that resolves when the document has been
  /// updated in the Firestore.
  Future<void> syncProductsToUserFirebaseAndIncreaseAmount(
    Product product,
  ) async {
    assert(product == null, 'Product cannot be null');
    assert(
      FirebaseAuth.instance.currentUser != null,
      'User must be authenticated to sync products to Firebase',
    );
    try {
      await _db
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
            'products.${product.id}': ProductConstants()
                .createProductMapChangingIsProducingStartTimeAmountRemainingTime(
                  product,
                ),
          });
    } on FirebaseException catch (e) {
      print('Error syncing products to Firebase: $e');
      rethrow;
    } catch (e) {
      print('An unexpected error occurred: $e');
      rethrow;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: users.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 1000,
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 1000,
            ),
          );
        }
        if (snapshot.hasError) {
          return const Center(child: Text('An error occurred.'));
        }
        return Stack(
          children: [
            Opacity(
              opacity:
                  0.8, // Change this value to adjust the opacity (0.0 to 1.0)
              child: Image(
                image: AssetImage('assets/arkaplan4.jpeg'),
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
                  'Factory',
                  style: GoogleFonts.lato(color: Colors.white),
                ), // Başlık
                centerTitle: true,
                backgroundColor: const Color.fromARGB(
                  216,
                  13,
                  72,
                  161,
                ), // Mavi arka plan
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: IconButton(onPressed: () {}, 
                    icon: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/allproducts');
                        },
                        child: Icon(
                          FontAwesomeIcons.bookBookmark,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: IconButton(
                      icon: const Icon(Icons.home, color: Colors.white, size: 30),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/intro');
                      },
                    ),
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
                    icon: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/userproducts');
                      },
                      child: Icon(
                        FontAwesomeIcons.shop,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
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
              body: ListView.builder(
                padding: const EdgeInsets.all(4.0),
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
                                  title: Center(
                                    child: Text(
                                      product.name,
                                      style: GoogleFonts.lato(
                                        fontFeatures: const [
                                          FontFeature.enable('smcp'),
                                        ],
                                        color: const Color.fromARGB(
                                          255,
                                          246,
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
                                      Text('Level:   ${product.productLevel}'),
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
                                        'Purchase Price:   ${product.purchasePrice}',
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Required Materials:   ${product.requiredMaterials}',
                                      ),
                                      SizedBox(height: 5),
                                      Text('Unlocked:   ${product.unlocked}'),
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
                                    215,
                                    34,
                                    61,
                                    102,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  titleTextStyle: GoogleFonts.lato(
                                    color: const Color.fromARGB(
                                      255,
                                      255,
                                      247,
                                      0,
                                    ),
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
                      child: Card(
                        margin: const EdgeInsets.all(8.0),
                        color: cardColor,
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
                          subtitle:
                              product.isProducing
                                  ? Text(
                                    'Producing... ${product.remainingTime} Started at: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(product.startTime!)}',
                                    style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                      wordSpacing: 1.5,
                                    ),
                                  )
                                  : Text(
                                    'Time: ${product.productionTime}s \nAmount: ${product.amount} \nPrice: ${product.purchasePrice.toInt()}\$ \nLevel: ${product.productLevel}',
                                    overflow: TextOverflow.clip,
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
                                    icon: const Icon(
                                      Icons.cancel,
                                    ), // İptal butonu
                                    onPressed: () async {
                                      setState(() {
                                        product.isProducing = false;
                                        product.startTime = null;
                                        product.remainingTime = 999;
                                        _timer?.cancel();
                                      });
                                      await updateUserProductsInFirebase(
                                        product,
                                      );
                                    },
                                  )
                                  : ElevatedButton(
                                    onPressed:
                                        products.any((p) => p.isProducing) ||
                                                !ismoneyEnough[product]!
                                                || !hasEnoughMaterials(product)
                                            ? null
                                            : () async {
                                              if (mounted) {
                                                setState(() {
                                                  product.isProducing = true;
                                                  product.startTime =
                                                      DateTime.now();
                                                  product.remainingTime =
                                                      product.productionTime;
                                                });
                                                setState(() {
                                                  _timer = Timer.periodic(
                                                    const Duration(seconds: 1),
                                                    (timer) async {
                                                      setState(() {
                                                        product.remainingTime -=
                                                            1;
                                                        if (product
                                                                .remainingTime <=
                                                            0) {
                                                          timer.cancel();
                                                          _timer = null;
                                                          _timer?.cancel();
                                                        }
                                                      });
                                                      if (product
                                                              .remainingTime <=
                                                          0) {
                                                        setState(() {
                                                          product.isProducing =
                                                              false;
                                                          product.startTime =
                                                              null;
                                                          userMoney -=
                                                              product
                                                                  .purchasePrice;
                                                        });
                                                        await syncProductsToUserFirebaseAndIncreaseAmount(
                                                          product,
                                                        );
                                                        await updateUserMoneyInFirebase(
                                                          userMoney,
                                                        );
                                                        if (_navigator !=
                                                            null) {
                                                          _navigator!
                                                              .pushReplacementNamed(
                                                                '/userproducts',
                                                              );
                                                        }
                                                      } else {
                                                        await updateUserProductsInFirebase(
                                                          product,
                                                        );
                                                      }
                                                    },
                                                  );
                                                });
                                              } else {
                                                setState(() {
                                                  _timer?.cancel();
                                                });
                                              }
                                            },
                                    child: const Text('Use'),
                                  ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
