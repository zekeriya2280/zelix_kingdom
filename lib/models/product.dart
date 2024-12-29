import 'package:hive/hive.dart';

part 'product.g.dart'; // Hive TypeAdapter için gerekli dosya

@HiveType(typeId: 0) // Her model için benzersiz typeId kullanılır
class Product {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int productionTime;

  @HiveField(3)
  bool isProducing;

  @HiveField(4)
  DateTime? startTime;

  Product({
    required this.id,
    required this.name,
    required this.productionTime,
    this.isProducing = false,
    this.startTime,
  });

  // JSON'dan Product modeline dönüşüm
  factory Product.fromJson(String id, Map<String, dynamic> json) {
    return Product(
      id: id,
      name: json['name'],
      productionTime: json['productionTime'],
      isProducing: json['isProducing'] ?? false,
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
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
}
