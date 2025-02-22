class Book {
  final String title;
  final String imageUrl;
  final String bookType;
  final String? content;
  final List<Map<String, dynamic>>? chapters;

  Book({
    required this.title,
    required this.imageUrl,
    required this.bookType,
    this.content,
    this.chapters,
  });
}
