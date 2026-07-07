import 'dart:io';
import 'package:arjun_guruji/features/Books/domain/entity/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:arjun_guruji/features/Books/data/datasource/books_local_ds.dart';
import 'package:arjun_guruji/injection_container.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class PDFViewerPage extends StatefulWidget {
  final Book book;

  const PDFViewerPage({super.key, required this.book});

  @override
  PdfViewerPageState createState() => PdfViewerPageState();
}

class PdfViewerPageState extends State<PDFViewerPage> {
  String? localFilePath;
  String? _errorMessage;
  int _totalPages = 0;
  int _currentPage = 0;
  PDFViewController? _pdfController;
  final TextEditingController _jumpController = TextEditingController();
  double _downloadProgress = 0.0;
  bool _isDownloading = false;

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
    return "$safeTitle.pdf";
  }

  /// ✅ Checks if the file already exists. If yes, loads it. If no, downloads it.
  Future<void> showOrStreamPDF() async {
    try {
      if (widget.book.pdfFilePath != null &&
          await File(widget.book.pdfFilePath!).exists()) {
        debugPrint('[PDF] Using local file: ${widget.book.pdfFilePath}');
        setState(() {
          localFilePath = widget.book.pdfFilePath;
          _errorMessage = null;
        });
      } else if (widget.book.pdfUrl != null && widget.book.pdfUrl!.isNotEmpty) {
        final dir = await getApplicationDocumentsDirectory();
        final filePath = '${dir.path}/${getFileName()}';
        if (await File(filePath).exists()) {
          debugPrint('[PDF] Found local file: $filePath');
          setState(() {
            localFilePath = filePath;
            _errorMessage = null;
          });
          await sl<BooksLocalDataSource>().updatePdfFilePath(widget.book.title, filePath);
        } else {
          debugPrint('[PDF] Downloading from remote URL: ${widget.book.pdfUrl}');
          setState(() {
            localFilePath = null;
            _errorMessage = null;
          });
          await downloadAndSavePDF(filePath);
        }
      } else {
        debugPrint('[PDF] No local file or remote URL available for this book.');
        setState(() => _errorMessage = 'No PDF URL available for this book.');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Error initializing PDF viewer: $e');
    }
  }

  Future<void> downloadAndSavePDF(String filePath) async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      final isOffline = connectivityResult.isEmpty || connectivityResult.first == ConnectivityResult.none;
      if (isOffline) {
        setState(() => _errorMessage = 'No internet connection. Please connect to download the PDF.');
        return;
      }
      if (widget.book.pdfUrl != null && widget.book.pdfUrl!.isNotEmpty) {
        setState(() {
          _isDownloading = true;
          _downloadProgress = 0.0;
        });
        await Dio().download(
          widget.book.pdfUrl!,
          filePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              setState(() {
                _downloadProgress = received / total;
              });
            }
          },
        );
        debugPrint('[PDF] Downloaded and saved to: $filePath');
        setState(() {
          localFilePath = filePath;
          _errorMessage = null;
          _isDownloading = false;
        });
        await sl<BooksLocalDataSource>().updatePdfFilePath(widget.book.title, filePath);
      } else {
        debugPrint('[PDF] Error: Book PDF URL is null');
        throw Exception("Book PDF URL is null");
      }
    } catch (e) {
      debugPrint('[PDF] Error downloading PDF: $e');
      setState(() => _errorMessage = 'Failed to download PDF. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
      ),
      body: _errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: Colors.red,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _errorMessage = null;
                          localFilePath = null;
                        });
                        showOrStreamPDF();
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Try Again'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : localFilePath == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 20),
                      Text(
                        _isDownloading
                            ? "Downloading PDF: ${(_downloadProgress * 100).toStringAsFixed(0)}%"
                            : "Loading PDF...",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      if (_isDownloading) ...[
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 48),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: _downloadProgress,
                              minHeight: 6,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                )
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
