import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollDirection;
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../features/Settings/presentation/bloc/settings_bloc.dart';
import '../../features/Settings/presentation/bloc/settings_event.dart';
import '../../features/Settings/presentation/bloc/settings_state.dart';
import 'reader_position.dart';
import 'reader_search.dart';
import 'reader_widgets.dart';
import 'reading_palette.dart';
import 'section_parser.dart';

/// The text sizes A- / A+ step through.
const readerFontSteps = [16.0, 18.0, 20.0, 22.0, 25.0, 28.0, 32.0];

/// Where on screen the "current section" is decided, as a share of the height.
const _readingLine = 0.3;

const _themeCycle = ['light', 'sepia', 'dark'];
const _themeNames = {
  'light': 'Light background',
  'sepia': 'Sepia background',
  'dark': 'Dark background',
};

/// A place the next layout should confirm: section [index], [r] of the way
/// through it, with that point [line] of the way down the viewport.
class _Fix {
  final int index;
  final double r;
  final double line;
  int attempts = 0;
  _Fix(this.index, this.r, this.line);
}

class _Sample {
  final int millis;
  final Map<int, double> leading;
  _Sample(this.millis, this.leading);
}

/// Reader for long books. HTML split at `<hr>` becomes numbered sections with
/// a contents screen, a location bar and fast travel; content without `<hr>`
/// is a plain reader.
class ReaderPage extends StatefulWidget {
  final String title;
  final String? chapterName;
  final String content;

  /// A book stored as chapters: each one is a section, in place of splitting
  /// [content] at `<hr>`. Pass two or more; a single chapter is just [content].
  final List<({String name, String content})>? chapters;

  /// Which kind of content this is; part of the saved-position key.
  final String kind;

  /// Where reading positions are saved. Defaults to the app's settings box.
  final Box? positionBox;

  const ReaderPage({
    super.key,
    required this.title,
    required this.content,
    this.chapterName,
    this.chapters,
    this.kind = 'content',
    this.positionBox,
  });

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> with TickerProviderStateMixin {
  late final List<ReaderSection> _sections = widget.chapters == null
      ? parseSections(widget.content)
      : parseChapters(widget.chapters!);
  late final bool _multi = _sections.length >= 2;
  late final SectionWeights _weights = SectionWeights.of(_sections);
  late final ReaderPositionStore _store;
  late final ReaderSearchIndex _searchIndex = ReaderSearchIndex(
    _multi
        ? _sections
        : [
            ReaderSection(
              number: 1,
              label: null,
              title: widget.title,
              headingHtml: null,
              bodyHtml: widget.content,
              length: widget.content.length,
            ),
          ],
  );

  final GlobalKey _listKey = GlobalKey();
  final ItemScrollController _scroll = ItemScrollController();
  final ItemPositionsListener _positions = ItemPositionsListener.create();

  late final ValueNotifier<ReaderPosition> _pos;
  final ValueNotifier<double> _thumb = ValueNotifier(0);
  final ValueNotifier<bool> _scrolling = ValueNotifier(false);
  final ValueNotifier<bool> _travelling = ValueNotifier(false);
  final ValueNotifier<bool> _dragging = ValueNotifier(false);
  final ValueNotifier<SectionArrival?> _arrival = ValueNotifier(null);
  final ValueNotifier<String?> _toast = ValueNotifier(null);

  late final AnimationController _contentsAnim;
  late final AnimationController _jumpAnim;

  /// Measured section heights in px; emptied when the layout changes.
  final Map<int, double> _heights = {};
  double _viewportH = 0;
  Size? _lastSize;

  int _rollDirection = 1;
  bool _pastTop = false;
  bool _reduceMotion = false;

  /// After a jump the target stays "current" until the reader scrolls.
  int? _forcedIndex;
  _Fix? _fix;
  Timer? _fixTimer;
  Timer? _idleTimer;
  Timer? _arrivalTimer;
  Timer? _toastTimer;
  int _arrivalToken = 0;
  int _suppressUntil = 0;
  final List<_Sample> _samples = [];
  Map<int, double> _lastLeading = {};

  bool _contentsVisible = false;
  bool _contentsOpen = false;
  bool _contentsAtStart = false;
  late int _contentsCurrent;
  late bool _contentsStarted;

  String _hlQuery = '';
  int? _hlSection;
  String? _hlHead;
  String? _hlBody;

  int get _now =>
      SchedulerBinding.instance.currentSystemFrameTimeStamp.inMilliseconds;

  @override
  void initState() {
    super.initState();
    _store = ReaderPositionStore(
      widget.positionBox ?? _settingsBox(),
      kind: widget.kind,
      title: widget.chapterName == null
          ? widget.title
          : '${widget.title}/${widget.chapterName}',
    );
    final saved = _multi ? _store.restore(_sections) : null;
    _pos = ValueNotifier(saved ?? const ReaderPosition(0, 0));
    _thumb.value = saved == null ? 0 : _weights.fractionOf(saved);
    _pastTop = (saved?.index ?? 0) > 0;

    _contentsVisible = _contentsOpen = _contentsAtStart = _multi;
    _contentsCurrent = _pos.value.index;
    _contentsStarted = _pastTop;
    _contentsAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      value: _multi ? 1 : 0,
    )..addStatusListener((status) {
        if (status == AnimationStatus.dismissed && !_contentsOpen && mounted) {
          setState(() => _contentsVisible = false);
        }
      });
    _jumpAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 1,
    );

    if (_multi) {
      _positions.itemPositions.addListener(_onPositions);
      if (saved != null) _startFix(saved.index, saved.r, _readingLine);
    }
  }

  static Box? _settingsBox() {
    final di = GetIt.instance;
    return di.isRegistered<Box>(instanceName: 'settingsBox')
        ? di<Box>(instanceName: 'settingsBox')
        : null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.disableAnimationsOf(context);
  }

  @override
  void dispose() {
    if (_multi) {
      _positions.itemPositions.removeListener(_onPositions);
      _store.save(_sections, _pos.value);
    }
    for (final t in [_fixTimer, _idleTimer, _arrivalTimer, _toastTimer]) {
      t?.cancel();
    }
    for (final n in [
      _pos,
      _thumb,
      _scrolling,
      _travelling,
      _dragging,
      _arrival,
      _toast,
    ]) {
      n.dispose();
    }
    _contentsAnim.dispose();
    _jumpAnim.dispose();
    super.dispose();
  }

  // ---- position tracking ----

  void _onPositions() {
    final raw = _positions.itemPositions.value;
    if (raw.isEmpty || _viewportH <= 0) return;
    final list = raw.toList()..sort((a, b) => a.index.compareTo(b.index));
    for (final p in list) {
      _heights[p.index] = (p.itemTrailingEdge - p.itemLeadingEdge) * _viewportH;
    }

    if (_fix != null && _applyFix(list)) return;

    final leading = {for (final p in list) p.index: p.itemLeadingEdge};
    var moved = true;
    for (final e in leading.entries) {
      final before = _lastLeading[e.key];
      if (before != null) {
        moved = (before - e.value).abs() > 0.0005;
        break;
      }
    }
    _lastLeading = leading;
    if (moved) _noteScroll(leading);

    _pastTop = list.first.index > 0 || list.first.itemLeadingEdge < -0.002;
    if (_dragging.value) return;
    _updatePosition(list);
    _thumb.value = _thumbFraction(list);
  }

  /// The section crossing the reading line, and how far through it that is.
  ReaderPosition _locate(List<ItemPosition> list) {
    final last = list.last;
    if (last.index == _sections.length - 1 && last.itemTrailingEdge <= 1.002) {
      return ReaderPosition(last.index, 1);
    }
    // At the very top the first piece is current, even when it is shorter
    // than the reading line (a two-line opening prayer).
    final top = list.where((p) => p.index == 0);
    if (top.isNotEmpty && top.first.itemLeadingEdge >= -0.002) {
      return ReaderPosition(0, 0);
    }
    return _positionAtLine(list, _readingLine);
  }

  ReaderPosition _positionAtLine(List<ItemPosition> list, double line) {
    ItemPosition? hit;
    for (final p in list) {
      if (p.itemLeadingEdge <= line && p.itemTrailingEdge > line) hit = p;
    }
    if (hit == null) {
      return line < list.first.itemLeadingEdge
          ? ReaderPosition(list.first.index, 0)
          : ReaderPosition(list.last.index, 1);
    }
    final r = (line - hit.itemLeadingEdge) /
        (hit.itemTrailingEdge - hit.itemLeadingEdge);
    return ReaderPosition(hit.index, r.clamp(0.0, 1.0));
  }

  void _updatePosition(List<ItemPosition> list) {
    var next = _locate(list);
    final forced = _forcedIndex;
    if (forced != null && next.index != forced) {
      next = ReaderPosition(forced, 0);
    }
    if (next == _pos.value) return;
    if (next.index != _pos.value.index) {
      _rollDirection = next.index > _pos.value.index ? 1 : -1;
    }
    _pos.value = next;
  }

  /// The thumb's place along the track: the book-wide fraction found on a
  /// line that slides from the top of the viewport (start of book) to the
  /// bottom (end of book), so the thumb reaches both ends.
  double _thumbFraction(List<ItemPosition> list) {
    double at(double line) =>
        _weights.fractionOf(_positionAtLine(list, line)) - line;
    var lo = 0.0, hi = 1.0;
    for (var k = 0; k < 24; k++) {
      final mid = (lo + hi) / 2;
      if (at(mid) > 0) {
        lo = mid;
      } else {
        hi = mid;
      }
    }
    final f = (lo + hi) / 2;
    final first = list.first;
    if (first.index == 0 && first.itemLeadingEdge >= 0) return 0;
    final last = list.last;
    if (last.index == _sections.length - 1 && last.itemTrailingEdge <= 1.002) {
      return 1;
    }
    return f;
  }

  void _noteScroll(Map<int, double> leading) {
    final now = _now;
    if (now >= _suppressUntil) {
      _scrolling.value = true;
      _samples.add(_Sample(now, leading));
      while (_samples.length > 1 && now - _samples.first.millis > 400) {
        _samples.removeAt(0);
      }
      var travelled = 2.0; // nothing in common: moved more than a screen
      for (final e in _samples.first.leading.entries) {
        final nowEdge = leading[e.key];
        if (nowEdge != null) {
          travelled = (nowEdge - e.value).abs();
          break;
        }
      }
      if (_samples.length > 1 && travelled > 0.6) _travelling.value = true;
    } else {
      _samples.clear();
    }
    _idleTimer?.cancel();
    _idleTimer = Timer(const Duration(milliseconds: 1100), _settle);
  }

  void _settle() {
    if (!mounted) return;
    if (!_dragging.value) {
      _scrolling.value = false;
      _travelling.value = false;
    }
    _samples.clear();
    if (_multi && _fix == null) _store.save(_sections, _pos.value);
  }

  // ---- jumping ----

  void _suppressTravel() {
    _suppressUntil = _now + 250;
    _samples.clear();
  }

  /// Instantly bring section [i] to the top, fade the text in, glow its heading.
  void _goTo(int i) {
    if (!_multi) return;
    i = i.clamp(0, _sections.length - 1);
    if (_contentsOpen) _closeContents();
    _suppressTravel();
    _fix = null;
    _forcedIndex = i;
    _scroll.jumpTo(index: i, alignment: 0);
    if (i != _pos.value.index) _rollDirection = i > _pos.value.index ? 1 : -1;
    _pos.value = ReaderPosition(i, 0);
    _thumb.value = _weights.fractionOf(_pos.value);
    if (!_reduceMotion) {
      _jumpAnim.forward(from: 0);
      _arrival.value = SectionArrival(i, ++_arrivalToken);
      _arrivalTimer?.cancel();
      _arrivalTimer = Timer(const Duration(milliseconds: 2200), () {
        if (mounted) _arrival.value = null;
      });
    }
    _idleTimer?.cancel();
    _idleTimer = Timer(const Duration(milliseconds: 900), _settle);
  }

  /// Put the point [r] of the way through section [i] at [line] of the way
  /// down the viewport. Heights of unseen sections are unknown, so this jumps
  /// to the best guess and then corrects once the section has been laid out.
  void _placeAt(int i, double r, double line) {
    _suppressTravel();
    _forcedIndex = null;
    final h = _heights[i];
    final alignment = line - (h == null ? 0 : r * h / _viewportH);
    _scroll.jumpTo(index: i, alignment: _clampAlignment(i, alignment));
    _startFix(i, r, line);
  }

  double _clampAlignment(int i, double a) => i == 0 ? math.min(a, 0) : a;

  void _startFix(int i, double r, double line) {
    _fix = _Fix(i, r, line);
    _fixTimer?.cancel();
    _fixTimer = Timer(const Duration(milliseconds: 500), () {
      if (!mounted || _fix == null) return;
      _fix = null;
      _onPositions();
    });
  }

  /// Returns true if it moved the list again (so the layout is not final).
  bool _applyFix(List<ItemPosition> list) {
    final fix = _fix!;
    ItemPosition? p;
    for (final item in list) {
      if (item.index == fix.index) p = item;
    }
    if (fix.attempts >= 3) {
      _fix = null;
      return false;
    }
    if (p == null) {
      fix.attempts++;
      _scroll.jumpTo(
          index: fix.index, alignment: _clampAlignment(fix.index, fix.line));
      return true;
    }
    final height = p.itemTrailingEdge - p.itemLeadingEdge;
    final want = _clampAlignment(fix.index, fix.line - fix.r * height);
    if ((p.itemLeadingEdge - want).abs() < 0.002) {
      _fix = null;
      return false;
    }
    fix.attempts++;
    _scroll.jumpTo(index: fix.index, alignment: want);
    return true;
  }

  void _onTextMetricsChanged() {
    if (!_multi) return;
    // Stay on the same line: remember where we are, let the new sizes lay out,
    // then put that spot back where the reading line is.
    final here = _pos.value;
    _heights.clear();
    _suppressTravel();
    _forcedIndex = null;
    _startFix(here.index, here.r, _readingLine);
  }

  // ---- thumb ----

  void _onThumbStart() {
    _dragging.value = true;
    _scrolling.value = true;
    _idleTimer?.cancel();
    _forcedIndex = null;
  }

  void _onThumbDrag(double f) {
    final target = _weights.positionAt(f);
    if (target.index != _pos.value.index) {
      HapticFeedback.selectionClick();
      _rollDirection = target.index > _pos.value.index ? 1 : -1;
    }
    _pos.value = target;
    _thumb.value = f;
    _placeAt(target.index, target.r, f);
  }

  void _onThumbEnd() {
    _dragging.value = false;
    _idleTimer?.cancel();
    _idleTimer = Timer(const Duration(milliseconds: 900), _settle);
  }

  // ---- contents ----

  void _openContents() {
    final pos = _pos.value;
    setState(() {
      _contentsCurrent = pos.index;
      _contentsStarted = _pastTop;
      _contentsVisible = true;
      _contentsOpen = true;
    });
    _slideContents(reverse: false);
  }

  void _closeContents() {
    if (!_contentsOpen) return;
    _contentsAtStart = false;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _contentsOpen = false);
    _slideContents(reverse: true);
  }

  void _slideContents({required bool reverse}) {
    _contentsAnim.duration =
        _reduceMotion ? Duration.zero : const Duration(milliseconds: 400);
    reverse ? _contentsAnim.reverse() : _contentsAnim.forward();
  }

  // ---- bars ----

  void _showToast(String message) {
    _toast.value = message;
    _toastTimer?.cancel();
    _toastTimer = Timer(const Duration(milliseconds: 1300), () {
      if (mounted) _toast.value = null;
    });
  }

  void _cycleTheme(String current) {
    final next = _themeCycle[(_themeCycle.indexOf(current) + 1) % 3];
    context.read<SettingsBloc>().add(UpdateTheme(next));
    _showToast(_themeNames[next]!);
  }

  int _nearestStep(double size) {
    var best = 0;
    for (var k = 1; k < readerFontSteps.length; k++) {
      if ((readerFontSteps[k] - size).abs() <
          (readerFontSteps[best] - size).abs()) {
        best = k;
      }
    }
    return best;
  }

  void _stepFont(double size, int by) {
    final k = (_nearestStep(size) + by).clamp(0, readerFontSteps.length - 1);
    context.read<SettingsBloc>().add(UpdateFontSize(readerFontSteps[k]));
    _showToast('Text size ${k + 1} of ${readerFontSteps.length}');
  }

  Future<void> _openSearch(ReadingPalette palette) async {
    final result = await showModalBottomSheet<ReaderSearchResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ReaderSearchSheet(
        index: _searchIndex,
        palette: palette,
        numbered: _multi,
        initialQuery: _hlQuery,
        canClear: _hlQuery.isNotEmpty,
      ),
    );
    if (result == null || !mounted) return;
    final section = result.sectionIndex;
    setState(() {
      _hlQuery = result.query;
      _hlSection = section;
      _hlHead = _hlBody = null;
      if (section == null) return;
      if (!_multi) {
        _hlBody = highlightMatches(widget.content, result.query);
        return;
      }
      final s = _sections[section];
      _hlHead = s.headingHtml == null
          ? null
          : highlightMatches(s.headingHtml!, result.query);
      _hlBody = highlightMatches(s.bodyHtml, result.query);
    });
    if (_multi && section != null) _goTo(section);
  }

  // ---- building ----

  Map<String, Style> _htmlStyle(ReadingPalette p, double size, String family) {
    return {
      'body': Style(
        fontSize: FontSize(size),
        color: p.ink,
        lineHeight: const LineHeight(1.8),
        fontFamily: family,
        margin: Margins.zero,
        padding: HtmlPaddings.zero,
      ),
      'p': Style(margin: Margins.only(top: 0, bottom: size * 1.1)),
      // Numbered names in astottaras read like lines of one paragraph.
      'h4': Style(
        margin: Margins.zero,
        fontSize: FontSize(size),
        fontWeight: FontWeight.normal,
      ),
      'h4 + p': Style(margin: Margins.only(top: 0, bottom: size * 1.1)),
      // Refrains and closing lines inside a section.
      'h3': Style(
        textAlign: TextAlign.center,
        fontWeight: FontWeight.w600,
        fontSize: FontSize(size * 0.95),
        color: p.accentLine,
        margin: Margins.symmetric(vertical: size * 0.95 * 1.3),
      ),
      'mark': Style(backgroundColor: p.accent, color: p.onAccent),
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
      listenWhen: (a, b) =>
          a.settings.fontSize != b.settings.fontSize ||
          a.settings.fontStyle != b.settings.fontStyle,
      listener: (context, state) => _onTextMetricsChanged(),
      buildWhen: (a, b) => a.settings != b.settings,
      builder: (context, state) {
        final settings = state.settings;
        final palette = ReadingPalette.of(settings.readingTheme);
        final family = settings.fontStyle == 'serif'
            ? 'notoserifkannada'
            : 'notosanskannada';
        final size = settings.fontSize;
        final animate = !_reduceMotion;
        final stepIndex = _nearestStep(size);

        final topBar = ReaderTopBar(
          palette: palette,
          title: widget.title,
          onBack: () => Navigator.of(context).maybePop(),
          onContents: _multi ? _openContents : null,
          // In a book, search lives on the Contents screen.
          onSearch:
              _multi || _sections.isEmpty ? null : () => _openSearch(palette),
          onTheme: () => _cycleTheme(settings.readingTheme),
          onSmaller: stepIndex > 0 ? () => _stepFont(size, -1) : null,
          onLarger: stepIndex < readerFontSteps.length - 1
              ? () => _stepFont(size, 1)
              : null,
        );

        Widget body;
        if (_sections.isEmpty) {
          body = _buildFailed(palette);
        } else if (!_multi) {
          body = _buildPlain(palette, size, family);
        } else {
          body = _buildBook(palette, size, family, animate);
        }

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: (palette.brightness == Brightness.dark
                  ? SystemUiOverlayStyle.light
                  : SystemUiOverlayStyle.dark)
              .copyWith(statusBarColor: Colors.transparent),
          child: PopScope(
            // Contents is where a book opens; back from there leaves the book.
            canPop: !_contentsOpen || _contentsAtStart,
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop) _closeContents();
            },
            child: Scaffold(
              backgroundColor: palette.background,
              resizeToAvoidBottomInset: false,
              body: Stack(
                children: [
                  Positioned.fill(
                    child: ExcludeSemantics(
                      excluding: _contentsOpen,
                      child: Column(
                        children: [
                          topBar,
                          Expanded(child: body),
                          if (_multi)
                            ReaderLocationBar(
                              sections: _sections,
                              weights: _weights,
                              position: _pos,
                              palette: palette,
                              direction: () => _rollDirection,
                              animate: animate,
                              onPrev: () => _goTo(_pos.value.index - 1),
                              onNext: () => _goTo(_pos.value.index + 1),
                              onContents: _openContents,
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (_multi && _contentsVisible)
                    Positioned.fill(
                      child: SlideTransition(
                        position: _contentsAnim.drive(
                          Tween(begin: const Offset(0, 1), end: Offset.zero)
                              .chain(CurveTween(curve: Curves.easeOutCubic)),
                        ),
                        child: ReaderContentsScreen(
                          sections: _sections,
                          bookTitle: widget.title,
                          palette: palette,
                          current: _contentsCurrent,
                          started: _contentsStarted,
                          onClose: _closeContents,
                          onGo: _goTo,
                          onSearch: () => _openSearch(palette),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFailed(ReadingPalette p) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: p.muted, size: 40),
          const SizedBox(height: 8),
          Text('Failed to load content',
              style: TextStyle(color: p.ink, fontSize: 16)),
          const SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: p.accent,
              foregroundColor: p.onAccent,
            ),
            onPressed: () => setState(() {}),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildPlain(ReadingPalette p, double size, String family) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 48),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Html(
            data: _hlBody ?? widget.content,
            style: _htmlStyle(p, size, family),
          ),
        ),
      ),
    );
  }

  Widget _buildBook(
      ReadingPalette p, double size, String family, bool animate) {
    final style = _htmlStyle(p, size, family);
    final last = _sections.length - 1;
    return LayoutBuilder(builder: (context, box) {
      final newSize = Size(box.maxWidth, box.maxHeight);
      _viewportH = box.maxHeight;
      if (_lastSize != null && _lastSize != newSize) {
        // Rotated or resized: heights are stale, keep the place.
        _heights.clear();
        final here = _pos.value;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _startFix(here.index, here.r, _readingLine);
        });
      }
      _lastSize = newSize;

      final initial = _pos.value;
      final list = NotificationListener<UserScrollNotification>(
        onNotification: (n) {
          if (n.direction != ScrollDirection.idle) _forcedIndex = null;
          return false;
        },
        child: ScrollablePositionedList.builder(
          key: _listKey,
          itemCount: _sections.length,
          itemScrollController: _scroll,
          itemPositionsListener: _positions,
          minCacheExtent: 200,
          initialScrollIndex: initial.index,
          initialAlignment: initial.index == 0 && initial.r == 0
              ? 0
              : _clampAlignment(initial.index, _readingLine),
          itemBuilder: (context, i) {
            final s = _sections[i];
            final highlighted = _hlSection == i;
            return Align(
              key: ValueKey('section-${s.number}'),
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      22, i == 0 ? 4 : 0, 22, i == last ? 48 : 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SectionHeading(
                        number: s.number,
                        label: s.label,
                        headingHtml: highlighted && _hlHead != null
                            ? _hlHead
                            : s.headingHtml,
                        palette: p,
                        fontSize: size,
                        fontFamily: family,
                        arrival: _arrival,
                        animate: animate,
                      ),
                      Html(
                        data: highlighted && _hlBody != null
                            ? _hlBody
                            : s.bodyHtml,
                        style: style,
                      ),
                      if (i < last)
                        NextCard(
                          palette: p,
                          label: _sections[i + 1].label == null
                              ? 'Next'
                              : 'Next · ${_sections[i + 1].label}',
                          title: _sections[i + 1].title,
                          icon: Icons.chevron_right,
                          onTap: () => _goTo(i + 1),
                        )
                      else
                        NextCard(
                          palette: p,
                          label: 'End of book',
                          title: 'Back to contents',
                          icon: Icons.keyboard_arrow_up,
                          onTap: _openContents,
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );

      return Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _jumpAnim,
              child: list,
              builder: (context, child) {
                final t = Curves.easeOut.transform(_jumpAnim.value);
                // Same widget shape at rest, or the list would lose its place.
                return Opacity(
                  opacity: 0.15 + 0.85 * t,
                  child: Transform.translate(
                    offset: Offset(0, 12 * (1 - t)),
                    child: child,
                  ),
                );
              },
            ),
          ),
          ReaderScrollThumb(
            palette: p,
            sections: _sections,
            position: _pos,
            fraction: _thumb,
            scrolling: _scrolling,
            travelling: _travelling,
            dragging: _dragging,
            direction: () => _rollDirection,
            animate: animate,
            onDragStart: _onThumbStart,
            onDrag: _onThumbDrag,
            onDragEnd: _onThumbEnd,
          ),
          ReaderToast(message: _toast, palette: p, animate: animate),
        ],
      );
    });
  }
}
