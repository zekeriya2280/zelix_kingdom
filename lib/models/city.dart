
import 'package:zelix_kingdom/models/product.dart';
import 'package:zelix_kingdom/models/truck.dart';
import 'package:zelix_kingdom/models/warehouse.dart';

class City {
  final String name; // Name of the city
  double price;
  bool isThisCityPurchased;
  int level; // City level
  List<Truck> trucks = []; // Trucks in the city
  Map<Product, int> productDemands = {}; // Products and their demanded quantities
  List<Warehouse> warehouses = []; // City's warehouse
  List<Product> unlockedProducts = []; // Products unlocked in the city>

  City({
    required this.name,
    required this.price,
    this.isThisCityPurchased = false,
    this.level = 1,
    required Map<Product, int>? productDemands,
    required List<Warehouse>? warehouses,
    required List<Truck>? trucks,
    required List<Product>? unlockedProducts
  }) {
    if (level < 1 || level > 5) {
      throw ArgumentError('Invalid city level. Must be between 1 and 5.');
    }
    if (productDemands != null) {
      this.productDemands = productDemands;
    } else {
      this.productDemands = {};
    }

    if (warehouses != null) {
      this.warehouses = warehouses;
    } else {
      this.warehouses = [];
    }

    if (trucks != null) {
      this.trucks = trucks;
    } else {
      this.trucks = [];
    }

    if (unlockedProducts != null) {
      this.unlockedProducts = unlockedProducts;
    } else {
      this.unlockedProducts = [];
    
    }
  
  }

  /// Checks if all product demands are fulfilled.
  bool areDemandsMet() {
    for (final demand in productDemands.values) {
      if (demand > 0) {
        return false;
      }
    }
    return true;
  }

  /// Calculates upkeep cost for a truck journey based on city level.
  double calculateUpkeepCost(int truckCapacity) {
    if (truckCapacity <= 0) {
      throw ArgumentError('Truck capacity must be greater than zero.');
    }
    if (level < 1 || level > 5) {
      throw ArgumentError('Invalid city level. Must be between 1 and 5.');
    }

    final baseCostPerUnit = 10.0; // Example base cost per unit
    final levelMultiplier = 1 + (level - 1) * 0.1; // Example level multiplier
    final upkeepCost = truckCapacity * baseCostPerUnit * levelMultiplier;

    return upkeepCost;
  }

  /// Tries to upgrade the city when all demands are met.
  void tryUpgrade() {
    try {
      if (areDemandsMet()) {
        if (level < 5) {
          level++; // Increase city level
          print("City $name upgraded to level $level.");
        } else {
          print("City $name is already at the maximum level.");
        }
      } else {
        print("City $name cannot be upgraded as demands are not met.");
      }
    } catch (e) {
      print("An error occurred while trying to upgrade the city: $e");
    }
  }

  /// Unlocks a product in the city.
  void unlockProduct(Product product) {
    unlockedProducts.add(product);
  }
  bool isPurchased() {
    return isThisCityPurchased;
  }

  void setPurchased() {
    isThisCityPurchased = true;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'isThisCityPurchased': isThisCityPurchased,
      'level': level,
      'productDemands': productDemands,
      'warehouse': warehouses,
      'trucks': trucks,
      'unlockedProducts': unlockedProducts
    };
  }

  factory City.fromJson(Map<String, dynamic> json) {
    if (json['name'] == null) {
      throw ArgumentError('City fromJson json parameter name cannot be null.');
    }
    if (json['price'] == null) {
      throw ArgumentError('City fromJson json parameter price cannot be null.');
    }
    if (json['isThisCityPurchased'] == null) {
      throw ArgumentError(
          'City fromJson json parameter isThisCityPurchased cannot be null.');
    }
    if (json['level'] == null) {
      throw ArgumentError('City fromJson json parameter level cannot be null.');
    }
    if (json['productDemands'] == null) {
      throw ArgumentError(
          'City fromJson json parameter productDemands cannot be null.');
    }
    if (json['warehouse'] == null) {
      throw ArgumentError(
          'City fromJson json parameter warehouse cannot be null.');
    }
    if (json['trucks'] == null) {
      throw ArgumentError('City fromJson json parameter trucks cannot be null.');
    }
    if (json['unlockedProducts'] == null) {
      throw ArgumentError(
          'City fromJson json parameter unlockedProducts cannot be null.');
    }
    return City(
      name: json['name'],
      price: json['price'],
      isThisCityPurchased: json['isThisCityPurchased'],
      level: json['level'],
      productDemands: json['productDemands'] != null
          ? Map<Product, int>.from(json['productDemands'])
          : {},
      warehouses: json['warehouse'] != null
          ? List<Warehouse>.from(json['warehouse'].map((x) => Warehouse.fromJson(x)))
          : [],
      trucks: json['trucks'] != null
          ? List<Truck>.from(json['trucks'].map((x) => Truck.fromJson(x)))
          : [],
      unlockedProducts: json['unlockedProducts'] != null
          ? List<Product>.from(json['unlockedProducts'].map((x) => Product.fromJson(x)))
          : [],
    );
  }
  
}