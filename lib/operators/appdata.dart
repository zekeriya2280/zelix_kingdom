import 'package:zelix_kingdom/models/dynamicmodel.dart';
import 'package:zelix_kingdom/services/firebaseservice.dart';

class AppData {
  static final AppData _instance = AppData._internal();

  factory AppData() => _instance;

  AppData._internal();

  Map<String, Map<String, String>> schemas = {};
  Map<String, List<DynamicModel>> models = {};

  Future<void> loadData() async {
    final service = FirebaseService();

    // Şemaları yükle
    schemas = await service.fetchSchemas();

    // Tüm koleksiyonları yükle
    for (var collectionName in schemas.keys) {
      models[collectionName] = await service.fetchData(collectionName);
    }
  }
}
