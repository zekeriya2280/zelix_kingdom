

import 'package:zelix_kingdom/models/warehouse.dart';

class Truck {
  final int id; // Unique identifier for the truck
  final int capacity; // Maximum carrying capacity
  Map<String, int> currentLoad = {}; // Map of loaded products and quantities
  String sourceCity; // Starting city
  String destinationCity; // Delivery city

  Truck({
    required this.id,
    required this.capacity,
    required this.sourceCity,
    required this.destinationCity,
  });

  /// Gets the total load currently in the truck.
  int get totalLoad => currentLoad.values.fold(0, (sum, qty) => sum + qty);

  /// Checks if the truck can carry more products.
  bool canLoadMore(int quantity) {
    if (quantity < 0) {
      throw ArgumentError('Quantity cannot be negative.');
    }
    return totalLoad + quantity <= capacity;
  }

  /// Loads a specific product into the truck.
  bool loadProduct(String product, int quantity) {
    if (quantity < 0) {
      throw ArgumentError('Quantity cannot be negative.');
    }
    if (canLoadMore(quantity)) {
      currentLoad[product] = (currentLoad[product] ?? 0) + quantity;
      return true;
    }
    return false; // Not enough space
  }

  /// Checks if "Wait Until Full" is enabled for a specific product in a warehouse.
  bool isWaitUntilFullEnabled(Warehouse? warehouse, String product) {
    if (warehouse == null) {
      throw ArgumentError('Warehouse cannot be null.');
    }
    return warehouse.waitUntilFullPerProduct[product] ?? false;
  }

  /// Starts the journey and calculates upkeep cost.
  void startJourney(double upkeepCost) {
    if (upkeepCost < 0) {
      throw ArgumentError('Upkeep cost cannot be negative.');
    }
    print(
        "Truck $id started journey from $sourceCity to $destinationCity. Upkeep cost: \$${upkeepCost.toStringAsFixed(2)}");
    try {
      completeMission();
    } on Exception catch (e) {
      print('Error while completing mission: $e');
    }
  }

  /// Completes the journey and resets load.
  void completeMission() {
    currentLoad.clear();
    print("Truck $id completed its journey and is now empty.");
  }

  factory Truck.fromJson(Map<String, dynamic> json) {
    if (json['id'] == null) {
      throw ArgumentError('json["id"] cannot be null.');
    }
    if (json['capacity'] == null) {
      throw ArgumentError('json["capacity"] cannot be null.');
    }
    if (json['sourceCity'] == null) {
      throw ArgumentError('json["sourceCity"] cannot be null.');
    }
    if (json['destinationCity'] == null) {
      throw ArgumentError('json["destinationCity"] cannot be null.');
    }
    return Truck(
        id: json['id'],
        capacity: json['capacity'],
        sourceCity: json['sourceCity'],
        destinationCity: json['destinationCity'],
      )..currentLoad = json['currentLoad'] != null
          ? Map<String, int>.from(json['currentLoad'])
          : {};
  }

  /// Converts the truck to a JSON-serializable map.
  ///
  /// The returned map contains the truck's id, capacity, source city, destination city,
  /// and the current load as a map of product names to quantities.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'capacity': capacity,
      'sourceCity': sourceCity,
      'destinationCity': destinationCity,
      'currentLoad': currentLoad,
    };
  }
}
