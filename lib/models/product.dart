import 'package:cloud_firestore/cloud_firestore.dart';
class Product {
  final String name;
  final int productionTime;
  bool isProducing;
  DateTime? startTime;

  int get remainingTime {
    if (startTime == null) {
      return productionTime;
    } else {
      return productionTime - DateTime.now().difference(startTime!).inSeconds;
    }
  }

  Product({
    required this.name,
    required this.productionTime,
    this.isProducing = false,
    this.startTime,
  });

  // JSON'dan Product modeline dönüşüm
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      productionTime: json['productionTime'],
      isProducing: json['isProducing'] ?? false,
      startTime: json['startTime'] != null
          ? (json['startTime'] as Timestamp).toDate()
          : null,
    );
  }

  // Product modelinden JSON'a dönüşüm
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'productionTime': productionTime,
      'isProducing': isProducing,
      'startTime': startTime?.toIso8601String(),
    };
  }

  Product copyWith({DateTime? startTime, required bool isProducing}) {
    return Product(
      name: name,
      productionTime: productionTime,
      isProducing: isProducing,
      startTime: startTime ?? this.startTime,
    );
  }
}
