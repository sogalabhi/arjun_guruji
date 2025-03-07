import 'package:arjun_guruji/core/widgets/gradient_background.dart';
import 'package:arjun_guruji/features/AudioPlayer/domain/entity/category.dart';
import 'package:arjun_guruji/features/AudioPlayer/presentation/pages/audio_list_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:arjun_guruji/features/AudioPlayer/domain/entity/audio.dart';

class AudioCategoriesPage extends StatelessWidget {
  const AudioCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for categories
    final List<CategoryEntity> categories = [
      CategoryEntity(
        id: '1',
        name: 'Arati',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2Fimg2.jpg?alt=media&token=c3675c3f-3e1c-43ef-b33f-504edf8b8f55',
        audios: [
          AudioEntity(
              id: '1',
              title: 'ದಯಾಮಯ',
              audioUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Arati%2Fdayamaya%20guru.mp3?alt=media&token=fee0470d-19a1-406b-bbe1-d8f33e9e79fe',
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2Fimg2.jpg?alt=media&token=c3675c3f-3e1c-43ef-b33f-504edf8b8f55',
              lyrics: '''ದಯಾಮಯಾ  ಸಾಯಿ ಕರುಣಾಮಯಾ|
ಕರುಣಾಮಯಾ ಸಾಯಿ ಪ್ರೇಮಾಮಯಾ||

ಪರಮ ಸ್ವರೂಪನು ತಾನಂತೆ
ಅರಿಯಲು ಭಕ್ತಿಯು ಬೇಕಂತೆ|
ಒಲಿದರೆ ಪಾವನನವನಂತೆ
ಸಂಸಾರದ ಭಯ ಅವಗಿಲ್ಲಂತೆ||

ಗುರುವಿಗೆ ಸಮನಾರಿಲ್ಲಂತೆ
ಗುರು ಪಾದವ ನಂಬಿರಬೇಕಂತೆ|
ಧೃಡತೆಯು ತನಗಿರಬೇಕಂತೆ
ಧೃತಿಗೆಡದೇ ತಾನಿರಬೇಕಂತೆ||

ಪಾಪಿಗೆ ತಾಪವು ದೂರಂತೆ
ದುರ್ಮಾರ್ಗಿಗೆ ಕಾಣನು ಗುರುವಂತೆ|
ಕುಟಿಲರಿಗೊಲಿಯನು ತಾನಂತೆ
ಕುಹಕಿಗೆ ಎಂದೂ ಸಿಗನಂತೆ||

ಜ್ಞಾನವೇ ತನ್ನುಸಿರಾಗಿಹುದು
ಉಸುರಲು ಪಾವನವಾಗುವುದು|
ಸೇವೆಯೇ ಸಾಧನೆಯಾಗಿಹುದು
ಗುರುಕರುಣೆಯೇ ಧನ್ಯನ ಮಾಡುವುದು||

ಶರಣಾಗತರನು ಕಾಯುವನು
ಪರಮಾನಂದವನುಣಿಸುವನು|
ನಿಜಭಕ್ತಿಗೆ ಗುರು ತಲೆ ಬಾಗುವನು|
ಭವಜಲಧಿಯ ದಾಟಿಸಿ ಕಾಯುವನು||

ನಾನೇ ಎಂಬುದನಳಿ ಎಂದ
ಮದ ಮತ್ಸರಗಳ ನೀ ಸುಡು ಎಂದ|
ದುರುಳರಿಗೆ ನಾ ದೂರೆಂದ
ದುರಹಂಕಾರಿಗೆ ನಾ ಸಿಗನೆಂದ||

ಸದ್ಗುರು ದೊರೆವುದು ದುರ್ಲಭವು
ದೊರೆತರೆ ಜನ್ಮವು ಪಾವನವು|
ಸಾರುತಲಿರುವವು ಶಾಸ್ತ್ರಗಳು
ಗುರು ಸಾಯೀಶ್ವರರು ಅಹುದೆಂದು||

ಅಚ್ಯುತ ಅನಂತ ಶ್ರೀ ಗುರುವೇ
ಚಿನ್ಮಯ ಚಿತ್ತನು ನೀ ಗುರುವೇ|
ಗುರುಸಾಯೀಶ್ವರ ಬಾ ಗುರುವೇ|
ಕರಜೋಡಿಸಿ ನಾ ಶಿರಬಾಗಿರುವೆ|| ''',
              category: 'Arati'),
          AudioEntity(
              id: '2',
              title: 'ಗಂಗಜಟಾಧರ',
              audioUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Arati%2FHara%20Ganga%20Jatadhara%20Gouri%20Shankara%20(%20256kbps%20cbr%20).mp3?alt=media&token=7da0d3ca-9825-426b-b9ac-7ec896b9f811',
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2Fimg2.jpg?alt=media&token=c3675c3f-3e1c-43ef-b33f-504edf8b8f55',
              lyrics: '',
              category: 'Arati'),
          AudioEntity(
              id: '3',
              title: 'ಸಂಜೆ ಆರತಿ',
              audioUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Arati%2Fsai%20baba%20dhoop%20aarti%20(Evening%20Aarti)%20(%20128kbps%20).mp3?alt=media&token=0bee713b-e653-4d2a-89dd-6ba73f8d8ab0',
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2Fimg2.jpg?alt=media&token=c3675c3f-3e1c-43ef-b33f-504edf8b8f55',
              lyrics: '',
              category: 'Arati'),
          AudioEntity(
              id: '4',
              title: 'ಮಂಗಳಂ ಗುರು ಶ್ರೀ',
              audioUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Arati%2FMangalam%20Guru%20Sri%20Chandramouleeshwara%20ke....Arathi%20song%20of%20Shri%20Sringeri%20Jagatguru%20%20parampariya..%20(%20256kbps%20cbr%20).mp3?alt=media&token=ff8c39ab-ef92-4bef-9a68-434ecdf906fa',
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2Fimg2.jpg?alt=media&token=c3675c3f-3e1c-43ef-b33f-504edf8b8f55',
              lyrics: '',
              category: 'Arati'),
        ],
      ),
      CategoryEntity(
        id: '2',
        name: 'BhajaGurunatham',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2Fbhajagurunnatham.jpeg?alt=media&token=80aed29b-05fb-4648-95a9-1b4a1c0ada1d',
        audios: [
          AudioEntity(
              id: '5',
              title: 'ಸಖಾರಾಯಪಟ್ಟಣದ ನಾಥನೇ',
              audioUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhaja%20Gurunatham%2F1.mp3?alt=media&token=6c51c303-f754-4a4f-a125-206d3707e49b',
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2Fbhajagurunnatham.jpeg?alt=media&token=80aed29b-05fb-4648-95a9-1b4a1c0ada1d',
              lyrics: '',
              category: 'BhajaGurunatham'),
          AudioEntity(
              id: '6',
              title: 'ಗುರುನಾಮವೇ ಪಾವನಂ',
              audioUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhaja%20Gurunatham%2F2.mp3?alt=media&token=6c51c303-f754-4a4f-a125-206d3707e49b',
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2Fbhajagurunnatham.jpeg?alt=media&token=80aed29b-05fb-4648-95a9-1b4a1c0ada1d',
              lyrics: '',
              category: 'BhajaGurunatham'),
          AudioEntity(
              id: '7',
              title: 'ಭಜ ಗುರುನಾಥಮ್',
              audioUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhaja%20Gurunatham%2F3.mp3?alt=media&token=6c51c303-f754-4a4f-a125-206d3707e49b',
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2Fbhajagurunnatham.jpeg?alt=media&token=80aed29b-05fb-4648-95a9-1b4a1c0ada1d',
              lyrics: '',
              category: 'BhajaGurunatham'),
          AudioEntity(
              id: '8',
              title: 'ಗುರುನಾಥನೇ ನನ್ನ ಈಶ್ವರ',
              audioUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhaja%20Gurunatham%2F4.mp3?alt=media&token=6c51c303-f754-4a4f-a125-206d3707e49b',
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2Fbhajagurunnatham.jpeg?alt=media&token=80aed29b-05fb-4648-95a9-1b4a1c0ada1d',
              lyrics: '',
              category: 'BhajaGurunatham'),
          AudioEntity(
              id: '9',
              title: 'ಅರ್ಜುನಂ ಶ್ರೀಧರಂ',
              audioUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhaja%20Gurunatham%2F5.mp3?alt=media&token=6c51c303-f754-4a4f-a125-206d3707e49b',
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2Fbhajagurunnatham.jpeg?alt=media&token=80aed29b-05fb-4648-95a9-1b4a1c0ada1d',
              lyrics: '',
              category: 'BhajaGurunatham'),
          AudioEntity(
              id: '10',
              title: 'ನಾವು ನೀವು ಸೇರಿ',
              audioUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhaja%20Gurunatham%2F6.mp3?alt=media&token=6c51c303-f754-4a4f-a125-206d3707e49b',
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2Fbhajagurunnatham.jpeg?alt=media&token=80aed29b-05fb-4648-95a9-1b4a1c0ada1d',
              lyrics: '',
              category: 'BhajaGurunatham'),
          AudioEntity(
              id: '11',
              title: 'ನಮ್ಮ ಸದ್ಗುರು ಗುರುನಾಥ',
              audioUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhaja%20Gurunatham%2F7.mp3?alt=media&token=6c51c303-f754-4a4f-a125-206d3707e49b',
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2Fbhajagurunnatham.jpeg?alt=media&token=80aed29b-05fb-4648-95a9-1b4a1c0ada1d',
              lyrics: '',
              category: 'BhajaGurunatham'),
        ],
      ),
      CategoryEntity(
        id: '3',
        name: 'Astottara',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2Fimg12.jpg?alt=media&token=07712159-52e0-48d8-ac73-eac6557f340a',
        audios: [
          AudioEntity(
              id: '12',
              title: 'ಗುರುನಾಥರ ಅಷ್ಟೋತ್ತರ',
              audioUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Astottara%2F1.mp3?alt=media&token=e7d4dbaa-2ff7-457a-8a2a-a8c3767136a9',
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2Fimg12.jpg?alt=media&token=07712159-52e0-48d8-ac73-eac6557f340a',
              lyrics: '',
              category: 'Astottara'),
          AudioEntity(
              id: '13',
              title: 'ಅರ್ಜುನ ಗುರುಗಳ ಅಷ್ಟೋತ್ತರ',
              audioUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Astottara%2F2.mp3?alt=media&token=e7d4dbaa-2ff7-457a-8a2a-a8c3767136a9',
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2Fimg12.jpg?alt=media&token=07712159-52e0-48d8-ac73-eac6557f340a',
              lyrics: '',
              category: 'Astottara'),
        ],
      ),
      CategoryEntity(
        id: '4',
        name: 'BhuvanadaBhagya',
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2Fimg12.jpg?alt=media&token=07712159-52e0-48d8-ac73-eac6557f340a',
        audios: [
          AudioEntity(
              id: '14',
              title: 'ಆರತಿ ಬೆಳಗಿರೋ',
              audioUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2F1.mp3?alt=media&token=b61cb258-e983-4030-8526-9030758e33d2',
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2Fbhuvanadabhagya.jpg?alt=media&token=b6335156-54c4-495f-806b-5504beb6b0e6',
              lyrics: '',
              category: 'BhuvanadaBhagya'),
          AudioEntity(
              id: '15',
              title: 'ಬಾಬಾ ಬಂದರು ನಮ್ಮ ಮನೆಗೆ',
              audioUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2F2.mp3?alt=media&token=b61cb258-e983-4030-8526-9030758e33d2',
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2Fbhuvanadabhagya.jpg?alt=media&token=b6335156-54c4-495f-806b-5504beb6b0e6',
              lyrics: '',
              category: 'BhuvanadaBhagya'),
          AudioEntity(
              id: '16',
              title: 'ಭುವನದ ಭಾಗ್ಯ',
              audioUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2F3.mp3?alt=media&token=b61cb258-e983-4030-8526-9030758e33d2',
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2Fbhuvanadabhagya.jpg?alt=media&token=b6335156-54c4-495f-806b-5504beb6b0e6',
              lyrics: '',
              category: 'BhuvanadaBhagya'),
          AudioEntity(
              id: '17',
              title: 'ದಿವದಿಂದು ಭೂಮಿಗಿಳಿದು ಬಂದ',
              audioUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2F4.mp3?alt=media&token=b61cb258-e983-4030-8526-9030758e33d2',
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2Fbhuvanadabhagya.jpg?alt=media&token=b6335156-54c4-495f-806b-5504beb6b0e6',
              lyrics: '',
              category: 'BhuvanadaBhagya'),
          AudioEntity(
              id: '18',
              title: 'ಏನು ಪದವೋ',
              audioUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2F5.mp3?alt=media&token=b61cb258-e983-4030-8526-9030758e33d2',
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2Fbhuvanadabhagya.jpg?alt=media&token=b6335156-54c4-495f-806b-5504beb6b0e6',
              lyrics: '',
              category: 'BhuvanadaBhagya'),
          AudioEntity(
              id: '19',
              title: 'ಪಾಹಿ ಪಾಹಿ',
              audioUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2F6.mp3?alt=media&token=b61cb258-e983-4030-8526-9030758e33d2',
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2Fbhuvanadabhagya.jpg?alt=media&token=b6335156-54c4-495f-806b-5504beb6b0e6',
              lyrics: '',
              category: 'BhuvanadaBhagya'),
          AudioEntity(
              id: '20',
              title: 'ಸಾಯಿ ಬಾಬಾ ಸಾಯಿ ಬಾಬಾ',
              audioUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2F7.mp3?alt=media&token=b61cb258-e983-4030-8526-9030758e33d2',
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2Fbhuvanadabhagya.jpg?alt=media&token=b6335156-54c4-495f-806b-5504beb6b0e6',
              lyrics: '',
              category: 'BhuvanadaBhagya'),
          AudioEntity(
              id: '21',
              title: 'ಸಾಯಿ ಎನ್ನಿರೋ',
              audioUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2F8.mp3?alt=media&token=b61cb258-e983-4030-8526-9030758e33d2',
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2Fbhuvanadabhagya.jpg?alt=media&token=b6335156-54c4-495f-806b-5504beb6b0e6',
              lyrics: '',
              category: 'BhuvanadaBhagya'),
          AudioEntity(
              id: '22',
              title: 'ಶ್ರೀ ಸಾಯಿ ನಿನ್ನ ನಂಬಿದೆ',
              audioUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2F9.mp3?alt=media&token=b61cb258-e983-4030-8526-9030758e33d2',
              imageUrl:
                  'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2Fbhuvanadabhagya.jpg?alt=media&token=b6335156-54c4-495f-806b-5504beb6b0e6',
              lyrics: '',
              category: 'BhuvanadaBhagya'),
        ],
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Categories'),
        centerTitle: true,
      ),
      body: GradientBackground(
        child: Column(
          children: [
            const SizedBox(
              height: 16.0,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AudioListPage(category: category),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5,
                                offset: Offset(2, 2))
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Hero(
                                tag: 'category-image-${category.id}',
                                child: CachedNetworkImage(
                                  imageUrl: category.imageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black
                                          .withAlpha((0.6 * 255).toInt()),
                                      Colors.transparent
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 10,
                                child: Text(
                                  category.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
