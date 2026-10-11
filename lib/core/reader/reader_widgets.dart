import 'dart:math' as math;

import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'reader_position.dart';
import 'reading_palette.dart';
import 'section_parser.dart';

const readerUiFont = 'poppins';
const readerKannadaFont = 'notosanskannada';

const _ease = Cubic(0.2, 0.8, 0.2, 1);

/// Text that slides in when it changes: from below when moving forward,
/// from above when moving back.
class RollText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final int direction;
  final bool animate;

  const RollText({
    super.key,
    required this.text,
    required this.style,
    required this.direction,
    required this.animate,
  });

  @override
  State<RollText> createState() => _RollTextState();
}

class _RollTextState extends State<RollText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 340),
    value: 1,
  );
  late int _direction = widget.direction;

  @override
  void didUpdateWidget(RollText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text && widget.animate) {
      _direction = widget.direction;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = _ease.transform(_controller.value);
          return Opacity(
            opacity: t,
            child: FractionalTranslation(
              translation: Offset(0, (1 - t) * (_direction > 0 ? 0.75 : -0.75)),
              child: child,
            ),
          );
        },
        child: Text(
          widget.text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: widget.style,
        ),
      ),
    );
  }
}

/// A 44 x 48 tap target for the bars.
class BarButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Widget child;
  final ReadingPalette palette;
  final double width;

  const BarButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.child,
    required this.palette,
    this.width = 44,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onTap != null,
      label: label,
      excludeSemantics: true,
      child: Opacity(
        opacity: onTap == null ? 0.4 : 1,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          highlightColor: palette.accentWash,
          splashColor: palette.accentWash,
          child:
              SizedBox(width: width, height: 48, child: Center(child: child)),
        ),
      ),
    );
  }
}

class ReaderTopBar extends StatelessWidget {
  final ReadingPalette palette;
  final String title;
  final VoidCallback onBack;
  final VoidCallback? onContents;
  final VoidCallback? onSearch;
  final VoidCallback onTheme;
  final VoidCallback? onSmaller;
  final VoidCallback? onLarger;

  const ReaderTopBar({
    super.key,
    required this.palette,
    required this.title,
    required this.onBack,
    required this.onTheme,
    required this.onSmaller,
    required this.onLarger,
    this.onContents,
    this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    final p = palette;
    return Container(
      decoration: BoxDecoration(
        color: p.bar,
        border: Border(bottom: BorderSide(color: p.line)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            children: [
              BarButton(
                label: 'Back',
                palette: p,
                onTap: onBack,
                child: Icon(Icons.arrow_back, color: p.ink, size: 26),
              ),
              if (onContents != null)
                BarButton(
                  label: 'Contents',
                  palette: p,
                  onTap: onContents,
                  child:
                      Icon(Icons.format_list_bulleted, color: p.ink, size: 26),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: readerKannadaFont,
                      fontSize: 18,
                      height: 1.3,
                      fontWeight: FontWeight.w600,
                      color: p.ink,
                    ),
                  ),
                ),
              ),
              if (onSearch != null)
                BarButton(
                  label: 'Search',
                  palette: p,
                  onTap: onSearch,
                  child: Icon(Icons.search, color: p.ink, size: 26),
                ),
              BarButton(
                label: 'Change background colour',
                palette: p,
                onTap: onTheme,
                child: Icon(Icons.contrast, color: p.ink, size: 24),
              ),
              BarButton(
                label: 'Smaller text',
                palette: p,
                onTap: onSmaller,
                child: Text('A−',
                    style: TextStyle(
                        fontFamily: readerUiFont,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: p.ink)),
              ),
              BarButton(
                label: 'Larger text',
                palette: p,
                onTap: onLarger,
                child: Text('A+',
                    style: TextStyle(
                        fontFamily: readerUiFont,
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                        color: p.ink)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StripPainter extends CustomPainter {
  final SectionWeights weights;
  final ReaderPosition pos;
  final Color empty;
  final Color fill;

  _StripPainter(this.weights, this.pos, this.empty, this.fill);

  @override
  void paint(Canvas canvas, Size size) {
    final n = weights.weights.length;
    if (n == 0 || weights.total == 0) return;
    final gap = math.min(2.0, size.width / (n * 3));
    final available = math.max(0.0, size.width - gap * (n - 1));
    final emptyPaint = Paint()..color = empty;
    final fillPaint = Paint()..color = fill;
    var x = 0.0;
    for (var i = 0; i < n; i++) {
      final w = available * weights.weights[i] / weights.total;
      canvas.drawRect(Rect.fromLTWH(x, 0, w, size.height), emptyPaint);
      final done = i < pos.index ? 1.0 : (i == pos.index ? pos.r : 0.0);
      if (done > 0) {
        canvas.drawRect(Rect.fromLTWH(x, 0, w * done, size.height), fillPaint);
      }
      x += w + gap;
    }
  }

  @override
  bool shouldRepaint(_StripPainter old) =>
      old.pos != pos ||
      old.empty != empty ||
      old.fill != fill ||
      old.weights != weights;
}

/// Bottom bar: one progress segment per section, then previous / where you
/// are (tap for Contents) / next.
class ReaderLocationBar extends StatelessWidget {
  final List<ReaderSection> sections;
  final SectionWeights weights;
  final ValueListenable<ReaderPosition> position;
  final ReadingPalette palette;
  final int Function() direction;
  final bool animate;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onContents;

  const ReaderLocationBar({
    super.key,
    required this.sections,
    required this.weights,
    required this.position,
    required this.palette,
    required this.direction,
    required this.animate,
    required this.onPrev,
    required this.onNext,
    required this.onContents,
  });

  @override
  Widget build(BuildContext context) {
    final p = palette;
    final n = sections.length;
    final last = sections.lastLabel;
    return Container(
      decoration: BoxDecoration(
        color: p.surface,
        border: Border(top: BorderSide(color: p.line)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ValueListenableBuilder<ReaderPosition>(
            valueListenable: position,
            builder: (context, pos, _) {
              final section = sections[pos.index];
              final place = sections.placeOf(pos.index);
              final numbered = section.label != null;
              final dir = direction();
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 5,
                    width: double.infinity,
                    child: CustomPaint(
                      painter:
                          _StripPainter(weights, pos, p.line, p.accentLine),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _NavButton(
                          palette: p,
                          label: 'Previous section',
                          icon: Icons.chevron_left,
                          onTap: pos.index > 0 ? onPrev : null,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Semantics(
                            button: true,
                            label: '${numbered ? '$place of $last' : place}, '
                                '${section.title}. Open contents',
                            excludeSemantics: true,
                            child: Material(
                              color: p.accentWash,
                              borderRadius: BorderRadius.circular(16),
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: onContents,
                                child: Container(
                                  height: 58,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      _PillTop(
                                        palette: p,
                                        number: place,
                                        total: numbered ? last : null,
                                        direction: dir,
                                        animate: animate,
                                      ),
                                      RollText(
                                        key: const ValueKey('pill-title'),
                                        text: section.title,
                                        direction: dir,
                                        animate: animate,
                                        style: TextStyle(
                                          fontFamily: readerKannadaFont,
                                          fontSize: 17,
                                          height: 1.5,
                                          fontWeight: FontWeight.w600,
                                          color: p.ink,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _NavButton(
                          palette: p,
                          label: 'Next section',
                          icon: Icons.chevron_right,
                          onTap: pos.index < n - 1 ? onNext : null,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PillTop extends StatelessWidget {
  final ReadingPalette palette;
  final String number;

  /// Null for an unnumbered piece, whose [number] reads "Before 1".
  final int? total;
  final int direction;
  final bool animate;

  const _PillTop({
    required this.palette,
    required this.number,
    required this.total,
    required this.direction,
    required this.animate,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontFamily: readerUiFont,
      fontSize: 12,
      height: 1.3,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.24,
      color: palette.accentLine,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RollText(
              key: const ValueKey('pill-number'),
              text: number,
              direction: direction,
              animate: animate,
              style: style,
            ),
            if (total != null) Text(' of $total', style: style),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Contents', style: style),
            Icon(Icons.keyboard_arrow_up, size: 16, color: palette.accentLine),
          ],
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  final ReadingPalette palette;
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const _NavButton({
    required this.palette,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = palette;
    return Semantics(
      button: true,
      enabled: onTap != null,
      label: label,
      excludeSemantics: true,
      child: Opacity(
        opacity: onTap == null ? 0.3 : 1,
        child: Material(
          color: p.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: p.buttonEdge, width: 1.5),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            highlightColor: p.accentWash,
            splashColor: p.accentWash,
            child: SizedBox(
              width: 56,
              height: 58,
              child: Icon(icon, size: 34, color: p.ink),
            ),
          ),
        ),
      ),
    );
  }
}

/// A short message that fades in at the bottom of the reading area.
class ReaderToast extends StatefulWidget {
  final ValueListenable<String?> message;
  final ReadingPalette palette;
  final bool animate;

  const ReaderToast({
    super.key,
    required this.message,
    required this.palette,
    required this.animate,
  });

  @override
  State<ReaderToast> createState() => _ReaderToastState();
}

class _ReaderToastState extends State<ReaderToast> {
  String _last = '';

  @override
  Widget build(BuildContext context) {
    final p = widget.palette;
    return Positioned(
      left: 0,
      right: 0,
      bottom: 16,
      child: IgnorePointer(
        child: ValueListenableBuilder<String?>(
          valueListenable: widget.message,
          builder: (context, text, _) {
            if (text != null) _last = text;
            return AnimatedOpacity(
              opacity: text == null ? 0 : 1,
              duration: widget.animate
                  ? const Duration(milliseconds: 200)
                  : Duration.zero,
              child: Center(
                child: Semantics(
                  liveRegion: true,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: p.bubbleBg,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      _last,
                      style: TextStyle(
                        fontFamily: readerUiFont,
                        fontSize: 15,
                        color: p.bubbleFg,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Which section just got jumped to, so its heading can glow once.
class SectionArrival {
  final int index;
  final int token;
  const SectionArrival(this.index, this.token);
}

/// Rule with the amber number circle (a small dot when [label] is null), then
/// the heading (if any). Glows when [arrival] names this section.
class SectionHeading extends StatefulWidget {
  final int number;
  final int? label;
  final String? headingHtml;
  final ReadingPalette palette;
  final double fontSize;
  final String fontFamily;
  final ValueListenable<SectionArrival?> arrival;
  final bool animate;

  const SectionHeading({
    super.key,
    required this.number,
    required this.label,
    required this.headingHtml,
    required this.palette,
    required this.fontSize,
    required this.fontFamily,
    required this.arrival,
    required this.animate,
  });

  @override
  State<SectionHeading> createState() => _SectionHeadingState();
}

class _SectionHeadingState extends State<SectionHeading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glow = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2000),
    value: 1,
  );
  int? _lastToken;

  @override
  void initState() {
    super.initState();
    widget.arrival.addListener(_onArrival);
    _onArrival();
  }

  @override
  void didUpdateWidget(SectionHeading oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.arrival != widget.arrival) {
      oldWidget.arrival.removeListener(_onArrival);
      widget.arrival.addListener(_onArrival);
    }
  }

  @override
  void dispose() {
    widget.arrival.removeListener(_onArrival);
    _glow.dispose();
    super.dispose();
  }

  void _onArrival() {
    final a = widget.arrival.value;
    if (a == null || a.index != widget.number - 1 || a.token == _lastToken) {
      return;
    }
    _lastToken = a.token;
    if (widget.animate) _glow.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.palette;
    final size = widget.fontSize;
    return AnimatedBuilder(
      animation: _glow,
      builder: (context, child) {
        // Wash holds for the first 30%, then fades; one ring expands early on.
        final t = _glow.value;
        final wash = t < 0.3 ? 1.0 : 1 - (t - 0.3) / 0.7;
        final ring = ((t * 2000 - 100) / 1300).clamp(0.0, 1.0);
        final ringAlpha = p.brightness == Brightness.dark ? 0.45 : 0.55;
        return Container(
          padding: const EdgeInsets.fromLTRB(10, 34, 10, 18),
          decoration: BoxDecoration(
            color: p.accentWash.withValues(alpha: p.accentWash.a * wash),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: Container(height: 1, color: p.line)),
                  const SizedBox(width: 14),
                  Container(
                    constraints: widget.label == null
                        ? const BoxConstraints.tightFor(width: 12, height: 12)
                        : const BoxConstraints(minWidth: 46, minHeight: 46),
                    padding: widget.label == null
                        ? EdgeInsets.zero
                        : const EdgeInsets.symmetric(horizontal: 8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: p.accent,
                      borderRadius: BorderRadius.circular(23),
                      boxShadow: [
                        if (t < 1 && ring > 0 && ring < 1)
                          BoxShadow(
                            color: p.accent
                                .withValues(alpha: ringAlpha * (1 - ring)),
                            spreadRadius: 16 * ring,
                          ),
                      ],
                    ),
                    child: widget.label == null
                        ? null
                        : Text(
                            '${widget.label}',
                            style: TextStyle(
                              fontFamily: readerUiFont,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: p.onAccent,
                              fontFeatures: const [
                                FontFeature.tabularFigures()
                              ],
                            ),
                          ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(child: Container(height: 1, color: p.line)),
                ],
              ),
              if (widget.headingHtml != null) ...[
                const SizedBox(height: 14),
                Html(
                  data: widget.headingHtml,
                  style: {
                    'body': Style(
                      margin: Margins.zero,
                      padding: HtmlPaddings.zero,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w700,
                      fontSize: FontSize(size * 1.15),
                      lineHeight: const LineHeight(1.5),
                      color: p.ink,
                      fontFamily: widget.fontFamily,
                    ),
                    'mark': Style(backgroundColor: p.accent, color: p.onAccent),
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// End-of-section card: the next title and a big tap target.
class NextCard extends StatelessWidget {
  final ReadingPalette palette;
  final String label;
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const NextCard({
    super.key,
    required this.palette,
    required this.label,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = palette;
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 14),
      child: Material(
        color: p.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: p.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          highlightColor: p.accentWash,
          splashColor: p.accentWash,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 70),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(label,
                            style: TextStyle(
                              fontFamily: readerUiFont,
                              fontSize: 13,
                              height: 1.4,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.26,
                              color: p.accentLine,
                            )),
                        Text(title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: readerKannadaFont,
                              fontSize: 18,
                              height: 1.5,
                              fontWeight: FontWeight.w600,
                              color: p.ink,
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(icon, size: 30, color: p.accentLine),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Drag handle on the right edge plus the big bubble that names the section
/// you are passing. The reader owns what the drag means.
class ReaderScrollThumb extends StatefulWidget {
  final ReadingPalette palette;
  final List<ReaderSection> sections;
  final ValueListenable<ReaderPosition> position;
  final ValueListenable<double> fraction;
  final ValueListenable<bool> scrolling;
  final ValueListenable<bool> travelling;
  final ValueListenable<bool> dragging;
  final int Function() direction;
  final bool animate;
  final VoidCallback onDragStart;
  final ValueChanged<double> onDrag;
  final VoidCallback onDragEnd;

  const ReaderScrollThumb({
    super.key,
    required this.palette,
    required this.sections,
    required this.position,
    required this.fraction,
    required this.scrolling,
    required this.travelling,
    required this.dragging,
    required this.direction,
    required this.animate,
    required this.onDragStart,
    required this.onDrag,
    required this.onDragEnd,
  });

  @override
  State<ReaderScrollThumb> createState() => _ReaderScrollThumbState();
}

class _ReaderScrollThumbState extends State<ReaderScrollThumb> {
  static const _thumbHeight = 68.0;
  double _dragY = 0;

  Duration get _fast =>
      widget.animate ? const Duration(milliseconds: 250) : Duration.zero;

  @override
  Widget build(BuildContext context) {
    final p = widget.palette;
    return Positioned(
      top: 10,
      bottom: 10,
      right: 0,
      width: 44,
      child: LayoutBuilder(builder: (context, box) {
        final track = math.max(1.0, box.maxHeight - _thumbHeight);
        return AnimatedBuilder(
          animation: Listenable.merge([
            widget.fraction,
            widget.scrolling,
            widget.travelling,
            widget.dragging,
          ]),
          builder: (context, _) {
            final dragging = widget.dragging.value;
            final y = widget.fraction.value.clamp(0.0, 1.0) * track;
            final bubbleVisible = dragging || widget.travelling.value;
            final bubbleY = (y + _thumbHeight / 2)
                .clamp(math.min(56.0, box.maxHeight / 2),
                    math.max(box.maxHeight - 56, box.maxHeight / 2))
                .toDouble();
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: bubbleY,
                  right: 50,
                  child: IgnorePointer(
                    child: FractionalTranslation(
                      translation: const Offset(0, -0.5),
                      child: AnimatedOpacity(
                        key: const ValueKey('bubble-opacity'),
                        opacity: bubbleVisible ? 1 : 0,
                        duration: _fast,
                        child: _Bubble(
                          palette: p,
                          sections: widget.sections,
                          position: widget.position,
                          direction: widget.direction,
                          animate: widget.animate,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: y,
                  right: 0,
                  width: 40,
                  height: _thumbHeight,
                  child: GestureDetector(
                    key: const ValueKey('scroll-thumb'),
                    behavior: HitTestBehavior.opaque,
                    dragStartBehavior: DragStartBehavior.down,
                    onVerticalDragStart: (_) {
                      _dragY = y;
                      widget.onDragStart();
                    },
                    onVerticalDragUpdate: (d) {
                      _dragY = (_dragY + d.delta.dy).clamp(0.0, track);
                      widget.onDrag(_dragY / track);
                    },
                    onVerticalDragEnd: (_) => widget.onDragEnd(),
                    onVerticalDragCancel: widget.onDragEnd,
                    child: Semantics(
                      label: 'Scroll through the book',
                      child: AnimatedOpacity(
                        opacity: dragging || widget.scrolling.value ? 1 : 0.35,
                        duration: _fast,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 5, top: 8, bottom: 8),
                            child: AnimatedContainer(
                              duration: widget.animate
                                  ? const Duration(milliseconds: 150)
                                  : Duration.zero,
                              width: dragging ? 12 : 6,
                              decoration: BoxDecoration(
                                color: p.accentLine,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }
}

class _Bubble extends StatelessWidget {
  final ReadingPalette palette;
  final List<ReaderSection> sections;
  final ValueListenable<ReaderPosition> position;
  final int Function() direction;
  final bool animate;

  const _Bubble({
    required this.palette,
    required this.sections,
    required this.position,
    required this.direction,
    required this.animate,
  });

  @override
  Widget build(BuildContext context) {
    final p = palette;
    final maxWidth = math.min(240.0, MediaQuery.sizeOf(context).width * 0.62);
    return ValueListenableBuilder<ReaderPosition>(
      valueListenable: position,
      builder: (context, pos, _) {
        final dir = direction();
        final fg = p.bubbleFg;
        final numbered = sections[pos.index].label != null;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: -6,
              top: 0,
              bottom: 0,
              child: Center(
                child: Transform.rotate(
                  angle: math.pi / 4,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: p.bubbleBg,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              constraints: BoxConstraints(maxWidth: maxWidth),
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
              decoration: BoxDecoration(
                color: p.bubbleBg,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x80050419),
                      blurRadius: 34,
                      offset: Offset(0, 14),
                      spreadRadius: -10),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      RollText(
                        key: const ValueKey('bubble-number'),
                        text: sections.placeOf(pos.index),
                        direction: dir,
                        animate: animate,
                        style: TextStyle(
                          fontFamily: readerUiFont,
                          // "Before 1" / "After 33" read smaller than a number.
                          fontSize: numbered ? 36 : 20,
                          height: 1.1,
                          fontWeight: FontWeight.w600,
                          color: fg,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      if (numbered) ...[
                        const SizedBox(width: 6),
                        Text('/ ${sections.lastLabel}',
                            style: TextStyle(
                              fontFamily: readerUiFont,
                              fontSize: 14,
                              color: fg.withValues(alpha: 0.7),
                            )),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  _RollTitle(
                    text: sections[pos.index].title,
                    direction: dir,
                    animate: animate,
                    style: TextStyle(
                      fontFamily: readerKannadaFont,
                      fontSize: 16,
                      height: 1.45,
                      fontWeight: FontWeight.w600,
                      color: fg,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Two-line version of [RollText] for the bubble.
class _RollTitle extends StatefulWidget {
  final String text;
  final TextStyle style;
  final int direction;
  final bool animate;

  const _RollTitle({
    required this.text,
    required this.style,
    required this.direction,
    required this.animate,
  });

  @override
  State<_RollTitle> createState() => _RollTitleState();
}

class _RollTitleState extends State<_RollTitle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 340),
    value: 1,
  );
  late int _direction = widget.direction;

  @override
  void didUpdateWidget(_RollTitle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text && widget.animate) {
      _direction = widget.direction;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = _ease.transform(_controller.value);
          return Opacity(
            opacity: t,
            child: FractionalTranslation(
              translation: Offset(0, (1 - t) * (_direction > 0 ? 0.75 : -0.75)),
              child: child,
            ),
          );
        },
        child: Text(
          widget.text,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: widget.style,
        ),
      ),
    );
  }
}

/// Contents screen: resume card, go-to-number, then every section.
class ReaderContentsScreen extends StatelessWidget {
  final List<ReaderSection> sections;
  final String bookTitle;
  final ReadingPalette palette;
  final int current;
  final bool started;
  final VoidCallback onClose;
  final ValueChanged<int> onGo;
  final VoidCallback onSearch;

  const ReaderContentsScreen({
    super.key,
    required this.sections,
    required this.bookTitle,
    required this.palette,
    required this.current,
    required this.started,
    required this.onClose,
    required this.onGo,
    required this.onSearch,
  });

  // Items before the section rows: resume card and go-to-number form.
  static const _lead = 2;

  @override
  Widget build(BuildContext context) {
    // Always the app's blue screen with white text, like the books list and
    // the old chapters list, so long-time readers recognise it.
    const p = ReadingPalette.appBlue;
    final n = sections.length;
    // Open with the current row in the middle; near the top the list simply
    // starts at the top.
    final centre = current >= 4;
    return Material(
      color: p.background,
      child: Container(
        decoration: const BoxDecoration(gradient: ReadingPalette.appGradient),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: p.bar,
                border: Border(bottom: BorderSide(color: p.line)),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
                  child: Row(
                    children: [
                      BarButton(
                        label: 'Back to reading',
                        palette: p,
                        width: 48,
                        onTap: onClose,
                        child: Icon(Icons.keyboard_arrow_down,
                            color: p.ink, size: 34),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Contents',
                                style: TextStyle(
                                  fontFamily: readerUiFont,
                                  fontSize: 21,
                                  height: 1.3,
                                  fontWeight: FontWeight.w600,
                                  color: p.ink,
                                )),
                            Text('$bookTitle · $n sections',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: readerKannadaFont,
                                  fontSize: 14,
                                  height: 1.4,
                                  color: p.muted,
                                )),
                          ],
                        ),
                      ),
                      BarButton(
                        label: 'Search',
                        palette: p,
                        width: 48,
                        onTap: onSearch,
                        child: Icon(Icons.search, color: p.ink, size: 28),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ScrollablePositionedList.builder(
                itemCount: n + _lead,
                initialScrollIndex: centre ? current + _lead : 0,
                initialAlignment: centre ? 0.4 : 0,
                padding: EdgeInsets.only(
                  bottom: 40 + MediaQuery.viewInsetsOf(context).bottom,
                ),
                itemBuilder: (context, k) {
                  if (k == 0) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: _ResumeCard(
                        palette: p,
                        label: started ? 'Continue reading' : 'Start reading',
                        title: sections[current].label == null
                            ? sections[current].title
                            : '${sections[current].label} · '
                                '${sections[current].title}',
                        onTap: onClose,
                      ),
                    );
                  }
                  if (k == 1) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
                      child: _GoToNumber(
                          palette: p,
                          count: sections.lastLabel,
                          resolve: sections.indexOfLabel,
                          onGo: onGo),
                    );
                  }
                  final i = k - _lead;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _ContentsRow(
                      palette: p,
                      section: sections[i],
                      isCurrent: i == current,
                      onTap: () => onGo(i),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResumeCard extends StatelessWidget {
  final ReadingPalette palette;
  final String label;
  final String title;
  final VoidCallback onTap;

  const _ResumeCard({
    required this.palette,
    required this.label,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = palette;
    return Material(
      color: p.accent,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: const ValueKey('resume-card'),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 76),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: TextStyle(
                            fontFamily: readerUiFont,
                            fontSize: 13,
                            height: 1.4,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.26,
                            color: p.onAccent.withValues(alpha: 0.85),
                          )),
                      Text(title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: readerKannadaFont,
                            fontSize: 19,
                            height: 1.5,
                            fontWeight: FontWeight.w600,
                            color: p.onAccent,
                          )),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.chevron_right, size: 30, color: p.onAccent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GoToNumber extends StatefulWidget {
  final ReadingPalette palette;

  /// Highest number in the book, for the error message.
  final int count;

  /// Section index showing a number, or null if no section has it.
  final int? Function(int) resolve;

  /// Called with the section index.
  final ValueChanged<int> onGo;

  const _GoToNumber({
    required this.palette,
    required this.count,
    required this.resolve,
    required this.onGo,
  });

  @override
  State<_GoToNumber> createState() => _GoToNumberState();
}

class _GoToNumberState extends State<_GoToNumber> {
  final TextEditingController _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    // Kannada digits count as numbers too.
    final text = _controller.text.replaceAllMapped(
        RegExp('[೦-೯]'), (m) => '${m.group(0)!.codeUnitAt(0) - 0x0CE6}');
    final n = int.tryParse(text.trim());
    final index = n == null ? null : widget.resolve(n);
    if (index == null) {
      setState(() => _error = 'Enter a number from 1 to ${widget.count}.');
      return;
    }
    setState(() => _error = null);
    _controller.clear();
    FocusManager.instance.primaryFocus?.unfocus();
    widget.onGo(index);
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.palette;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: p.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Go to number',
                    style: TextStyle(
                      fontFamily: readerUiFont,
                      fontSize: 16,
                      height: 1.3,
                      fontWeight: FontWeight.w600,
                      color: p.ink,
                    )),
              ),
              SizedBox(
                width: 96,
                height: 52,
                child: TextField(
                  key: const ValueKey('go-to-number'),
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.go,
                  textAlign: TextAlign.center,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9೦-೯]')),
                  ],
                  onSubmitted: (_) => _submit(),
                  cursorColor: p.accentLine,
                  style: TextStyle(
                    fontFamily: readerUiFont,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: p.ink,
                  ),
                  decoration: InputDecoration(
                    hintText: '1–${widget.count}',
                    hintStyle: TextStyle(
                        fontFamily: readerUiFont, fontSize: 16, color: p.muted),
                    filled: true,
                    fillColor: p.background,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: p.buttonEdge),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: p.accentLine, width: 2.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 52,
                child: Material(
                  color: p.accent,
                  borderRadius: BorderRadius.circular(12),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    key: const ValueKey('go-button'),
                    onTap: _submit,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: Text('Go',
                            style: TextStyle(
                              fontFamily: readerUiFont,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: p.onAccent,
                            )),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(_error!,
                  style: TextStyle(
                    fontFamily: readerUiFont,
                    fontSize: 14,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                    color: p.accentLine,
                  )),
            ),
        ],
      ),
    );
  }
}

class _ContentsRow extends StatelessWidget {
  final ReadingPalette palette;
  final ReaderSection section;
  final bool isCurrent;
  final VoidCallback onTap;

  const _ContentsRow({
    required this.palette,
    required this.section,
    required this.isCurrent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = palette;
    return Semantics(
      button: true,
      selected: isCurrent,
      child: Container(
        decoration: BoxDecoration(
          color: isCurrent ? p.accentWash : null,
          borderRadius: isCurrent ? BorderRadius.circular(14) : null,
          border: isCurrent ? null : Border(bottom: BorderSide(color: p.line)),
        ),
        child: InkWell(
          key: ValueKey('toc-row-${section.number}'),
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 68),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCurrent ? p.accent : null,
                      border: Border.all(
                          color: isCurrent ? p.accent : p.line, width: 1.5),
                    ),
                    child: section.label == null
                        ? Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCurrent ? p.onAccent : p.muted,
                            ),
                          )
                        : Text('${section.label}',
                            style: TextStyle(
                              fontFamily: readerUiFont,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isCurrent ? p.onAccent : p.muted,
                              fontFeatures: const [
                                FontFeature.tabularFigures()
                              ],
                            )),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isCurrent)
                          Text('Now reading',
                              style: TextStyle(
                                fontFamily: readerUiFont,
                                fontSize: 12,
                                height: 1.4,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.36,
                                color: p.accentLine,
                              )),
                        Text(section.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: readerKannadaFont,
                              fontSize: 18,
                              height: 1.5,
                              fontWeight: FontWeight.w500,
                              color: p.ink,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
