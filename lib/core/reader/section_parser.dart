import 'dart:convert' show HtmlEscape;
import 'dart:math' show max;

import 'package:html/parser.dart' show parseFragment;

class ReaderSection {
  /// 1-based position in the book; identifies the section.
  final int number;

  /// Number readers see. In a book that types its own numbers ("10.",
  /// "೧೦.") this is the printed number, so it matches the paper copy, and
  /// pieces without one (an opening prayer, a preface) have none. Otherwise
  /// it is the position.
  final int? label;

  /// Plain-text name used in the index, bar and bubble.
  final String title;

  /// Inner HTML of the opening heading, if the piece has one.
  final String? headingHtml;
  final String bodyHtml;

  /// Characters in the raw piece; used to weight progress segments.
  final int length;

  const ReaderSection({
    required this.number,
    required this.label,
    required this.title,
    required this.headingHtml,
    required this.bodyHtml,
    required this.length,
  });
}

extension ReaderSectionList on List<ReaderSection> {
  /// Highest number shown, for "10 of 33".
  int get lastLabel => fold(0, (m, s) => max(m, s.label ?? 0));

  /// Index of the first section showing [label], or null.
  int? indexOfLabel(int label) {
    final i = indexWhere((s) => s.label == label);
    return i < 0 ? null : i;
  }

  /// The section's number, or where an unnumbered piece sits:
  /// "Before 1" for front matter, "After 33" for anything later.
  String placeOf(int index) {
    final own = this[index].label;
    if (own != null) return '$own';
    for (var i = index - 1; i >= 0; i--) {
      final l = this[i].label;
      if (l != null) return 'After $l';
    }
    final next = skip(index)
        .firstWhere((s) => s.label != null, orElse: () => this[index]);
    return 'Before ${next.label ?? 1}';
  }
}

final _hrSplit = RegExp(r'<hr\s*/?>', caseSensitive: false);
final _openingHeading =
    RegExp(r'^<(h3|h4)[^>]*>([\s\S]*?)</\1>', caseSensitive: false);
final _openingP = RegExp(r'^<p[^>]*>([\s\S]*?)</p>', caseSensitive: false);
final _firstLine =
    RegExp(r'<p[^>]*>([\s\S]*?)(?:<br\s*/?>|</p>)', caseSensitive: false);
final _brTag = RegExp(r'<br', caseSensitive: false);
final _separators = RegExp(r'[|।॥]+');
final _spaces = RegExp(r'\s+');
final _edgeDashes = RegExp(r'^[-–\s]+|[-–\s]+$');
final _typedNumber = RegExp(r'^\s*([0-9೦-೯]+)\s*[.)]\s*');

/// Splits a book at each `<hr>`. A section is named by its opening `<h3>`
/// or `<h4>`, else a one-line opening `<p>`, else the first line of its first
/// `<p>`. When most names start with a typed number, those numbers become
/// the section numbers.
List<ReaderSection> parseSections(String html) {
  final pieces = html
      .split(_hrSplit)
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .toList();

  return _number(
      pieces.map(_draft).toList(), [for (final p in pieces) p.length]);
}

/// A book stored as a list of chapters: each chapter is one section, named
/// by its chapter name. A heading at the top of the content that repeats the
/// name is dropped. Printed numbers work as in [parseSections].
List<ReaderSection> parseChapters(
    List<({String name, String content})> chapters) {
  final drafts = <_Draft>[];
  for (final c in chapters) {
    var body = c.content.trim();
    final name = c.name.trim();
    final h = _openingHeading.firstMatch(body);
    if (h != null && _cleanTitle(h.group(2)!) == _cleanTitle(name)) {
      body = body.substring(h.group(0)!.length);
    }
    final title = _cleanTitle(name);
    drafts.add(name.isEmpty
        ? _draft(body)
        : _Draft(title, const HtmlEscape().convert(name), body));
  }
  return _number(drafts, [for (final c in chapters) c.content.length]);
}

List<ReaderSection> _number(List<_Draft> drafts, List<int> lengths) {
  final printed =
      drafts.where((d) => d.typed != null).length * 2 > drafts.length;

  final sections = <ReaderSection>[];
  for (var i = 0; i < drafts.length; i++) {
    final d = drafts[i];
    final number = i + 1;
    final typed = printed ? d.typed : null;
    var title = d.title;
    var headingHtml = d.headingHtml;
    if (typed != null) {
      title = title.replaceFirst(_typedNumber, '');
      if (headingHtml != null && _typedNumber.hasMatch(headingHtml)) {
        headingHtml = headingHtml.replaceFirst(_typedNumber, '');
      }
    }
    sections.add(ReaderSection(
      number: number,
      label: printed ? typed : number,
      title: title.isEmpty ? 'Section ${typed ?? number}' : title,
      headingHtml: headingHtml,
      bodyHtml: d.bodyHtml,
      length: lengths[i],
    ));
  }
  return sections;
}

class _Draft {
  final String title;
  final String? headingHtml;
  final String bodyHtml;
  final int? typed;

  _Draft(this.title, this.headingHtml, this.bodyHtml)
      : typed = _parseTyped(title);
}

_Draft _draft(String piece) {
  final h = _openingHeading.firstMatch(piece);
  if (h != null) {
    return _Draft(_cleanTitle(h.group(2)!), h.group(2),
        piece.substring(h.group(0)!.length));
  }
  final p = _openingP.firstMatch(piece);
  if (p != null &&
      !_brTag.hasMatch(p.group(1)!) &&
      piece.length > p.group(0)!.length + 20) {
    return _Draft(_cleanTitle(p.group(1)!), p.group(1),
        piece.substring(p.group(0)!.length));
  }
  final first = _firstLine.firstMatch(piece);
  return _Draft(_cleanTitle(first?.group(1) ?? ''), null, piece);
}

int? _parseTyped(String title) {
  final m = _typedNumber.firstMatch(title);
  if (m == null) return null;
  // Kannada digits ೦-೯ sit at U+0CE6..U+0CEF.
  final digits = m.group(1)!.replaceAllMapped(
      RegExp('[೦-೯]'), (d) => '${d.group(0)!.codeUnitAt(0) - 0x0CE6}');
  return int.tryParse(digits);
}

String _cleanTitle(String html) => parseFragment(html)
    .text!
    .replaceAll(_separators, ' ')
    .replaceAll(_spaces, ' ')
    .trim()
    .replaceAll(_edgeDashes, '');
