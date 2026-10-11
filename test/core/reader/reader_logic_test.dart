import 'dart:io';

import 'package:arjun_guruji/core/reader/reader_position.dart';
import 'package:arjun_guruji/core/reader/reader_search.dart';
import 'package:arjun_guruji/core/reader/section_parser.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

class _FakeBox implements Box {
  final Map<dynamic, dynamic> data = {};

  @override
  dynamic get(dynamic key, {dynamic defaultValue}) =>
      data.containsKey(key) ? data[key] : defaultValue;

  @override
  Future<void> put(dynamic key, dynamic value) async => data[key] = value;

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(invocation.memberName.toString());
}

void main() {
  final book = File('test/fixtures/sample_book.html').readAsStringSync();

  group('highlightMatches', () {
    test('wraps text, never markup', () {
      const html = '<p class="p">a p tag with <b>p</b> and class</p>';
      final out = highlightMatches(html, 'p');
      expect(out, contains('<p class="p">'));
      expect(out, contains('<b><mark>p</mark></b>'));
      expect(out, contains('a <mark>p</mark> tag'));
      // The tag names and the class attribute are untouched.
      expect(out, isNot(contains('<<mark>')));
      expect(out, isNot(contains('class="<mark>')));
    });

    test('is case-insensitive and keeps the original casing', () {
      expect(highlightMatches('<p>Rama rAMA</p>', 'rama'),
          '<p><mark>Rama</mark> <mark>rAMA</mark></p>');
    });

    test('a space in the query also matches a line break', () {
      expect(highlightMatches('<p>one\ntwo</p>', 'one two'),
          '<p><mark>one\ntwo</mark></p>');
    });

    test('empty query changes nothing; entities stay valid', () {
      expect(highlightMatches('<p>a &amp; b</p>', ''), '<p>a &amp; b</p>');
      expect(highlightMatches('<p>a &amp; b</p>', 'b'),
          '<p>a &amp; <mark>b</mark></p>');
    });
  });

  group('ReaderSearchIndex', () {
    final index = ReaderSearchIndex(parseSections(book));

    test('finds the section whose heading has the word', () {
      final hits = index.search('ಗುರ್ವಷ್ಟಕಮ್');
      expect(hits.map((h) => h.index), contains(4));
      final hit = hits.firstWhere((h) => h.index == 4);
      expect(hit.match, 'ಗುರ್ವಷ್ಟಕಮ್');
    });

    test('one hit per section, in order; nothing for blank or absent', () {
      final hits = index.search('ಗುರು');
      expect(hits.length, greaterThan(3));
      final indexes = hits.map((h) => h.index).toList();
      expect(indexes, [...indexes]..sort());
      expect(indexes.toSet().length, indexes.length);
      expect(index.search('   '), isEmpty);
      expect(index.search('zzzz-not-in-book'), isEmpty);
    });
  });

  group('SectionWeights', () {
    final sections = parseSections(book);
    final weights = SectionWeights.of(sections);

    test('fraction and position are inverses', () {
      for (final p in const [
        ReaderPosition(0, 0),
        ReaderPosition(3, 0.5),
        ReaderPosition(28, 1),
      ]) {
        final back = weights.positionAt(weights.fractionOf(p));
        expect(back.index, p.index);
        expect(back.r, closeTo(p.r, 1e-9));
      }
    });

    test('ends of the book', () {
      expect(weights.positionAt(0), const ReaderPosition(0, 0));
      expect(weights.positionAt(1), const ReaderPosition(28, 1));
    });

    test('short sections still get a minimum weight', () {
      final tiny = parseSections('<p>a<br>b</p><hr><p>c<br>d</p>');
      expect(SectionWeights.of(tiny).weights, [400, 400]);
    });
  });

  group('ReaderPositionStore', () {
    final sections = parseSections(book);

    test('round trips', () {
      final box = _FakeBox();
      final store = ReaderPositionStore(box, kind: 'book', title: 'T');
      store.save(sections, const ReaderPosition(13, 0.4));
      expect(box.data.keys.single, 'pos:book:T');
      expect(store.restore(sections), const ReaderPosition(13, 0.4));
    });

    test('same title wins when the index moved; else clamped', () {
      final box = _FakeBox();
      final store = ReaderPositionStore(box, kind: 'book', title: 'T');
      box.data['pos:book:T'] = {
        'index': 2,
        'title': sections[10].title,
        'r': 0.25
      };
      expect(store.restore(sections), const ReaderPosition(10, 0.25));
      box.data['pos:book:T'] = {'index': 99, 'title': 'gone', 'r': 0.25};
      expect(store.restore(sections), const ReaderPosition(28, 0.25));
    });

    test('nothing for a single section, no box, or junk', () {
      final one = parseSections('<p>a<br>b</p>');
      final box = _FakeBox();
      ReaderPositionStore(box, kind: 'k', title: 't')
          .save(one, const ReaderPosition(0, 0.5));
      expect(
          ReaderPositionStore(box, kind: 'k', title: 't').restore(one), isNull);
      expect(ReaderPositionStore(null, kind: 'k', title: 't').restore(sections),
          isNull);
      box.data['pos:k:t'] = 'junk';
      expect(ReaderPositionStore(box, kind: 'k', title: 't').restore(sections),
          isNull);
    });
  });
}
