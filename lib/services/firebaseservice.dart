import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zelix_kingdom/models/dynamicmodel.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firebase'den şemaları çeker
  Future<Map<String, Map<String, String>>> fetchSchemas() async {
    final snapshot = await _firestore.collection('model_schemas').get();
    return {
      for (var doc in snapshot.docs)
        doc.id: Map<String, String>.from(doc.data()['fields'])
    };
  }

  // Firebase'den koleksiyon verilerini çeker
  Future<List<DynamicModel>> fetchData(String collectionName) async {
    final snapshot = await _firestore.collection(collectionName).get();
    return snapshot.docs.map((doc) => DynamicModel(doc.data())).toList();
  }
}
