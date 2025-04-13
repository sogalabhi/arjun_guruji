class Lyrics {
  final String docId;
  final String title;
  final String category;
  final String? content;

  Lyrics({
    required this.docId,
    required this.title,
    required this.category,
    this.content,
  });
}
