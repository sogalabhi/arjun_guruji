import 'dart:io';
import 'dart:typed_data';
import 'package:arjun_guruji/features/Books/domain/entity/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:arjun_guruji/features/Books/data/model/book_model.dart';

class PDFViewerPage extends StatefulWidget {
  final Book book;

  const PDFViewerPage({super.key, required this.book});

  @override
  PdfViewerPageState createState() => PdfViewerPageState();
}

class PdfViewerPageState extends State<PDFViewerPage> {
  String? localFilePath;

  @override
  void initState() {
    super.initState();
    showOrStreamPDF();
  }

  /// ✅ Generates a unique, safe filename from the book title
  String getFileName() {
    final safeTitle = widget.book.title
        .replaceAll(RegExp(r'[^A-Za-z0-9_]'), '_');
    return "${safeTitle}.pdf";
  }

  /// ✅ Checks if the file already exists. If yes, loads it. If no, downloads it.
  Future<void> showOrStreamPDF() async {
    if (widget.book.pdfFilePath != null && await File(widget.book.pdfFilePath!).exists()) {
      print('[PDF] Using local file: ' + widget.book.pdfFilePath!);
      setState(() => localFilePath = widget.book.pdfFilePath);
    } else if (widget.book.content != null) {
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/${getFileName()}';
      if (await File(filePath).exists()) {
        print('[PDF] Found local file: ' + filePath);
        setState(() => localFilePath = filePath);
        await _updateHivePdfFilePath(filePath);
      } else {
        print('[PDF] Downloading from remote URL: ' + widget.book.content!);
        setState(() => localFilePath = null); // Show loading spinner
        await downloadAndSavePDF(filePath);
      }
    } else {
      print('[PDF] No local file or remote URL available for this book.');
    }
  }

  /// ✅ Downloads PDF and saves it in internal storage
  Future<void> downloadAndSavePDF(String filePath) async {
    try {
      if (widget.book.content != null) {
        await Dio().download(widget.book.content!, filePath);
        print('[PDF] Downloaded and saved to: ' + filePath);
        setState(() => localFilePath = filePath);
        await _updateHivePdfFilePath(filePath);
      } else {
        print('[PDF] Error: Book content URL is null');
        throw Exception("Book content URL is null");
      }
    } catch (e) {
      print('[PDF] Error downloading PDF: $e');
    }
  }

  Future<void> _updateHivePdfFilePath(String filePath) async {
    final box = Hive.box<BookModel>('booksBox');
    final bookModel = box.get(widget.book.title);
    if (bookModel != null) {
      final updatedBook = BookModel(
        title: bookModel.title,
        imageUrl: bookModel.imageUrl,
        bookType: bookModel.bookType,
        content: bookModel.content,
        chapters: bookModel.chapters,
        pdfFilePath: filePath,
        imageBytes: bookModel.imageBytes,
      );
      await box.put(widget.book.title, updatedBook);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
      ),
      body: localFilePath == null
          ? const Center(child: CircularProgressIndicator())
          : PDFView(
              filePath: localFilePath!,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: true,
              pageFling: true,
            ),
    );
  }
}
