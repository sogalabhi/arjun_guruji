import 'dart:io';
import 'package:arjun_guruji/features/Books/domain/entity/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class PDFViewerPage extends StatefulWidget {
  final Book book;

  const PDFViewerPage({Key? key, required this.book}) : super(key: key);

  @override
  PdfViewerPageState createState() => PdfViewerPageState();
}

class PdfViewerPageState extends State<PDFViewerPage> {
  String? localFilePath;

  @override
  void initState() {
    super.initState();
    checkAndLoadPDF();
  }

  /// ✅ Generates a safe filename from the book title
  String getFileName() {
    return "${widget.book.title.replaceAll(RegExp(r'[^\w\s]'), '').replaceAll(' ', '_')}.pdf";
  }

  /// ✅ Checks if the file already exists. If yes, loads it. If no, downloads it.
  Future<void> checkAndLoadPDF() async {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/${getFileName()}';

    if (await File(filePath).exists()) {
      // File already exists, load from storage
      setState(() => localFilePath = filePath);
    } else {
      // File doesn't exist, download and save
      await downloadAndSavePDF(filePath);
    }
  }

  /// ✅ Downloads PDF and saves it in internal storage
  Future<void> downloadAndSavePDF(String filePath) async {
    try {
      if (widget.book.content != null) {
        await Dio().download(widget.book.content!, filePath);
      } else {
        throw Exception("Book content URL is null");
      }
      setState(() => localFilePath = filePath);
      print("PDF saved at: $filePath");
    } catch (e) {
      print("Error downloading PDF: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.book.title)),
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
