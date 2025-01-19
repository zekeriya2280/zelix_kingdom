import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:zelix_kingdom/managements/productmanagements.dart';
import 'package:zelix_kingdom/models/product.dart';
import 'package:vector_math/vector_math_64.dart' as vectorMath;
import 'package:zelix_kingdom/providers/productsprovider.dart';

class Allproducts extends StatefulWidget {
  const Allproducts({super.key});

  @override
  State<Allproducts> createState() => _AllproductsState();
}

class _AllproductsState extends State<Allproducts>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  List<Product> products = []; // Ürünler
  ProductManagement _productManagement = ProductManagement(); // Ürün yönetimi
  Map<int, bool> addingProduct = {}; // Ürün ekleme durumu kontrolü
  double userMoney = 0;
  List<Product> unlockedProducts = [];
  List<Color> cardColors = List.generate(
    99,
    (index) => const Color.fromARGB(255, 240, 158, 34),
  );

  @override
  void initState() {
    findusermoney();
    //setBreakingFindUnlockedProducts();
    _productManagement = ProductManagement();
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
  @override
void didChangeDependencies() {
  super.didChangeDependencies();
  setBreakingFindUnlockedProducts();
}

  void setBreakingFindUnlockedProducts() {
     products = Provider.of<ProductProvider>(context).products;
    unlockedProducts = products.where((product) => product.unlocked).toList();
    addingProduct = {
      for (int i = 0; i < unlockedProducts.length; i++) i: false,
    };
    print('addingProduct: $addingProduct');
  }

 Future<void> findusermoney() async {
  await _productManagement.findusermoney().then(
    (value) {
      if (mounted) {
        setState(() {
          userMoney = value;
        });
      }
    },
  );
}

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
       
      cardColors = List.generate(
        unlockedProducts.length,
        (index) => const Color.fromARGB(255, 240, 158, 34),
      );
      addingProduct.forEach((index, value) {
        //print('Index: ${addingProduct[index]}');
        if (addingProduct[index] == true) {
          cardColors[index] = Colors.green;
        } else {
          cardColors[index] = const Color.fromARGB(255, 240, 158, 34);
        }
      });

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 190, 198, 203),
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
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/intro');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: unlockedProducts.length, // Ürün sayısı
          padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 0),
          itemBuilder: (context, index) {
            final product = unlockedProducts[index]; // Mevcut ürün
            //addingProduct = {for (int i = 0; i < products.length; i++) i: false};
        
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
                                  color: const Color.fromARGB(255, 179, 255, 0),
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('Name:  ${product.name}'),
                                SizedBox(height: 5),
                                Text('ID:  ${product.id}'),
                                SizedBox(height: 5),
                                Text(
                                  'Production Time:   ${product.productionTime}',
                                ),
                                SizedBox(height: 5),
                                Text('Remaining Time:  ${product.remainingTime}'),
                                SizedBox(height: 5),
                                Text('Started At:   ${product.startTime}'),
                                SizedBox(height: 5),
                                Text('Amount:   ${product.amount}'),
                                SizedBox(height: 5),
                                Text('Is Producing:  ${product.isProducing}'),
                                SizedBox(height: 5),
                                Text('Purchase Price:  ${product.purchasePrice}'),
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
                            actionsAlignment: MainAxisAlignment.spaceBetween,
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
                      tween: Tween(begin: 270, end: _rotationAnimation.value),
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
                            color: addingProduct[index] == true
                                ? Colors.green
                                : cardColors[index],
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
                                'Time: ${product.productionTime}s, Amount: ${product.amount}, Price: ${product.purchasePrice.toInt()}\$',
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
                                    addingProduct[index] == true
                                        ? null
                                        : () async {
                                          setState(() {
                                            addingProduct[index] = true;
                                          });
                                          Future.delayed(
                                            const Duration(seconds: 2),
                                            () {
                                              setState(() {
                                                addingProduct[index] = false;
                                              });
                                            },
                                          );
                                          print('addingProduct: $addingProduct');
                                          
                                          await _productManagement
                                              .addSelectedProductFromAllProductsToUserFBProducts(
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
    );
  }
}
