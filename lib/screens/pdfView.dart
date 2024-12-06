import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

import '../customwidgets/Heading.dart';

class pdfView extends StatefulWidget {
  pdfView({super.key, required this.fileurl, required this.name});
  String fileurl, name;
  @override
  State<pdfView> createState() => _pdfViewState();
}

class _pdfViewState extends State<pdfView> {
  Map heading = {};

  late PdfControllerPinch pdfControllerPinch;
  int totalPageCount = 0, currentPageCount = 1;

  @override
  void initState() {
    super.initState();

    pdfControllerPinch = PdfControllerPinch(
        document: PdfDocument.openAsset(widget.fileurl));
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   pdfControllerPinch = PdfControllerPinch(
    //       document: PdfDocument.openAsset("raw/arjunamruthadhare.pdf"));
    // });

      // heading = (ModalRoute.of(context)!.settings.arguments as Map?)!;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Heading(widget.name, 1),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: _bodyUI(),
      ),
    );
  }

  Widget _bodyUI() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text("Total Pages: $totalPageCount"),
            IconButton(onPressed: () {
              pdfControllerPinch.previousPage(duration: Duration(milliseconds: 250), curve: Curves.easeOut);

            }, icon: const Icon(Icons.arrow_back)),
            Text("Current Page: $currentPageCount"),
            IconButton(onPressed: () {
              pdfControllerPinch.nextPage(duration: Duration(milliseconds: 250), curve: Curves.easeIn);

            }, icon: const Icon(Icons.arrow_forward)),
          ],
        ),
        _pdfView(),
      ],
    );
  }

  Widget _pdfView() {
    return Expanded(
        child: PdfViewPinch(
      controller: pdfControllerPinch,
      onDocumentLoaded: (document) {
        setState(() {
          totalPageCount = document.pagesCount;
        });
      },
      onPageChanged: (page) => setState(() {
        currentPageCount = page;
      }),
    ));
  }
}
