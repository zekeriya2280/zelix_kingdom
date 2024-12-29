
/// Represents a warehouse with levels and capacity for storing products.
class Warehouse {
  final String cityName; // Name of the city the warehouse belongs to
  int level; // Warehouse level (1, 2, or 3)
  Map<String, int> storedProducts = {}; // Products and their stored quantities
  Map<String, bool> waitUntilFullPerProduct = {}; // Wait Until Full setting per product

  Warehouse({
    required this.cityName,
    this.level = 1,
    required Map<String, int>? storedProducts,
    required Map<String, bool>? waitUntilFullPerProduct,
  }) {
    if (level < 1 || level > 3) {
      throw ArgumentError('Invalid warehouse level. Must be between 1 and 3.');
    }
    if (storedProducts != null) {
      this.storedProducts = storedProducts;
    }
    if (waitUntilFullPerProduct != null) {
      this.waitUntilFullPerProduct = waitUntilFullPerProduct;
    }
  }

  /// Gets the maximum capacity for any product based on the warehouse level.
  int get maxCapacityPerProduct {
    switch (level) {
      case 1:
        return 74;
      case 2:
        return 84;
      case 3:
        return 99;
      default:
        throw StateError('Invalid warehouse level.');
    }
  }

  /// Checks if the warehouse is full for a specific product.
  bool isFull(String product) {
    final currentQuantity = storedProducts[product] ?? 0;
    return currentQuantity >= maxCapacityPerProduct;
  }

  /// Adds products to the warehouse, respecting capacity limits.
  int addProduct(String product, int quantity) {
    if (quantity < 0) {
      throw ArgumentError('Quantity cannot be negative.');
    }
    final currentQuantity = storedProducts[product] ?? 0;
    final availableSpace = maxCapacityPerProduct - currentQuantity;
    final addedQuantity = quantity.clamp(0, availableSpace);
    storedProducts[product] = currentQuantity + addedQuantity;
    return addedQuantity; // Return how much was actually added
  }

  /// Removes products from the warehouse for truck loading.
  int removeProduct(String product, int quantity) {
    if (quantity < 0) {
      throw ArgumentError('Quantity cannot be negative.');
    }
    final currentQuantity = storedProducts[product] ?? 0;
    final removedQuantity = quantity.clamp(0, currentQuantity);
    storedProducts[product] = currentQuantity - removedQuantity;
    return removedQuantity; // Return how much was actually removed
  }

  /// Checks if "Wait Until Full" is enabled for a specific product.
  bool isWaitUntilFullEnabled(String product) {
    return waitUntilFullPerProduct[product] ?? false;
  }

  /// Sets "Wait Until Full" for a specific product.
  void setWaitUntilFull(String product, bool enabled) {
    waitUntilFullPerProduct[product] = enabled;
  }

  factory Warehouse.fromJson(Map<String, dynamic> json) {
    return Warehouse(
      cityName: json['cityName'],
      level: json['level'],
      storedProducts: json['storedProducts'] != null
          ? Map<String, int>.from(json['storedProducts'])
          : {},
      waitUntilFullPerProduct: json['waitUntilFullPerProduct'] != null
          ? Map<String, bool>.from(json['waitUntilFullPerProduct'])
          : {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'level': level,
      'storedProducts': storedProducts,
      'waitUntilFullPerProduct': waitUntilFullPerProduct,
    };
  }
}