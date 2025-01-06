import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zelix_kingdom/managements/productmanagements.dart';
import 'package:zelix_kingdom/models/product.dart';

class Allproducts extends StatefulWidget {
  const Allproducts({super.key});

  @override
  State<Allproducts> createState() => _AllproductsState();
}

class _AllproductsState extends State<Allproducts> {
  CollectionReference allproducts = FirebaseFirestore.instance.collection(
    'products',
  );
  List<Product> products = []; // Ürünler
  ProductManagement _productManagement = ProductManagement(); // Ürün yönetimi
  Map<int, bool> addingProduct = {}; // Ürün ekleme durumu kontrolü

  @override
  void initState() {
    //addProductsToFirestore(); // Ürünleri products a ekler // RESET
    addingProduct = {for (int i = 0; i < products.length; i++) i: false};
    _productManagement = ProductManagement();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Object?>>(
      stream: allproducts.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
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
        products =
            snapshot.data!.docs
                .map(
                  (doc) => Product.fromJson(doc.data() as Map<String, dynamic>),
                )
                .toList();
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 190, 198, 203),
          appBar: AppBar(
            title: Text(
              'Production',
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
                icon: const Icon(Icons.home, color: Colors.white),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/intro');
                },
              ),
            ],
          ),
          body: ListView.builder(
            itemCount: products.length, // Ürün sayısı
            padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 0),
            itemBuilder: (context, index) {
              List<Color> cardColors = List.generate(
                products.length,
                (index) => const Color.fromARGB(255, 240, 158, 34),
              );
              final product = products[index]; // Mevcut ürün
              //addingProduct = { for (int i = 0; i < products.length; i++) i: false };

              // cardColors.map((color) {
              //print('Adding Product: ${addingProduct}');
              addingProduct.forEach((index, value) {
                //print('Index: ${addingProduct[index]}');
                if (addingProduct[index] == true) {
                  cardColors[index] = Colors.green;
                } else {
                  cardColors[index] = const Color.fromARGB(255, 240, 158, 34);
                }
              });
              // }).toList();

            // print(
            //   'Card Color: ${cardColors.map((e) => e.toARGB32()).toList()}',
            // );
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
                                        color: Color.fromARGB(255, 255, 0, 0),
                                      ),
                                    ],
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                        color: cardColors[index],
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
                            'Production Time: ${product.productionTime}',
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              wordSpacing: 1.5,
                            ),
                          ),
                          trailing: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                addingProduct[index] = true;
                              });
                              Future.delayed(const Duration(seconds: 3), () {
                                setState(() {
                                  addingProduct.forEach(
                                    (key, value) => addingProduct[key] = false,
                                  );
                                });
                              });
                              await _productManagement
                                  .addSelectedProductFromAllProductsToUserFBProducts(
                                    product,
                                  );
                            },
                            child: const Text('Add'),
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
