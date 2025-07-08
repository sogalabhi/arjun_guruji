import 'package:arjun_guruji/features/AudioPlayer/data/model/audio_model.dart';
import 'package:arjun_guruji/features/AudioPlayer/data/model/category_model.dart';
import 'package:arjun_guruji/features/AudioPlayer/domain/entity/audio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AudioRemoteDataSource {
  Future<List<CategoryModel>> fetchCategoriesWithAudios();
  Future<void> feedDummyData();
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

  @override
  Future<void> feedDummyData() async {
    const String categoryImageUrl =
        'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2Fbhajagurunnatham.jpeg?alt=media&token=80aed29b-05fb-4648-95a9-1b4a1c0ada1d';
    const List<String> sampleAudioUrls = [
      'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhaja%20Gurunatham%2F1.mp3?alt=media&token=6c51c303-f754-4a4f-a125-206d3707e49b',
      'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhaja%20Gurunatham%2F2.mp3?alt=media&token=6c51c303-f754-4a4f-a125-206d3707e49b',
      'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhaja%20Gurunatham%2F3.mp3?alt=media&token=6c51c303-f754-4a4f-a125-206d3707e49b',
    ];

    final List<Map<String, dynamic>> categories = [
      {
        'id': 'bhaja_gurunatham',
        'name': 'Bhaja gurunatham',
      },
      {
        'id': 'arati',
        'name': 'Arati',
      },
      {
        'id': 'bhakti_kusumanjali',
        'name': 'Bhakti kusumanjali',
      },
      {
        'id': 'bhuvanada_bhagya',
        'name': 'Bhuvanada bhagya',
      },
    ];

    try {
      for (final category in categories) {
        final categoryRef =
            firestore.collection('categories').doc(category['id']);
        await categoryRef.set({
          'name': category['name'],
          'imageUrl': categoryImageUrl,
        });

        for (int i = 0; i < sampleAudioUrls.length; i++) {
          final audioId = 'audio${i + 1}';
          await categoryRef.collection('audios').doc(audioId).set({
            'title': '${category['name']} ${i + 1}',
            'audioUrl': sampleAudioUrls[i],
            'imageUrl': categoryImageUrl,
            'lyrics': '',
            'category': category['name'],
          });
        }
      }
      print('Dummy data fed successfully.');
    } catch (e) {
      print('Error feeding dummy data: $e');
    }
  }
}
