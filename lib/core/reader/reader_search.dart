import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parseFragment;

import 'reading_palette.dart';
import 'section_parser.dart';

/// A match is always inside a single text node, so the same rule finds it in
/// the results list and highlights it in the page.
RegExp? _matcher(String query) {
  final words = query.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
  if (words.isEmpty) return null;
  // A space in the query also matches a line break in the text.
  return RegExp(words.map(RegExp.escape).join(r'\s+'),
      caseSensitive: false, unicode: true);
}

void _collectText(dom.Node node, List<String> out) {
  if (node is dom.Text) {
    if (node.data.trim().isNotEmpty) out.add(node.data);
  } else if (node is dom.Element &&
      (node.localName == 'script' || node.localName == 'style')) {
    return;
  } else {
    for (final child in node.nodes) {
      _collectText(child, out);
    }
  }
}

/// Wraps matches in `<mark>` by walking the DOM, never by touching markup.
String highlightMatches(String html, String query) {
  final matcher = _matcher(query);
  if (matcher == null) return html;
  final fragment = parseFragment(html);
  _highlight(fragment, matcher);
  return fragment.outerHtml;
}

void _highlight(dom.Node node, RegExp matcher) {
  if (node is dom.Element &&
      (node.localName == 'script' || node.localName == 'style')) {
    return;
  }
  // Copy first: replacing nodes changes the child list.
  for (final child in node.nodes.toList()) {
    if (child is dom.Text) {
      final text = child.data;
      final matches = matcher.allMatches(text).toList();
      if (matches.isEmpty) continue;
      var from = 0;
      final replacement = <dom.Node>[];
      for (final m in matches) {
        if (m.start > from) {
          replacement.add(dom.Text(text.substring(from, m.start)));
        }
        replacement.add(dom.Element.tag('mark')..append(dom.Text(m.group(0)!)));
        from = m.end;
      }
      if (from < text.length) replacement.add(dom.Text(text.substring(from)));
      final parent = child.parentNode!;
      for (final n in replacement) {
        parent.insertBefore(n, child);
      }
      child.remove();
    } else {
      _highlight(child, matcher);
    }
  }
}

class SearchHit {
  /// 0-based section index.
  final int index;
  final String before;
  final String match;
  final String after;
  const SearchHit(this.index, this.before, this.match, this.after);
}

/// Plain text per section, built once and searched on every keystroke.
class ReaderSearchIndex {
  final List<ReaderSection> sections;
  late final List<List<String>> _nodes = [
    for (final s in sections)
      () {
        final out = <String>[];
        _collectText(parseFragment('${s.headingHtml ?? ''}${s.bodyHtml}'), out);
        return out;
      }()
  ];

  ReaderSearchIndex(this.sections);

  List<SearchHit> search(String query) {
    final matcher = _matcher(query);
    if (matcher == null) return const [];
    final hits = <SearchHit>[];
    for (var i = 0; i < sections.length; i++) {
      for (final raw in _nodes[i]) {
        final text = raw.replaceAll(RegExp(r'\s+'), ' ').trim();
        final m = matcher.firstMatch(text);
        if (m == null) continue;
        final start = (m.start - 36).clamp(0, text.length);
        final end = (m.end + 48).clamp(0, text.length);
        hits.add(SearchHit(
          i,
          '${start > 0 ? '…' : ''}${text.substring(start, m.start)}',
          m.group(0)!,
          '${text.substring(m.end, end)}${end < text.length ? '…' : ''}',
        ));
        break;
      }
    }
    return hits;
  }
}

/// Bottom sheet: type a word, see which sections contain it, tap one.
/// Pops with the chosen query and section index.
class ReaderSearchSheet extends StatefulWidget {
  final ReaderSearchIndex index;
  final ReadingPalette palette;
  final String initialQuery;
  final bool numbered;
  final bool canClear;

  const ReaderSearchSheet({
    super.key,
    required this.index,
    required this.palette,
    required this.numbered,
    this.initialQuery = '',
    this.canClear = false,
  });

  @override
  State<ReaderSearchSheet> createState() => _ReaderSearchSheetState();
}

class ReaderSearchResult {
  final String query;
  final int? sectionIndex;
  const ReaderSearchResult(this.query, this.sectionIndex);
}

class _ReaderSearchSheetState extends State<ReaderSearchSheet> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialQuery);
  List<SearchHit> _hits = const [];

  @override
  void initState() {
    super.initState();
    _hits = widget.index.search(_controller.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.palette;
    final query = _controller.text.trim();
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.85,
      ),
      decoration: BoxDecoration(
        color: p.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(top: BorderSide(color: p.line)),
      ),
      padding: EdgeInsets.fromLTRB(
          16, 16, 16, 16 + MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Search',
              style: TextStyle(
                  fontFamily: 'poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: p.ink)),
          const SizedBox(height: 10),
          TextField(
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.search,
            cursorColor: p.accentLine,
            style: TextStyle(
                fontFamily: 'notosanskannada', fontSize: 20, color: p.ink),
            decoration: InputDecoration(
              hintText: 'Type a word',
              hintStyle: TextStyle(color: p.muted),
              filled: true,
              fillColor: p.surface,
              prefixIcon: Icon(Icons.search, color: p.ink),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: p.buttonEdge, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: p.accentLine, width: 2.5),
              ),
            ),
            onChanged: (value) =>
                setState(() => _hits = widget.index.search(value)),
          ),
          if (widget.canClear)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () =>
                    Navigator.pop(context, const ReaderSearchResult('', null)),
                style: TextButton.styleFrom(foregroundColor: p.accentLine),
                child: const Text('Clear highlights'),
              ),
            ),
          const SizedBox(height: 6),
          if (query.isNotEmpty && _hits.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text('No matches found.',
                  style: TextStyle(fontSize: 16, color: p.muted)),
            ),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _hits.length,
              separatorBuilder: (_, __) => Divider(height: 1, color: p.line),
              itemBuilder: (context, k) {
                final hit = _hits[k];
                final section = widget.index.sections[hit.index];
                return InkWell(
                  onTap: () => Navigator.pop(
                      context, ReaderSearchResult(query, hit.index)),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 68),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.numbered)
                            Text(
                                section.label == null
                                    ? section.title
                                    : '${section.label} · ${section.title}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'notosanskannada',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: p.accentLine)),
                          Text.rich(
                            TextSpan(children: [
                              TextSpan(text: hit.before),
                              TextSpan(
                                  text: hit.match,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      backgroundColor: p.accent,
                                      color: p.onAccent)),
                              TextSpan(text: hit.after),
                            ]),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: 'notosanskannada',
                                fontSize: 16,
                                height: 1.5,
                                color: p.ink),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
