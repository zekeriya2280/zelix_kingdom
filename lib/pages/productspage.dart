import 'dart:async'; // Stream için gerekli
import 'package:flutter/material.dart'; // Flutter UI bileşenleri
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zelix_kingdom/managements/hivestream.dart';
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
  HiveStream<Product>? _hiveStream;
  ProductManagement _productManagement = ProductManagement(); // Ürün yönetimi
  Timer? _timer; // Zamanlayıcı
  List<Product> products = []; // Ürünler

  @override
  void initState() {
    super.initState();
    _hiveStream = HiveStream<Product>(
      Hive.box<Product>('products'),
    ); // Create the HiveStream instance only once
    _startTimer(); // Zamanlayıcıyı başlat
    _deleteSameProductsFromHive(); // Aynı ürünleri sil
    _startTimer(); // Zamanlayıcıyı başlat
    _productManagement = ProductManagement(); // Ürün yönetimini başlat
    _initializeHive().then((box) {
      products = _productManagement.getProductsFromHive();
      setState(() {});
    }); // Ürünleri baslat); // Hive ve stream'i başlat
  }

  Future<void> _deleteSameProductsFromHive() async {
    print('Deleting same products from Hive...');

    try {
      final box = Hive.box<Product>('products');
      if (box.isOpen) {
        print('Box is open.');

        final keys = box.keys.toList();
        print('Keys: ${keys[0].runtimeType}');
        final Set<dynamic> seenKeys = {};
        final List<dynamic> duplicateKeys = [];

        for (final key in keys) {
          if (!seenKeys.add(key) ||
              key.toString() == 'null' ||
              key.toString() == '0') {
            duplicateKeys.add(key);
          }
        }

        if (duplicateKeys.isNotEmpty) {
          print('Deleting ${duplicateKeys.length} duplicate keys...');
          await box.deleteAll(duplicateKeys);
          print('Deleted ${duplicateKeys.length} duplicate keys.');
        } else {
          print('No duplicate keys found.');
        }
      } else {
        print('Box is not open.');
      }
    } catch (e) {
      print('Error deleting same products: $e');
    }
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
        } else if (newRemainingTimes.any((time) => time.values.first <= 0)) {
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
            if (time.values.first <= 0) {
              
              await ProductManagement().syncProductToFirebase(
                products.firstWhere(
                  (product) => product.id == time.keys.first.id,
                ),
              );
            }
          });
        }
        // products =
        //     products.map((product) {
        //       int index = products.indexOf(product);
        //       //product.remainingTime = newRemainingTimes[index];
        //       return product;
        //     }).toList();
        // print('Remaining times: ');
        //for (var time in newRemainingTimes) {
        //  print('Product: ${time.keys.first.name}');
        //  print('Remaining time: ${time.values.first}');

        //}
        //for (var product in products) {
        //  print('Products: ${product.name} - ${product.remainingTime} - ${product.isProducing} - ${product.startTime} - ${product.productionTime}');
        //}

        // Log remaining times
        final box = Hive.box<Product>('products');
        box.putAll(
          products
              .asMap()
              .map((index, product) {
                if (!box.containsKey(product.id)) {
                  return MapEntry(product.id, product);
                } else {
                  return MapEntry(
                    product.id,
                    null,
                  ); // Return a MapEntry with a null value
                }
              })
              .entries
              .where((entry) => entry.value != null)
              .map((entry) => MapEntry(entry.key, entry.value))
              .toList()
              .asMap()
              .map((index, entry) {
                return MapEntry(entry.key, products[index]);
              }),
        );
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

  Future<Box<Product>> _initializeHive() async {
    await _productManagement.initHive(); // Hive'ı başlat
    await _productManagement
        .fetchProductsFromFirebase(); // Firebase'den ürünleri çek
    if (Hive.isBoxOpen('products')) {
      await Hive.box<Product>('products').close(); // Ürün kutusunu temizle
    }
    await Hive.openBox<Product>('products'); // Ürün kutusunu aç
    final productBox = Hive.box<Product>('products'); // Ürün kutusunu al
    _hiveStream = HiveStream(productBox); // HiveStream oluştur
    return productBox;
  }

  @override
  void dispose() {
    _hiveStream!.dispose(); // Stream'i temizle
    Hive.box<Product>('products').close(); // Ürün kutusunu kapat
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _startProduction(Product product) async {
    // TODO: Implement checks before starting production
    product.isProducing = true;
    product.startTime = DateTime.now();
    await _productManagement.updateProductInHive(product);
  }

  Future<void> _cancelProduction(Product product) async {
    product.isProducing = false; // Üretimi iptal et
    product.startTime = null; // Başlama zamanını temizle
    await _productManagement.updateProductInHive(product); // Hive güncelle
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Production', style: GoogleFonts.lato()), // Başlık
      ),
      body: StreamBuilder<List<Product>>(
        // Hive Stream'i dinle
        stream: _hiveStream!.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            ); // Yükleniyor gösterimi
          }

          final products = snapshot.data!; // Ürün verileri

          return ListView.builder(
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
                            onPressed: () => _cancelProduction(product),
                          )
                          : ElevatedButton(
                            onPressed:
                                () => _startProduction(
                                  product,
                                ).then((_) => setState(() {})), // Başlat butonu
                            child: const Text('Start'),
                          ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
