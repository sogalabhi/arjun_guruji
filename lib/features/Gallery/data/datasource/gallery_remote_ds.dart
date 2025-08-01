import 'package:cloud_firestore/cloud_firestore.dart';

abstract class GalleryRemoteDataSource {
  Future<Map<String, dynamic>> fetchGalleryData();
}

class GalleryRemoteDataSourceImpl implements GalleryRemoteDataSource {
  final FirebaseFirestore firestore;
  GalleryRemoteDataSourceImpl({required this.firestore});

  @override
  Future<Map<String, dynamic>> fetchGalleryData() async {
    final galleryCollection = firestore.collection('Gallery');
    final querySnapshot = await galleryCollection.get();

    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      final data = doc.data();
      return {
        'count': data['count'] as int,
        'baseUrl': data['baseUrl'] as String,
        'afterUrl': data['afterUrl'] as String,
      };
    } else {
      throw Exception('No documents found in the Gallery collection');
    }
  }
}
