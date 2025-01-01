import 'dart:async'; // Stream için gerekli
import 'package:flutter/material.dart'; // Flutter UI bileşenleri
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zelix_kingdom/managements/productmanagements.dart'; // Ürün yönetimi
import 'package:zelix_kingdom/models/product.dart'; // Ürün modeli
import 'package:google_fonts/google_fonts.dart'; // Özel fontlar

class HiveStream<T> {
  // Hive'dan bir Stream türetmek için yardımcı sınıf
  final Box<T> box; // Hive kutusu referansı
  late final StreamController<List<T>> _controller; // Stream kontrolcüsü

  HiveStream(this.box) {
    _controller = StreamController<List<T>>.broadcast(
      onListen: () => _emitInitialData(), // İlk veriyi yay
      onCancel: () => _controller.close(), // Stream kapatılırken
    );

    // Hive kutusu değişimlerini dinle
    box.listenable().addListener(_emitData);
  }

  void _emitData() {
    _controller.add(box.values.toList()); // Hive verilerini Stream'e ekle
  }

  void _emitInitialData() {
    _controller.add(box.values.toList()); // İlk durumu yay
  }

  Stream<List<T>> get stream => _controller.stream; // Stream'i dışa aktar

  void dispose() {
    box.listenable().removeListener(_emitData); // Listener'ı kaldır
    _controller.close(); // Kontrolcüyü kapat
  }
}

class ProductionPage extends StatefulWidget {
  // Üretim sayfası
  const ProductionPage({super.key});

  @override
  ProductionPageState createState() => ProductionPageState();
}

class ProductionPageState extends State<ProductionPage> {
  late final HiveStream<Product> _hiveStream; // Hive stream örneği
  late final ProductManagement _productManagement; // Ürün yönetimi

  @override
  void initState() {
    super.initState();
    _productManagement = ProductManagement(); // Ürün yönetimini başlat
    _initializeHive(); // Hive ve stream'i başlat
  }

  Future<void> _initializeHive() async {
    await _productManagement.initHive(); // Hive'ı başlat
    await _productManagement
        .fetchProductsFromFirebase(); // Firebase'den ürünleri çek
    final productBox = Hive.box<Product>('products'); // Ürün kutusunu al
    _hiveStream = HiveStream(productBox); // HiveStream oluştur
  }

  @override
  void dispose() {
    _hiveStream.dispose(); // Stream'i temizle
    super.dispose();
  }

  Future<void> _startProduction(Product product) async {
    product.isProducing = true; // Üretimi başlat
    product.startTime = DateTime.now(); // Başlama zamanını ayarla
    await _productManagement.updateProductInHive(product); // Hive güncelle
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
        stream: _hiveStream.stream,
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
                            'Producing... Started at: ${product.startTime}',
                            style: GoogleFonts.lato(),
                          )
                          : Text('Not producing', style: GoogleFonts.lato()),
                  trailing:
                      product.isProducing
                          ? IconButton(
                            icon: const Icon(Icons.cancel), // İptal butonu
                            onPressed: () => _cancelProduction(product),
                          )
                          : ElevatedButton(
                            onPressed:
                                () =>
                                    _startProduction(product), // Başlat butonu
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
