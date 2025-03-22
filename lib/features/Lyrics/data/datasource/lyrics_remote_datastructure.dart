import 'package:arjun_guruji/features/Astottaras/data/model/astottara_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AstottarasRemoteDataSource {
  Future<List<AstottaraModel>> fetchAllAstottaras();
}

class AstottarasRemoteDataSourceImpl implements AstottarasRemoteDataSource {
  final FirebaseFirestore firestore;
  AstottarasRemoteDataSourceImpl({required this.firestore});
  @override
  Future<List<AstottaraModel>> fetchAllAstottaras() async {
    final astottaraCollection = firestore.collection('Astottara');
    final querySnapshot = await astottaraCollection.get();
    var astottaras = querySnapshot.docs
        .map((doc) => AstottaraModel.fromJson(doc.data()))
        .toList();
    return astottaras;
  }
}
