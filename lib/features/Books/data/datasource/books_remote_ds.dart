import 'package:arjun_guruji/features/Books/data/model/book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BooksRemoteDataSource {
  Future<List<BookModel>> fetchAllBooks();
  Future<List<BookModel>> fetchBookSummaries();
  Future<BookModel?> fetchBookDetailsByTitle(String title);
  Future<List<Map<String, dynamic>>> fetchBookTimestamps();
}

class BooksRemoteDataSourceImpl implements BooksRemoteDataSource {
  final FirebaseFirestore firestore;
  BooksRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<BookModel>> fetchAllBooks() async {
    final bookCollection = firestore.collection('Books');
    final querySnapshot = await bookCollection.get();
    var books = querySnapshot.docs
        .map((doc) {
          final data = doc.data();
          final lastUpdated = data['lastUpdated'];
          return BookModel.fromJson({
            ...data,
            'lastUpdated': lastUpdated is Timestamp ? lastUpdated.toDate() : null,
            'pdfFilePath': null,
            'imageBytes': null,
          });
        })
        .toList();
    return books;
  }

  @override
  Future<List<BookModel>> fetchBookSummaries() async {
    final bookCollection = firestore.collection('Books');
    final querySnapshot = await bookCollection.get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      final lastUpdated = data['lastUpdated'];
      return BookModel(
        title: data['title'] ?? '',
        imageUrl: data['imageUrl'] ?? '',
        bookType: data['bookType'] ?? '',
        htmlContent: null,
        pdfUrl: null,
        chapters: null,
        pdfFilePath: null,
        imageBytes: null,
        lastUpdated: lastUpdated is Timestamp ? lastUpdated.toDate() : null,
      );
    }).toList();
  }

  @override
  Future<BookModel?> fetchBookDetailsByTitle(String title) async {
    final bookCollection = firestore.collection('Books');
    final querySnapshot =
        await bookCollection.where('title', isEqualTo: title).limit(1).get();
    if (querySnapshot.docs.isNotEmpty) {
      final data = querySnapshot.docs.first.data();
      final lastUpdated = data['lastUpdated'];
      return BookModel.fromJson({
        ...data,
        'lastUpdated': lastUpdated is Timestamp ? lastUpdated.toDate() : null,
        'pdfFilePath': null,
        'imageBytes': null,
      });
    }
    return null;
  }

  @override
  Future<List<Map<String, dynamic>>> fetchBookTimestamps() async {
    final bookCollection = firestore.collection('Books');
    final querySnapshot = await bookCollection.get();
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
