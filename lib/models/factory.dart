class Factory {
  final String cityName; // Fabrikanın bulunduğu şehir
  final String productType; // Üretilen ürün tipi
  final Duration productionTime; // Üretim süresi
  final Map<String, int> requiredMaterials; // Gerekli hammaddeler

  Factory({
    required this.cityName,
    required this.productType,
    required this.productionTime,
    this.requiredMaterials = const {},
  });

  /// JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'productType': productType,
      'productionTime': productionTime.inSeconds,
      'requiredMaterials': requiredMaterials,
    };
  }

  /// JSON'dan nesne oluşturma
  factory Factory.fromJson(Map<String, dynamic> json) {
    if (json['cityName'] == null) {
      throw StateError('cityName is null in JSON. Ensure it is present.');
    }
    if (json['productType'] == null) {
      throw StateError('productType is null in JSON. Ensure it is present.');
    }
    if (json['productionTime'] == null) {
      throw StateError('productionTime is null in JSON. Ensure it is present.');
    }
    if (json['requiredMaterials'] == null) {
      throw StateError('requiredMaterials is null in JSON. Ensure it is present.');
    }
    return Factory(
      cityName: json['cityName'],
      productType: json['productType'],
      productionTime: Duration(seconds: json['productionTime']),
      requiredMaterials: Map<String, int>.from(json['requiredMaterials']),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'cityName': cityName,
      'productType': productType,
      'productionTime': productionTime.inSeconds,
      'requiredMaterials': requiredMaterials,
    };
  }
}