import 'dart:io';

import 'package:arjun_guruji/core/reader/reader_page.dart';
import 'package:arjun_guruji/core/reader/reader_widgets.dart';
import 'package:arjun_guruji/features/Settings/data/datasource/settings_local_ds.dart';
import 'package:arjun_guruji/features/Settings/data/repository/settings_repository_impl.dart';
import 'package:arjun_guruji/features/Settings/domain/usecases/get_settings_usecase.dart';
import 'package:arjun_guruji/features/Settings/domain/usecases/save_settings_usecase.dart';
import 'package:arjun_guruji/features/Settings/presentation/bloc/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

/// Just enough of a Hive box for settings and saved positions, in memory.
class FakeBox implements Box {
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

final book = File('test/fixtures/sample_book.html').readAsStringSync();

SettingsBloc makeBloc(FakeBox settings) {
  final repo = SettingsRepositoryImpl(SettingsLocalDataSourceImpl(settings));
  return SettingsBloc(
    getSettingsUseCase: GetSettingsUseCase(repo),
    saveSettingsUseCase: SaveSettingsUseCase(repo),
  );
}

Future<SettingsBloc> openReader(
  WidgetTester tester, {
  String content = '',
  FakeBox? positions,
  Size size = const Size(420, 3200),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final bloc = makeBloc(FakeBox());
  addTearDown(bloc.close);
  await tester.pumpWidget(MaterialApp(
    home: BlocProvider.value(
      value: bloc,
      child: ReaderPage(
        title: 'Book',
        content: content.isEmpty ? book : content,
        positionBox: positions ?? FakeBox(),
      ),
    ),
  ));
  await tester.pump(const Duration(milliseconds: 500));
  return bloc;
}

Finder get bookList => find.byWidgetPredicate(
    (w) => w is ScrollablePositionedList && w.itemCount == 29);

Finder pillLabel(String text) => find.bySemanticsLabel(RegExp('^$text,'));

String pillNumber(WidgetTester tester) =>
    tester.widget<RollText>(find.byKey(const ValueKey('pill-number'))).text;

/// How far through section [number] the 30% reading line is.
double readingR(WidgetTester tester, int number) {
  final view = tester.getRect(bookList);
  final item = tester.getRect(find.byKey(ValueKey('section-$number')));
  return (view.top + view.height * 0.3 - item.top) / item.height;
}

/// Let animations finish and the frames after them build.
Future<void> settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
  await tester.pump(const Duration(milliseconds: 50));
}

Future<void> closeReader(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(seconds: 3));
}

void main() {
  testWidgets('contents lists 29 rows; row 14 then next gives 14 and 15 of 29',
      (tester) async {
    final semantics = tester.ensureSemantics();
    await openReader(tester);

    for (var n = 1; n <= 29; n++) {
      expect(find.byKey(ValueKey('toc-row-$n')), findsOneWidget, reason: '$n');
    }
    expect(find.text('Start reading'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('toc-row-14')));
    await settle(tester);
    expect(find.byKey(const ValueKey('toc-row-14')), findsNothing);
    expect(pillNumber(tester), '14');
    // The list really moved: section 14 starts at the top of the text area.
    expect(tester.getRect(find.byKey(const ValueKey('section-14'))).top,
        tester.getRect(bookList).top);
    expect(pillNumber(tester), '14');

    await tester.tap(find.bySemanticsLabel('Next section'));
    await settle(tester);
    expect(pillLabel('15 of 29'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Previous section'));
    await settle(tester);
    expect(pillLabel('14 of 29'), findsOneWidget);

    await closeReader(tester);
    semantics.dispose();
  });

  testWidgets('bar opens on 1 of 29 with previous disabled', (tester) async {
    await openReader(tester);
    await tester.tap(find.byKey(const ValueKey('resume-card')));
    await settle(tester);
    expect(pillNumber(tester), '1');
    expect(find.text('Previous section'), findsNothing);
    await closeReader(tester);
  });

  testWidgets('go to number accepts Kannada digits and rejects out of range',
      (tester) async {
    await openReader(tester);

    await tester.enterText(find.byKey(const ValueKey('go-to-number')), '99');
    await tester.tap(find.byKey(const ValueKey('go-button')));
    await tester.pump();
    expect(find.text('Enter a number from 1 to 29.'), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey('go-to-number')), '೧೪');
    await tester.tap(find.byKey(const ValueKey('go-button')));
    await settle(tester);
    expect(pillNumber(tester), '14');
    await closeReader(tester);
  });

  testWidgets('a printed book uses its own numbers in the bar and go-to',
      (tester) async {
    final b =
        StringBuffer('<h3>|| ಪ್ರಾರ್ಥನೆ ||</h3><p>prayer one<br>prayer two</p>');
    for (var n = 1; n <= 12; n++) {
      b.write('<hr>');
      b.write(n < 10 ? '<h4>$n. Song $n</h4>' : '<p>$n. Song $n</p>');
      b.write('<p>first line of song $n<br>second line of song $n</p>');
    }
    await openReader(tester, content: b.toString());
    await tester.enterText(find.byKey(const ValueKey('go-to-number')), '13');
    await tester.tap(find.byKey(const ValueKey('go-button')));
    await tester.pump();
    expect(find.text('Enter a number from 1 to 12.'), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey('go-to-number')), '10');
    await tester.tap(find.byKey(const ValueKey('go-button')));
    await settle(tester);
    expect(pillNumber(tester), '10');
    expect(pillLabel('10 of 12'), findsOneWidget);
    expect(find.text('Next · 11'), findsOneWidget);
    await closeReader(tester);
  });

  testWidgets('a short opening prayer at the top shows Before 1',
      (tester) async {
    final b =
        StringBuffer('<h3>|| ಪ್ರಾರ್ಥನೆ ||</h3><p>prayer one<br>prayer two</p>');
    for (var n = 1; n <= 12; n++) {
      b.write('<hr><p>$n. Song $n</p><p>first line of song $n<br>second</p>');
    }
    await openReader(tester, content: b.toString());
    await tester.tap(find.byKey(const ValueKey('resume-card')));
    await settle(tester);
    expect(pillNumber(tester), 'Before 1');
    expect(pillLabel('Before 1'), findsOneWidget);
    await closeReader(tester);
  });

  testWidgets('saved position restores partway into the section',
      (tester) async {
    final box = FakeBox();
    // Section titles come from the parser; 14 (0-based 13) is the saved one.
    await openReader(tester, positions: box);
    await tester.tap(find.byKey(const ValueKey('toc-row-14')));
    await settle(tester);
    await closeReader(tester);

    // Pretend the reader had been half way through section 14.
    final key = box.data.keys.single as String;
    expect(key, 'pos:content:Book');
    final saved = Map<String, dynamic>.from(box.data[key] as Map);
    expect(saved['index'], 13);
    box.data[key] = {...saved, 'r': 0.5};

    await openReader(tester, positions: box);
    expect(find.text('Continue reading'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('resume-card')));
    await settle(tester);
    expect(pillNumber(tester), '14');
    expect(readingR(tester, 14), closeTo(0.5, 0.02));
    await closeReader(tester);
  });

  testWidgets('title is checked when the book has changed', (tester) async {
    final box = FakeBox();
    box.data['pos:content:Book'] = {'index': 3, 'title': 'ಮಂಗಳ', 'r': 0.0};
    await openReader(tester, positions: box);
    // Section 29 is titled ಮಂಗಳ, so the saved title wins over the old index.
    expect(find.textContaining('29 · ಮಂಗಳ'), findsOneWidget);
    await closeReader(tester);
  });

  testWidgets('text size keeps the same line', (tester) async {
    final semantics = tester.ensureSemantics();
    final bloc = await openReader(tester, size: const Size(420, 900));
    await tester.tap(find.byKey(const ValueKey('resume-card')));
    await settle(tester);
    await tester.tap(find.bySemanticsLabel('Next section'));
    await settle(tester);
    // Scroll into the middle of the section.
    await tester.drag(bookList, const Offset(0, -700));
    await tester.pump(const Duration(milliseconds: 500));
    final before = readingR(tester, 2);
    expect(before, inInclusiveRange(0.05, 0.95));

    await tester.tap(find.bySemanticsLabel('Larger text'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));
    expect(bloc.state.settings.fontSize, 22);
    expect(find.text('Text size 4 of 7'), findsOneWidget);
    expect(readingR(tester, 2), closeTo(before, 0.02));

    await tester.tap(find.bySemanticsLabel('Smaller text'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));
    expect(bloc.state.settings.fontSize, 20);
    expect(readingR(tester, 2), closeTo(before, 0.02));
    await closeReader(tester);
    semantics.dispose();
  });

  testWidgets('theme button cycles light, sepia, dark with a toast',
      (tester) async {
    final semantics = tester.ensureSemantics();
    final bloc = await openReader(tester);
    await tester.tap(find.byKey(const ValueKey('resume-card')));
    await settle(tester);
    await tester.tap(find.bySemanticsLabel('Change background colour'));
    await tester.pump();
    expect(bloc.state.settings.readingTheme, 'sepia');
    expect(find.text('Sepia background'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Change background colour'));
    await tester.pump();
    expect(bloc.state.settings.readingTheme, 'dark');
    await tester.tap(find.bySemanticsLabel('Change background colour'));
    await tester.pump();
    expect(bloc.state.settings.readingTheme, 'light');
    await closeReader(tester);
    semantics.dispose();
  });

  testWidgets('search lists matching sections and jumps to the tapped one',
      (tester) async {
    final semantics = tester.ensureSemantics();
    await openReader(tester);
    await tester.tap(find.bySemanticsLabel('Search'));
    await settle(tester);
    await tester.enterText(find.byType(TextField).last, 'ಗುರ್ವಷ್ಟಕಮ್');
    await tester.pump();
    final hit = find.textContaining('5 · ಗುರ್ವಷ್ಟಕಮ್');
    expect(hit, findsOneWidget);
    await tester.tap(hit);
    await settle(tester);
    expect(pillLabel('5 of 29'), findsOneWidget);
    await closeReader(tester);
    semantics.dispose();
  });

  testWidgets('dragging the thumb moves through the book', (tester) async {
    await openReader(tester, size: const Size(420, 900));
    await tester.tap(find.byKey(const ValueKey('resume-card')));
    await settle(tester);
    expect(pillNumber(tester), '1');

    await tester.drag(
        find.byKey(const ValueKey('scroll-thumb')), const Offset(0, 400));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    final middle = int.parse(pillNumber(tester));
    expect(middle, greaterThan(5));
    expect(middle, lessThan(29));

    await tester.drag(
        find.byKey(const ValueKey('scroll-thumb')), const Offset(0, 2000));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(pillNumber(tester), '29');
    await closeReader(tester);
  });

  testWidgets('bubble shows for a fast fling, not for slow reading or jumps',
      (tester) async {
    await openReader(tester, size: const Size(420, 900));
    await tester.tap(find.byKey(const ValueKey('resume-card')));
    await settle(tester);
    double bubble() => tester
        .widget<AnimatedOpacity>(find.byKey(const ValueKey('bubble-opacity')))
        .opacity;
    expect(bubble(), 0);

    // Programmatic jumps never show it.
    await tester.tap(find.bySemanticsLabel('Next section'),
        warnIfMissed: false);
    await settle(tester);
    expect(bubble(), 0);

    // Slow reading: small drags a second apart.
    for (var k = 0; k < 4; k++) {
      await tester.drag(bookList, const Offset(0, -120));
      await tester.pump(const Duration(seconds: 1));
    }
    expect(bubble(), 0);

    // A hard fling covers many screens within a fraction of a second.
    await tester.fling(bookList, const Offset(0, -2000), 8000);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));
    expect(bubble(), 1);

    // It goes away once scrolling has stopped.
    await tester.pump(const Duration(seconds: 6));
    await tester.pump(const Duration(seconds: 2));
    expect(bubble(), 0);
    await closeReader(tester);
  });

  testWidgets('content without hr is a plain reader', (tester) async {
    final semantics = tester.ensureSemantics();
    await openReader(tester, content: '<p>ಒಂದು<br>ಎರಡು</p><h4>1. name</h4>');
    expect(find.byType(ReaderLocationBar), findsNothing);
    expect(find.byType(ReaderContentsScreen), findsNothing);
    expect(find.byType(ScrollablePositionedList), findsNothing);
    expect(find.bySemanticsLabel('Contents'), findsNothing);
    expect(find.bySemanticsLabel('Larger text'), findsOneWidget);
    expect(find.bySemanticsLabel('Smaller text'), findsOneWidget);
    expect(find.bySemanticsLabel('Change background colour'), findsOneWidget);
    await closeReader(tester);
    semantics.dispose();
  });

  testWidgets('empty content shows the failed state', (tester) async {
    tester.view.physicalSize = const Size(420, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final bloc = makeBloc(FakeBox());
    addTearDown(bloc.close);
    await tester.pumpWidget(MaterialApp(
      home: BlocProvider.value(
        value: bloc,
        child: ReaderPage(title: 'Empty', content: '', positionBox: FakeBox()),
      ),
    ));
    expect(find.text('Failed to load content'), findsOneWidget);
    await closeReader(tester);
  });
}
