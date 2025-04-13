import 'package:arjun_guruji/features/Lyrics/data/model/lyrics_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class LyricsRemoteDataSource {
  Future<List<LyricsModel>> fetchAllLyrics();
}

class LyricsRemoteDataSourceImpl implements LyricsRemoteDataSource {
  final FirebaseFirestore firestore;

  LyricsRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<LyricsModel>> fetchAllLyrics() async {
    final lyricsCollection = firestore.collection('Lyrics');
    final querySnapshot = await lyricsCollection.get();

    var lyrics = querySnapshot.docs.map((doc) {
      var data = doc.data();
      return LyricsModel.fromJson({
        'docId': doc.id, // Include document ID
        'category': data['category'] ?? 'Unknown',
        'content': data['content'] ?? '',
        'title': data['title'] ?? 'Untitled',
      });
    }).toList();

    return lyrics;
  }
}
