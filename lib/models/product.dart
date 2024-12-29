class Product {
  final String name; // Name of the product
  final int level; // Level of the product
  final double basePurchasePrice; // Base purchase price of the product
  final double baseSalePrice; // Base sale price of the product
  final int duration; // Duration of the product
  final List<Map<String, dynamic>> requiredMaterials; // List of required materials
  double demandindex; // Demand index of the product

  Product({
    required this.name,
    required this.level,
    required this.basePurchasePrice,
    required this.baseSalePrice,
    required this.duration,
    required this.requiredMaterials,
    this.demandindex = 0.02, // Default demand index of 2%
  }) {
    if (level < 1 || level > 5) {
      throw ArgumentError('Invalid product level. Must be between 1 and 5.');
    }
    if (demandindex < 0 || demandindex > 1) {
      throw ArgumentError('Invalid demand index. Must be between 0 and 1.');
    }
  }

  // Updates the current purchase price based on the demand index
  double get currentPurchasePrice => basePurchasePrice * (1 + demandindex);

  // Updates the current sale price based on the demand index
  double get currentSalePrice => baseSalePrice * (1 + demandindex);

  factory Product.fromMap(Map<String, dynamic> material) {
    if (material.isNotEmpty) {
      return Product(
        name: material['name'] != null ? material['name'].toString() : '',
        level: material['level'] != null ? int.parse(material['level'].toString()) : 0,
        basePurchasePrice: material['purchasePrice'] != null && material['purchasePrice'] != '' ? double.parse(material['purchasePrice'].toString()) : 0.0,
        baseSalePrice: material['salePrice'] != null && material['salePrice'] != '' ? double.parse(material['salePrice'].toString()) : 0.0,
        duration: material['duration'] != null ? int.parse(material['duration'].toString()) : 0,
        requiredMaterials: List<Map<String, dynamic>>.from(material['requiredMaterials'] ?? []),
        demandindex: material['demandindex'] != null ? double.parse(material['demandindex'].toString()) : 0.0,
      );
    } else {
      throw ArgumentError('material cannot be null or empty');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'base_purchase_price': basePurchasePrice,
      'base_sale_price': baseSalePrice,
      'duration': duration,
      'required_materials': requiredMaterials,
      'demandindex': demandindex,
    };
  }
}