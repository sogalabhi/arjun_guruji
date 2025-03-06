import 'package:arjun_guruji/features/AudioPlayer/domain/entity/audio.dart';
import 'package:arjun_guruji/features/AudioPlayer/domain/entity/category.dart';
import 'package:arjun_guruji/features/AudioPlayer/presentation/pages/audio_list_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AudioCategoriesPage extends StatelessWidget {
  // Dummy data for categories
  final List<CategoryEntity> categories = [
    CategoryEntity(
      id: '1',
      name: 'Arati',
      imageUrl: 'assets/img12.jpg',
      audios: [
        AudioEntity(
            id: '1',
            title: 'ದಯಾಮಯ',
            audioUrl:
                'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Arati%2Fdayamaya%20guru.mp3?alt=media&token=fee0470d-19a1-406b-bbe1-d8f33e9e79fe',
            imageUrl: 'assets/img1.jpeg',
            lyrics: '',
            category: 'Arati'),
        AudioEntity(
            id: '2',
            title: 'ಗಂಗಜಟಾಧರ',
            audioUrl:
                'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Arati%2FHara%20Ganga%20Jatadhara%20Gouri%20Shankara%20(%20256kbps%20cbr%20).mp3?alt=media&token=7da0d3ca-9825-426b-b9ac-7ec896b9f811',
            imageUrl: 'assets/img1.jpeg',
            lyrics: '',
            category: 'Arati'),
        AudioEntity(
            id: '3',
            title: 'ಸಂಜೆ ಆರತಿ',
            audioUrl:
                'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Arati%2Fsai%20baba%20dhoop%20aarti%20(Evening%20Aarti)%20(%20128kbps%20).mp3?alt=media&token=0bee713b-e653-4d2a-89dd-6ba73f8d8ab0',
            imageUrl: 'assets/img1.jpeg',
            lyrics: '',
            category: 'Arati'),
        AudioEntity(
            id: '4',
            title: 'ಮಂಗಳಂ ಗುರು ಶ್ರೀ',
            audioUrl:
                'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Arati%2FMangalam%20Guru%20Sri%20Chandramouleeshwara%20ke....Arathi%20song%20of%20Shri%20Sringeri%20Jagatguru%20%20parampariya..%20(%20256kbps%20cbr%20).mp3?alt=media&token=ff8c39ab-ef92-4bef-9a68-434ecdf906fa',
            imageUrl: 'assets/img1.jpeg',
            lyrics: '',
            category: 'Arati'),
      ],
    ),
    CategoryEntity(
      id: '2',
      name: 'BhajaGurunatham',
      imageUrl: 'assets/img1.jpeg',
      audios: [
        AudioEntity(
            id: '5',
            title: 'ಸಖಾರಾಯಪಟ್ಟಣದ ನಾಥನೇ',
            audioUrl:
                'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhaja%20Gurunatham%2F1.mp3?alt=media&token=6c51c303-f754-4a4f-a125-206d3707e49b',
            imageUrl: 'assets/img1.jpeg',
            lyrics: '',
            category: 'BhajaGurunatham'),
        AudioEntity(
            id: '6',
            title: 'ಗುರುನಾಮವೇ ಪಾವನಂ',
            audioUrl:
                'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhaja%20Gurunatham%2F2.mp3?alt=media&token=6c51c303-f754-4a4f-a125-206d3707e49b',
            imageUrl: 'assets/img1.jpeg',
            lyrics: '',
            category: 'BhajaGurunatham'),
        AudioEntity(
            id: '7',
            title: 'ಭಜ ಗುರುನಾಥಮ್',
            audioUrl:
                'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhaja%20Gurunatham%2F3.mp3?alt=media&token=6c51c303-f754-4a4f-a125-206d3707e49b',
            imageUrl: 'assets/img1.jpeg',
            lyrics: '',
            category: 'BhajaGurunatham'),
        AudioEntity(
            id: '8',
            title: 'ಗುರುನಾಥನೇ ನನ್ನ ಈಶ್ವರ',
            audioUrl:
                'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhaja%20Gurunatham%2F4.mp3?alt=media&token=6c51c303-f754-4a4f-a125-206d3707e49b',
            imageUrl: 'assets/img1.jpeg',
            lyrics: '',
            category: 'BhajaGurunatham'),
        AudioEntity(
            id: '9',
            title: 'ಅರ್ಜುನಂ ಶ್ರೀಧರಂ',
            audioUrl:
                'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhaja%20Gurunatham%2F5.mp3?alt=media&token=6c51c303-f754-4a4f-a125-206d3707e49b',
            imageUrl: 'assets/img1.jpeg',
            lyrics: '',
            category: 'BhajaGurunatham'),
        AudioEntity(
            id: '10',
            title: 'ನಾವು ನೀವು ಸೇರಿ',
            audioUrl:
                'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhaja%20Gurunatham%2F6.mp3?alt=media&token=6c51c303-f754-4a4f-a125-206d3707e49b',
            imageUrl: 'assets/img1.jpeg',
            lyrics: '',
            category: 'BhajaGurunatham'),
        AudioEntity(
            id: '11',
            title: 'ನಮ್ಮ ಸದ್ಗುರು ಗುರುನಾಥ',
            audioUrl:
                'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhaja%20Gurunatham%2F7.mp3?alt=media&token=6c51c303-f754-4a4f-a125-206d3707e49b',
            imageUrl: 'assets/img1.jpeg',
            lyrics: '',
            category: 'BhajaGurunatham'),
      ],
    ),
    CategoryEntity(
      id: '3',
      name: 'Astottara',
      imageUrl: 'assets/img1.jpeg',
      audios: [
        AudioEntity(
            id: '12',
            title: 'ಗುರುನಾಥರ ಅಷ್ಟೋತ್ತರ',
            audioUrl:
                'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Astottara%2F1.mp3?alt=media&token=e7d4dbaa-2ff7-457a-8a2a-a8c3767136a9',
            imageUrl: 'assets/img1.jpeg',
            lyrics: '',
            category: 'Astottara'),
        AudioEntity(
            id: '13',
            title: 'ಅರ್ಜುನ ಗುರುಗಳ ಅಷ್ಟೋತ್ತರ',
            audioUrl:
                'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Astottara%2F2.mp3?alt=media&token=e7d4dbaa-2ff7-457a-8a2a-a8c3767136a9',
            imageUrl: 'assets/img1.jpeg',
            lyrics: '',
            category: 'Astottara'),
      ],
    ),
    CategoryEntity(
      id: '4',
      name: 'BhuvanadaBhagya',
      imageUrl: 'assets/img1.jpeg',
      audios: [
        AudioEntity(
            id: '14',
            title: 'ಆರತಿ ಬೆಳಗಿರೋ',
            audioUrl:
                'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2F1.mp3?alt=media&token=b61cb258-e983-4030-8526-9030758e33d2',
            imageUrl: 'assets/img1.jpeg',
            lyrics: '',
            category: 'BhuvanadaBhagya'),
        AudioEntity(
            id: '15',
            title: 'ಬಾಬಾ ಬಂದರು ನಮ್ಮ ಮನೆಗೆ',
            audioUrl:
                'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2F2.mp3?alt=media&token=b61cb258-e983-4030-8526-9030758e33d2',
            imageUrl: 'assets/img1.jpeg',
            lyrics: '',
            category: 'BhuvanadaBhagya'),
        AudioEntity(
            id: '16',
            title: 'ಭುವನದ ಭಾಗ್ಯ',
            audioUrl:
                'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2F3.mp3?alt=media&token=b61cb258-e983-4030-8526-9030758e33d2',
            imageUrl: 'assets/img1.jpeg',
            lyrics: '',
            category: 'BhuvanadaBhagya'),
        AudioEntity(
            id: '17',
            title: 'ದಿವದಿಂದು ಭೂಮಿಗಿಳಿದು ಬಂದ',
            audioUrl:
                'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2F4.mp3?alt=media&token=b61cb258-e983-4030-8526-9030758e33d2',
            imageUrl: 'assets/img1.jpeg',
            lyrics: '',
            category: 'BhuvanadaBhagya'),
        AudioEntity(
            id: '18',
            title: 'ಏನು ಪದವೋ',
            audioUrl:
                'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2F5.mp3?alt=media&token=b61cb258-e983-4030-8526-9030758e33d2',
            imageUrl: 'assets/img1.jpeg',
            lyrics: '',
            category: 'BhuvanadaBhagya'),
        AudioEntity(
            id: '19',
            title: 'ಪಾಹಿ ಪಾಹಿ',
            audioUrl:
                'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2F6.mp3?alt=media&token=b61cb258-e983-4030-8526-9030758e33d2',
            imageUrl: 'assets/img1.jpeg',
            lyrics: '',
            category: 'BhuvanadaBhagya'),
        AudioEntity(
            id: '20',
            title: 'ಸಾಯಿ ಬಾಬಾ ಸಾಯಿ ಬಾಬಾ',
            audioUrl:
                'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2F7.mp3?alt=media&token=b61cb258-e983-4030-8526-9030758e33d2',
            imageUrl: 'assets/img1.jpeg',
            lyrics: '',
            category: 'BhuvanadaBhagya'),
        AudioEntity(
            id: '21',
            title: 'ಸಾಯಿ ಎನ್ನಿರೋ',
            audioUrl:
                'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2F8.mp3?alt=media&token=b61cb258-e983-4030-8526-9030758e33d2',
            imageUrl: 'assets/img1.jpeg',
            lyrics: '',
            category: 'BhuvanadaBhagya'),
        AudioEntity(
            id: '22',
            title: 'ಶ್ರೀ ಸಾಯಿ ನಿನ್ನ ನಂಬಿದೆ',
            audioUrl:
                'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2F9.mp3?alt=media&token=b61cb258-e983-4030-8526-9030758e33d2',
            imageUrl: 'assets/img1.jpeg',
            lyrics: '',
            category: 'BhuvanadaBhagya'),
      ],
    ),
  ];

  AudioCategoriesPage({super.key});
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadCategories(List<CategoryEntity> categories) async {
    try {
      
      print('Uploading!');
      for (var category in categories) {
        // Create category document
        DocumentReference categoryRef =
            _firestore.collection('audio_categories').doc(category.id);
        await categoryRef.set({
          'id': category.id,
          'name': category.name,
          'image_url': category.imageUrl,
        });

        // Upload each audio inside the category
        for (var audio in category.audios) {
          await categoryRef.collection('audios').doc(audio.id).set({
            'id': audio.id,
            'title': audio.title,
            'audio_url': audio.audioUrl,
            'image_url': audio.imageUrl,
            'lyrics': audio.lyrics,
            'category': audio.category,
          });
        }
      }
      print('Upload successful!');
    } catch (e) {
      print('Error uploading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Categories'),
        leading: IconButton(
          icon: const Icon(Icons.upload),
          onPressed: () {
            uploadCategories(categories);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AudioListPage(category: category),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      category.imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      category.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
