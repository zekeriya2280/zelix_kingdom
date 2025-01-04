import 'dart:async'; // Stream için gerekli
import 'package:flutter/material.dart'; // Flutter UI bileşen
import 'package:zelix_kingdom/managements/productmanagements.dart'; // Ürün yönetimi
import 'package:zelix_kingdom/models/product.dart'; // Ürün modeli
import 'package:google_fonts/google_fonts.dart'; // Özel fontlar

class ProductionPage extends StatefulWidget {
  // Üretim sayfası
  const ProductionPage({super.key});

  @override
  ProductionPageState createState() => ProductionPageState();
}

class ProductionPageState extends State<ProductionPage> {
  ProductManagement _productManagement = ProductManagement(); // Ürün yönetimi
  Timer? _timer; // Zamanlayıcı
  List<Product> products = []; // Ürünler

  @override
  void initState() {
    super.initState();// Create the HiveStream instance only once
    _startTimer(); // Zamanlayıcıyı başlat
    _startTimer(); // Zamanlayıcıyı başlat
    _productManagement = ProductManagement(); // Ürün yönetimini başlat
  }

  Future<void> _startTimer() async {
    List<Map<Product, int>> newRemainingTimes = [];
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (products.isEmpty) {
        return;
      } else {
        for (var i = 0; i < products.length; i++) {
          int remainingTime = _calculateRemainingTime(products[i]);
          newRemainingTimes.add({products[i]: remainingTime});
          if (remainingTime <= 0) {
            products[i].isProducing = false;
            products[i].startTime = null;
          }
        }
        if (newRemainingTimes.every((time) => time.values.first <= 0)) {
          _timer?.cancel();
        } else if (newRemainingTimes.any((time) => time.values.first > 0)) {
          newRemainingTimes =
              newRemainingTimes.map((time) {
                if (time.values.first <= 0) {
                  return {time.keys.first: 0};
                } else {
                  return time;
                }
              }).toList();
          await Future.forEach(newRemainingTimes, (time) async {
           print('Syncing product to Firebase...${time.values.first}');
           if (time.values.first <= 0 && time.keys.first.productionTime > 0 ) {
             
             await ProductManagement().syncProductToUserFirebase(
               products.firstWhere(
                 (product) => product.name == time.keys.first.name,
               ),
             );
           }
         });
          
        }
        setState(() {}); // Update the state here
      }
    });
   
  }

  int _calculateRemainingTime(Product product) {
    if (product.startTime == null) {
      return product.productionTime;
    }
    return product.remainingTime;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Production', style: GoogleFonts.lato()), // Başlık
      ),
      body: ListView.builder(
            itemCount: products.length, // Ürün sayısı
            itemBuilder: (context, index) {
              final product = products[index]; // Mevcut ürün
              final cardColor =
                  product.isProducing
                      ? Colors.yellow
                      : Colors.red; // Kart rengi

              return Card(
                color: cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 8,
                child: ListTile(
                  title: Text(product.name, style: GoogleFonts.lato()),
                  subtitle:
                      product.isProducing
                          ? Text(
                            'Producing... ${product.remainingTime} Started at: ${product.startTime}',
                            style: GoogleFonts.lato(),
                          )
                          : Text(
                            'Not producing...' '${product.remainingTime}',
                            style: GoogleFonts.lato(),
                          ),
                  trailing:
                      product.isProducing
                          ? IconButton(
                            icon: const Icon(Icons.cancel), // İptal butonu
                            onPressed: () => setState(() {
                              product.isProducing = false;
                              product.startTime = null;
                            }),
                          )
                          : ElevatedButton(
                            onPressed:
                                  () => setState(() {
                                    product.isProducing = true;
                                    product.startTime = DateTime.now();
                                  }),
                            child: const Text('Start'),
                          ),
                ),
              );
            },
          ),
    );
  }
}
