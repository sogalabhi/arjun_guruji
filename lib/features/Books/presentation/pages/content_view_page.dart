import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';

class ContentViewPage extends StatefulWidget {
  final String title;
  final String? chapterName;
  final String content;
  const ContentViewPage(
      {Key? key, required this.title, required this.content, this.chapterName})
      : super(key: key);

  @override
  ContentViewPageState createState() => ContentViewPageState();
}

class ContentViewPageState extends State<ContentViewPage> {
  double _fontSize = 16.0;
  bool _isDarkMode = false;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: GoogleFonts.poppins(
            color: _isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: _isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: _isDarkMode ? Colors.white : Colors.black,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search,
                color: _isDarkMode ? Colors.white : Colors.black),
            onPressed: _showSearchDialog,
          ),
          IconButton(
            icon: Icon(Icons.more_vert,
                color: _isDarkMode ? Colors.white : Colors.black),
            onPressed: _showSettingsSheet,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Html(
            data: _searchQuery.isEmpty
                ? widget.content
                : widget.content.replaceAll(
                    RegExp(_searchQuery, caseSensitive: false),
                    '<mark>$_searchQuery</mark>'),
            style: {
              "body": Style(
                fontSize: FontSize(_fontSize),
                color: _isDarkMode ? Colors.white : Colors.black,
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
              "mark": Style(
                backgroundColor: Colors.yellow,
                color: _isDarkMode ? Colors.black : Colors.black,
              ),
            },
          ),
        ),
      ),
    );
  }

  // 🔍 Search Dialog
  void _showSearchDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: _isDarkMode ? Colors.grey[900] : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Search",
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Enter text...",
                  filled: true,
                  fillColor: _isDarkMode ? Colors.grey[800] : Colors.grey[200],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  setState(() {
                    _searchQuery = _searchController.text;
                  });
                  Navigator.pop(context);
                  _scrollToSearchQuery();
                },
                child: const Text("Search"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _scrollToSearchQuery() {
    final content = widget.content;
    final index = content.toLowerCase().indexOf(_searchQuery.toLowerCase());
    if (index != -1) {
      final textBefore = content.substring(0, index);
      final linesBefore = textBefore.split('\n').length;
      final offset = linesBefore * _fontSize * 1.5; // Approximate line height
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // ⚙️ Settings Bottom Sheet
  void _showSettingsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: _isDarkMode ? Colors.grey[900] : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Settings",
                  style: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              // 🔠 Font Size Adjuster
              ListTile(
                title: Text("Font Size", style: GoogleFonts.poppins()),
                subtitle: Slider(
                  min: 12,
                  max: 24,
                  value: _fontSize,
                  activeColor: Colors.blue,
                  onChanged: (value) {
                    setState(() {
                      _fontSize = value;
                    });
                  },
                ),
              ),
              // 🌗 Dark Mode Toggle
              SwitchListTile(
                title: Text("Dark Mode", style: GoogleFonts.poppins()),
                value: _isDarkMode,
                activeColor: Colors.blue,
                onChanged: (value) {
                  setState(() {
                    _isDarkMode = value;
                  });
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
