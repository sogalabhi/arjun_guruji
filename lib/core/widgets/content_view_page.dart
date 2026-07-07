import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/Settings/presentation/pages/settings_page.dart';
import '../../features/Settings/presentation/bloc/settings_bloc.dart';
import '../../features/Settings/presentation/bloc/settings_event.dart';
import '../../features/Settings/presentation/bloc/settings_state.dart';

class ContentViewPage extends StatefulWidget {
  final String title;
  final String? chapterName;
  final String content;
  const ContentViewPage({
    super.key,
    required this.title,
    required this.content,
    this.chapterName,
  });

  @override
  ContentViewPageState createState() => ContentViewPageState();
}

class ContentViewPageState extends State<ContentViewPage> {
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final settings = state.settings;
        
        final isDarkMode = settings.readingTheme == 'dark';
        final isSepia = settings.readingTheme == 'sepia';

        Color backgroundColor;
        Color textColor;
        
        if (isDarkMode) {
          backgroundColor = Colors.black;
          textColor = Colors.white;
        } else if (isSepia) {
          backgroundColor = const Color(0xFFF4ECD8);
          textColor = const Color(0xFF5B4636);
        } else {
          backgroundColor = Colors.white;
          textColor = Colors.black;
        }

        final fontStyle = settings.fontStyle == 'serif' 
            ? 'notoserifkannada' 
            : 'notosanskannada';

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            title: Text(
              widget.title,
              style: TextStyle(
                color: textColor,
              ),
            ),
            backgroundColor: backgroundColor,
            elevation: 0,
            iconTheme: IconThemeData(
              color: textColor,
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.search, color: textColor),
                onPressed: () => _showSearchDialog(context, isDarkMode),
              ),
              IconButton(
                icon: Icon(Icons.settings, color: textColor),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                Expanded(
                  child: widget.content.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error, color: Colors.red, size: 40),
                              const SizedBox(height: 8),
                              const Text(
                                'Failed to load content',
                                style: TextStyle(color: Colors.red, fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () => setState(() {}),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          controller: _scrollController,
                          child: Html(
                            data: _searchQuery.isEmpty
                                ? widget.content
                                : widget.content.replaceAllMapped(
                                    RegExp(RegExp.escape(_searchQuery), caseSensitive: false),
                                    (match) => '<mark>${match.group(0)}</mark>'),
                            style: {
                              "body": Style(
                                fontSize: FontSize(settings.fontSize),
                                color: textColor,
                                lineHeight: const LineHeight(1.5),
                                fontFamily: fontStyle,
                              ),
                              "mark": Style(
                                backgroundColor: Colors.yellow,
                                color: Colors.black,
                              ),
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 🔍 Search Dialog
  void _showSearchDialog(BuildContext context, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[900] : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Search",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 10),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Enter text...",
                  filled: true,
                  fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                ),
                onPressed: () {
                  setState(() {
                    _searchQuery = _searchController.text;
                  });
                  Navigator.pop(context);
                  _scrollToSearchQuery();
                },
                child: const Text("Search",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
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
      final currentFontSize = context.read<SettingsBloc>().state.settings.fontSize;
      final offset = linesBefore * currentFontSize * 1.5; // Approximate line height
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
