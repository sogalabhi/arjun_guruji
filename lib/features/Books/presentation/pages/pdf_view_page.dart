import 'dart:io';
import 'package:arjun_guruji/features/Books/domain/entity/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:arjun_guruji/features/Books/data/model/book_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class PDFViewerPage extends StatefulWidget {
  final Book book;

  const PDFViewerPage({super.key, required this.book});

  @override
  PdfViewerPageState createState() => PdfViewerPageState();
}

class PdfViewerPageState extends State<PDFViewerPage> {
  String? localFilePath;
  int _totalPages = 0;
  int _currentPage = 0;
  PDFViewController? _pdfController;
  final TextEditingController _jumpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    showOrStreamPDF();
  }

  @override
  void dispose() {
    _jumpController.dispose();
    super.dispose();
  }

  /// ✅ Generates a unique, safe filename from the book title
  String getFileName() {
    final safeTitle =
        widget.book.title.replaceAll(RegExp(r'[^A-Za-z0-9_]'), '_');
    return "${safeTitle}.pdf";
  }

  /// ✅ Checks if the file already exists. If yes, loads it. If no, downloads it.
  Future<void> showOrStreamPDF() async {
    if (widget.book.pdfFilePath != null &&
        await File(widget.book.pdfFilePath!).exists()) {
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
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Turn on internet to download the PDF.'),
              duration: Duration(seconds: 4),
            ),
          );
        }
        return;
      }
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
          : Column(
              children: [
                // Horizontal slider and controls at the top
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Slider(
                          min: 0,
                          max: (_totalPages > 0)
                              ? (_totalPages - 1).toDouble()
                              : 1,
                          value: _currentPage.toDouble().clamp(
                              0,
                              (_totalPages > 0 ? _totalPages - 1 : 1)
                                  .toDouble()),
                          onChanged: (value) {
                            if (_pdfController != null) {
                              _pdfController!.setPage(value.toInt());
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_currentPage + 1} / ${_totalPages > 0 ? _totalPages : "-"}',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 48,
                        child: TextField(
                          controller: _jumpController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Pg',
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 4),
                          ),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 4),
                      ElevatedButton(
                        onPressed: () {
                          final page = int.tryParse(_jumpController.text);
                          if (page != null &&
                              page > 0 &&
                              page <= _totalPages &&
                              _pdfController != null) {
                            _pdfController!.setPage(page - 1);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(40, 28),
                            padding: EdgeInsets.zero),
                        child: const Text('Go', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ),
                // PDF view
                Expanded(
                  child: PDFView(
                    filePath: localFilePath!,
                    enableSwipe: true,
                    swipeHorizontal: false,
                    autoSpacing: true,
                    pageFling: true,
                    onRender: (pages) {
                      setState(() {
                        _totalPages = pages ?? 0;
                      });
                    },
                    onViewCreated: (controller) {
                      _pdfController = controller;
                    },
                    onPageChanged: (page, total) {
                      setState(() {
                        _currentPage = page ?? 0;
                        _totalPages = total ?? _totalPages;
                      });
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
