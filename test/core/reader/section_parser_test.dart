import 'dart:io';

import 'package:arjun_guruji/core/reader/section_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final book = File('test/fixtures/sample_book.html').readAsStringSync();

  group('parseSections', () {
    test('sample book splits into 29 numbered sections', () {
      final sections = parseSections(book);
      expect(sections.length, 29);
      expect(sections.map((s) => s.number), List.generate(29, (i) => i + 1));
    });

    test('spot-check titles', () {
      final sections = parseSections(book);
      expect(sections[0].title, 'ಶ್ರೀ ಗುರುಭ್ಯೋ ನಮ:');
      expect(sections[3].title, 'ಗುರು ಪಾದುಕಾ ಸ್ತೋತ್ರಂ');
      expect(sections[4].title, 'ಗುರ್ವಷ್ಟಕಮ್');
      expect(sections[14].title, 'ರಾಮ ಬಂದ ಶ್ಯಾಮ ಬಂದ ಶಿವನೇ');
      expect(sections[25].title, 'ವಿಬುಧಕೀರ್ತಿತಂ');
      expect(sections[28].title, 'ಮಂಗಳ');
    });

    test('opening h3 becomes the heading and is removed from the body', () {
      final s = parseSections('<h3>|| Name ||</h3><p>one</p><hr><p>two</p>');
      expect(s.length, 2);
      expect(s[0].headingHtml, '|| Name ||');
      expect(s[0].title, 'Name');
      expect(s[0].bodyHtml, '<p>one</p>');
      expect(s[1].headingHtml, isNull);
    });

    test('one-line opening p is the heading when enough content follows', () {
      final s = parseSections(
          '<p>A heading</p><p>Some body text that is long enough.</p>');
      expect(s.single.headingHtml, 'A heading');
      expect(s.single.title, 'A heading');
    });

    test('without a heading the first line of the first p is the title', () {
      final s = parseSections('<p>First line<br>Second line</p>');
      expect(s.single.headingHtml, isNull);
      expect(s.single.title, 'First line');
      expect(s.single.bodyHtml, '<p>First line<br>Second line</p>');
    });

    test('hr variants split case-insensitively and empty pieces drop', () {
      final s = parseSections('<p>a</p><HR/><p>b</p><hr /><hr>  <p>c</p>');
      expect(s.length, 3);
    });

    test('entities are decoded and edge dashes trimmed', () {
      final s = parseSections('<h3> - Rama &amp; Sita – </h3><p>x</p>');
      expect(s.single.title, 'Rama & Sita');
    });

    test('falls back to Section n', () {
      final s = parseSections('<div>no paragraphs</div>');
      expect(s.single.title, 'Section 1');
    });

    test('html without hr is one section; empty string is none', () {
      expect(parseSections('<p>one<br>two</p>').length, 1);
      expect(parseSections(''), isEmpty);
    });
  });

  group('printed numbers', () {
    // Shaped like the real song books: an opening prayer, titles 1-9 in <h4>
    // and 10 onwards in a one-line <p>.
    String printedBook({String closing = ''}) {
      final b = StringBuffer(
          '<h3>|| ಪ್ರಾರ್ಥನೆ ||</h3><p>prayer one<br>prayer two</p>');
      for (var n = 1; n <= 12; n++) {
        b.write('<hr>');
        b.write(n < 10 ? '<h4>$n. Song $n</h4>' : '<p>$n. Song $n</p>');
        b.write('<p>first line of song $n<br>second line of song $n</p>');
      }
      return '$b$closing';
    }

    test('typed numbers become labels; the opening prayer has none', () {
      final s = parseSections(printedBook());
      expect(s.length, 13);
      expect(s.map((x) => x.number), List.generate(13, (i) => i + 1));
      expect(s.map((x) => x.label), [null, ...List.generate(12, (i) => i + 1)]);
      expect(s[0].title, 'ಪ್ರಾರ್ಥನೆ');
    });

    test('the typed number is removed from the title and the heading', () {
      final s = parseSections(printedBook());
      expect(s[1].title, 'Song 1');
      expect(s[1].headingHtml, 'Song 1');
      expect(s[10].title, 'Song 10');
      expect(s[10].headingHtml, 'Song 10');
      expect(s[10].bodyHtml, startsWith('<p>first line of song 10'));
    });

    test('Kannada digits count', () {
      final s = parseSections('<h3>ಪ್ರಾರ್ಥನೆ</h3><p>a<br>b</p><hr>'
          '<h4>೧. ಹಾಡು</h4><p>x<br>y</p><hr>'
          '<p>೨. ಎರಡು</p><p>body text that is long enough</p>');
      expect(s.map((x) => x.label), [null, 1, 2]);
      expect(s[2].title, 'ಎರಡು');
    });

    test('a numbered first line without a heading keeps the body as is', () {
      final s = parseSections('<p>1. first saying<br>more</p><hr>'
          '<p>2. second saying<br>more</p>');
      expect(s.map((x) => x.label), [1, 2]);
      expect(s[1].title, 'second saying');
      expect(s[1].headingHtml, isNull);
      expect(s[1].bodyHtml, startsWith('<p>2. second saying'));
    });

    test('a stray number does not switch the book to printed numbers', () {
      final s = parseSections('<h3>1. Odd one</h3><p>a<br>b</p><hr>'
          '<p>two<br>b</p><hr><p>three<br>c</p>');
      expect(s.map((x) => x.label), [1, 2, 3]);
      expect(s[0].title, '1. Odd one');
    });

    test('the sample book keeps counting by position', () {
      final s = parseSections(book);
      expect(s.map((x) => x.label), List.generate(29, (i) => i + 1));
    });

    test('lastLabel, indexOfLabel and placeOf', () {
      final s = parseSections(
          printedBook(closing: '<hr><h3>ಮಂಗಳ</h3><p>end<br>end</p>'));
      expect(s.lastLabel, 12);
      expect(s.indexOfLabel(10), 10);
      expect(s.indexOfLabel(13), isNull);
      expect(s.placeOf(0), 'Before 1');
      expect(s.placeOf(10), '10');
      expect(s.placeOf(13), 'After 12');
    });
  });

  group('parseChapters', () {
    test('each chapter is one section named by its chapter name', () {
      final s = parseChapters([
        (name: 'ಮುನ್ನುಡಿ', content: '<p>a<br>b</p><hr><p>c</p>'),
        (name: 'Two', content: '<p>x</p>'),
      ]);
      expect(s.length, 2);
      expect(s.map((x) => x.label), [1, 2]);
      expect(s[0].title, 'ಮುನ್ನುಡಿ');
      expect(s[0].headingHtml, 'ಮುನ್ನುಡಿ');
      expect(s[0].bodyHtml, contains('<hr>'));
    });

    test('a heading repeating the chapter name is dropped', () {
      final s = parseChapters([
        (name: 'One', content: '<h3>|| One ||</h3><p>a</p>'),
        (name: 'Two', content: '<h3>Other</h3><p>b</p>'),
      ]);
      expect(s[0].bodyHtml, '<p>a</p>');
      expect(s[1].bodyHtml, '<h3>Other</h3><p>b</p>');
    });

    test('names are escaped and printed numbers apply', () {
      final s = parseChapters([
        (name: 'Preface', content: '<p>p</p>'),
        (name: '1. A & B', content: '<p>a</p>'),
        (name: '2. C', content: '<p>c</p>'),
      ]);
      expect(s.map((x) => x.label), [null, 1, 2]);
      expect(s[1].title, 'A & B');
      expect(s[1].headingHtml, 'A &amp; B');
    });
  });
}
