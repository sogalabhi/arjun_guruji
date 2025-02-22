import 'package:arjun_guruji/features/Books/data/model/book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BooksRemoteDataSource {
  Future<List<BookModel>> fetchAllBooks();
}

class BooksRemoteDataSourceImpl implements BooksRemoteDataSource {
  final FirebaseFirestore firestore;
  BooksRemoteDataSourceImpl({required this.firestore});
  @override
  Future<List<BookModel>> fetchAllBooks() async {
    final bookCollection = firestore.collection('Books');
    final querySnapshot = await bookCollection.get();
    var books = querySnapshot.docs
        .map((doc) => BookModel.fromJson(doc.data()))
        .toList();
    return books;
  }
}
