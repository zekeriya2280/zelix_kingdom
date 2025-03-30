import 'package:cloud_firestore/cloud_firestore.dart';
class Product {
  String id;
  final String name;
  final int productionTime;
  bool isProducing;
  final double purchasePrice;
  DateTime? startTime;
  int amount = 0;
  int remainingTime = 0;
  int productLevel;
  Map<String, int> requiredMaterials = {};
  bool unlocked = false;

  Product({
    required this.id,
    required this.name,
    required this.productionTime,
    required this.productLevel,
    this.isProducing = false,
     required this.purchasePrice,
    this.startTime,
    this.amount = 0,
    this.remainingTime = 0,
    this.requiredMaterials = const {},
    this.unlocked = false,
  });

  // JSON'dan Product modeline dönüşüm
  factory Product.fromJson(Map<dynamic, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      productionTime: json['productionTime'],
      productLevel: json['productLevel'],
      isProducing: json['isProducing'] ?? false,
      purchasePrice: json['purchasePrice'],
      startTime: json['startTime'] != null
          ? (json['startTime'] as Timestamp).toDate()
          : null,
      amount: json['amount'] ?? 0,
      remainingTime: json['remainingTime'] ?? 0,
      requiredMaterials: Map<String, int>.from(json['requiredMaterials']),
      unlocked: json['unlocked'] ?? false,
    );
  }

  // Product modelinden JSON'a dönüşüm
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'productionTime': productionTime,
      'productLevel': productLevel,
      'isProducing': isProducing,
      'purchasePrice': purchasePrice,
      'startTime': startTime?.toIso8601String(),
      'amount': amount,
      'remainingTime': remainingTime,
      'requiredMaterials': requiredMaterials,
      'unlocked': unlocked,
    };
  }

  Product copyWith({DateTime? startTime, required bool isProducing}) {
    return Product(
      id: id,
      name: name,
      productionTime: productionTime,
      productLevel: productLevel,
      isProducing: isProducing,
      purchasePrice: purchasePrice,
      startTime: startTime ?? this.startTime,
      amount: amount,
      remainingTime: remainingTime,
      requiredMaterials: requiredMaterials,
      unlocked: unlocked,
    );
  }
  /// Checks if a user has enough money to purchase this product.
  ///
  /// Returns [true] if the user has enough money, [false] otherwise.
  bool isMoneyEnough(double userMoney) {
    return userMoney >= purchasePrice;
  }
}
