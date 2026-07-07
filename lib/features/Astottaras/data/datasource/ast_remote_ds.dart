import 'package:arjun_guruji/features/Astottaras/data/model/astottara_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AstottarasRemoteDataSource {
  Future<List<AstottaraModel>> fetchAllAstottaras();
  Future<List<Map<String, dynamic>>> fetchAstottaraTimestamps();
}

class AstottarasRemoteDataSourceImpl implements AstottarasRemoteDataSource {
  final FirebaseFirestore firestore;
  AstottarasRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<AstottaraModel>> fetchAllAstottaras() async {
    final astottaraCollection = firestore.collection('Astottara');
    final querySnapshot = await astottaraCollection.get();
    var astottaras = querySnapshot.docs
        .map((doc) {
          final data = doc.data();
          final lastUpdated = data['lastUpdated'];
          return AstottaraModel.fromJson({
            ...data,
            'lastUpdated': lastUpdated is Timestamp ? lastUpdated.toDate() : null,
            'imageBytes': null,
          });
        })
        .toList();
    return astottaras;
  }

  @override
  Future<List<Map<String, dynamic>>> fetchAstottaraTimestamps() async {
    final astottaraCollection = firestore.collection('Astottara');
    final querySnapshot = await astottaraCollection.get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      final lastUpdated = data['lastUpdated'];
      return {
        'title': data['title'] as String? ?? '',
        'lastUpdated': lastUpdated is Timestamp ? lastUpdated.toDate() : null,
      };
    }).toList();
  }
}
