class DynamicModel {
  final Map<String, dynamic> _data;

  DynamicModel(this._data);

  // Dinamik olarak veriye erişim sağlar
  dynamic get(String key) {
    return _data[key];
  }

  // JSON formatına dönüştürme
  Map<String, dynamic> toJson() {
    return _data;
  }

  @override
  String toString() {
    return _data.toString();
  }
}
