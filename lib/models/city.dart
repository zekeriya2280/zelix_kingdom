
import 'package:zelix_kingdom/models/warehouse.dart';

class City {
  final String name; // Name of the city
  double price;
  bool isThisCityPurchased;
  int level; // City level
  Map<String, int> productDemands = {}; // Products and their demanded quantities
  late Warehouse warehouse; // City's warehouse

  City({
    required this.name,
    required this.price,
    this.isThisCityPurchased = false,
    this.level = 1,
    required Map<String, int>? productDemands,
    required Warehouse? warehouse,
  }) {
    if (level < 1 || level > 5) {
      throw ArgumentError('Invalid city level. Must be between 1 and 5.');
    }
    if (productDemands != null) {
      this.productDemands = productDemands;
    } else {
      this.productDemands = {};
    }
    if (warehouse != null) {
      this.warehouse = warehouse;
    } else {
      this.warehouse = Warehouse(cityName: name, level: 1, storedProducts: {}, waitUntilFullPerProduct: {});
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
  void unlockProduct(String product) {
    if (!warehouse.storedProducts.containsKey(product)) {
      warehouse.storedProducts[product] = 0;
      print("$product unlocked in $name.");
    }
  }
  isPurchased() {
    return isThisCityPurchased;
  }

  setPurchased() {
    isThisCityPurchased = true;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'isThisCityPurchased': isThisCityPurchased,
      'level': level,
      'productDemands': productDemands,
      'warehouse': warehouse.toJson(),
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
    return City(
      name: json['name'],
      price: json['price'],
      isThisCityPurchased: json['isThisCityPurchased'],
      level: json['level'],
      productDemands: json['productDemands'] != null
          ? Map<String, int>.from(json['productDemands'])
          : {},
      warehouse: json['warehouse'] != null
          ? Warehouse.fromJson(json['warehouse'])
          : Warehouse(cityName: json['name'], level: 1, storedProducts: {}, waitUntilFullPerProduct: {}),
    );
  }
  
}