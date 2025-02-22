import 'package:arjun_guruji/features/Books/domain/entity/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';

class ContentViewPage extends StatefulWidget {
  final Book book;

  const ContentViewPage({Key? key, required this.book}) : super(key: key);

  @override
  ContentViewPageState createState() => ContentViewPageState();
}

class ContentViewPageState extends State<ContentViewPage> {
  double _fontSize = 16.0;
  bool _isDarkMode = false;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text(
          widget.book.title,
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
          child: Html(
            data: _searchQuery.isEmpty
                ? widget.book.content
                : widget.book.content?.replaceAll(
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
                },
                child: const Text("Search"),
              ),
            ],
          ),
        );
      },
    );
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
