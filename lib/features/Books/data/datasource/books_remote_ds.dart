import 'package:arjun_guruji/features/Books/data/model/book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BooksRemoteDataSource {
  Future<List<BookModel>> fetchAllBooks();
  Future<List<BookModel>> fetchBookSummaries();
  Future<BookModel?> fetchBookDetailsByTitle(String title);
}

class BooksRemoteDataSourceImpl implements BooksRemoteDataSource {
  final FirebaseFirestore firestore;
  BooksRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<BookModel>> fetchAllBooks() async {
    final bookCollection = firestore.collection('Books');
    final querySnapshot = await bookCollection.get();
    var books = querySnapshot.docs
        .map((doc) => BookModel.fromJson({
              ...doc.data(),
              'pdfFilePath': null,
              'imageBytes': null,
            }))
        .toList();
    return books;
  }

  @override
  Future<List<BookModel>> fetchBookSummaries() async {
    final bookCollection = firestore.collection('Books');
    final querySnapshot = await bookCollection.get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return BookModel(
        title: data['title'] ?? '',
        imageUrl: data['imageUrl'] ?? '',
        bookType: data['bookType'] ?? '',
        content: null, // Do not fetch content for summary
        chapters: null,
        pdfFilePath: null,
        imageBytes: null,
      );
    }).toList();
  }

  @override
  Future<BookModel?> fetchBookDetailsByTitle(String title) async {
    final bookCollection = firestore.collection('Books');
    final querySnapshot = await bookCollection.where('title', isEqualTo: title).limit(1).get();
    if (querySnapshot.docs.isNotEmpty) {
      return BookModel.fromJson({
        ...querySnapshot.docs.first.data(),
        'pdfFilePath': null,
        'imageBytes': null,
      });
    }
    return null;
  }
}
