import 'package:arjun_guruji/features/AudioPlayer/data/model/audio_model.dart';
import 'package:arjun_guruji/features/AudioPlayer/data/model/category_model.dart';
import 'package:arjun_guruji/features/AudioPlayer/domain/entity/audio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AudioRemoteDataSource {
  Future<List<CategoryModel>> fetchCategoriesWithAudios();
}

class AudioRemoteDataSourceImpl implements AudioRemoteDataSource {
  final FirebaseFirestore firestore;

  AudioRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<CategoryModel>> fetchCategoriesWithAudios() async {
    try {
      // Fetch all categories
      QuerySnapshot categorySnapshot =
          await firestore.collection('categories').get();

      List<CategoryModel> categories = [];

      // Iterate through each category document
      for (var categoryDoc in categorySnapshot.docs) {
        String categoryId = categoryDoc.id;
        Map<String, dynamic> categoryData =
            categoryDoc.data() as Map<String, dynamic>;

        // Fetch audios in this category (from the 'audios' subcollection)
        QuerySnapshot audioSnapshot = await firestore
            .collection('categories')
            .doc(categoryId)
            .collection('audios')
            .get();

        // Map audio documents to AudioModel objects using fromJson
        List<AudioEntity> audios = audioSnapshot.docs.map((doc) {
          return AudioModel.fromJson(
              doc.id, doc.data() as Map<String, dynamic>);
        }).toList();

        // Add the category with its audios to the list using fromJson
        categories
            .add(CategoryModel.fromJson(categoryId, categoryData, audios));
      }

      print("Fetched categories: $categories");
      return categories;
    } catch (e) {
      print("Error fetching categories: $e");
      return [];
    }
  }
}
