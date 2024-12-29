import 'package:flutter/material.dart';
import 'package:zelix_kingdom/managements/productmanagements.dart';
import 'package:zelix_kingdom/models/product.dart';

class ProductionPage extends StatefulWidget {
  final String userId;

  const ProductionPage({super.key, required this.userId});

  @override
  _ProductionPageState createState() => _ProductionPageState();
}

class _ProductionPageState extends State<ProductionPage> {
  final ProductManagement _productManagement = ProductManagement();
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    await _productManagement.initHive();
    await _productManagement.fetchProductsFromFirebase();
    setState(() {
      _products = _productManagement.getProductsFromHive();
    });
  }

  Future<void> _startProduction(Product product) async {
    product.isProducing = true;
    product.startTime = DateTime.now();
    await _productManagement.updateProductInHive(product);
    await _productManagement.syncProductToFirebase(widget.userId, product);

    setState(() {
      // Hive'daki güncel değerleri çekmek için
      _products = _productManagement.getProductsFromHive();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Production')),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return Card(
            child: ListTile(
              title: Text(product.name),
              subtitle: product.isProducing
                  ? Text('Producing... Started at: ${product.startTime}')
                  : Text('Not producing'),
              trailing: ElevatedButton(
                onPressed: () {
                  if (!product.isProducing) {
                    _startProduction(product);
                  }
                },
                child: Text(product.isProducing ? 'Producing' : 'Start'),
              ),
            ),
          );
        },
      ),
    );
  }
}
