import 'dart:async';
import 'dart:math' as math;

import 'package:arjun_guruji/core/motion/motion.dart';
import 'package:arjun_guruji/features/EventManagement/domain/entity/panchang_info.dart';
import 'package:flutter/material.dart';

/// Sunrise-to-sunset arc with Rahu Kaala, Yamaganda and Gulika marked on it
/// and, for today, the sun at the current time. Draws itself in when the day
/// or city changes; the sun moves once a minute.
class PanchangDayArc extends StatefulWidget {
  final PanchangInfoEntity info;

  const PanchangDayArc({super.key, required this.info});

  @override
  State<PanchangDayArc> createState() => _PanchangDayArcState();
}

class _PanchangDayArcState extends State<PanchangDayArc>
    with SingleTickerProviderStateMixin {
  late final AnimationController _draw;
  Timer? _minuteTimer;
  DateTime _now = DateTime.now();
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _draw = AnimationController(
      vsync: this,
      duration: Motion.emphasis * 2,
    );
    _syncMinuteTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    _drawIn();
  }

  @override
  void didUpdateWidget(PanchangDayArc oldWidget) {
    super.didUpdateWidget(oldWidget);
    final old = oldWidget.info;
    if (!DateUtils.isSameDay(old.date, widget.info.date) ||
        old.cityName != widget.info.cityName) {
      _drawIn();
      _syncMinuteTimer();
    }
  }

  void _drawIn() {
    if (Motion.reduced(context)) {
      _draw.value = 1;
    } else {
      _draw.forward(from: 0);
    }
  }

  // Tick once a minute, but only while showing today.
  void _syncMinuteTimer() {
    _minuteTimer?.cancel();
    _minuteTimer = null;
    if (!_isToday) return;
    _minuteTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  bool get _isToday => DateUtils.isSameDay(widget.info.date, DateTime.now());

  @override
  void dispose() {
    _minuteTimer?.cancel();
    _draw.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final info = widget.info;
    final periods = [
      _Period('Rahu', 'Rahu Kaala', info.rahuStartUtc, info.rahuEndUtc,
          const Color(0xFFFFA000)),
      _Period('Yama', 'Yamaganda', info.yamagandamStartUtc,
          info.yamagandamEndUtc, const Color(0xFFFF7043)),
      _Period('Gulika', 'Gulika Kaala', info.gulikaStartUtc, info.gulikaEndUtc,
          const Color(0xFF4DD0E1)),
    ];
    final now = _isToday ? _now.toUtc() : null;
    final dayFraction = now == null ? null : _fraction(now, info);
    final current = now == null
        ? null
        : periods.where((p) => !now.isBefore(p.start) && now.isBefore(p.end)).firstOrNull;

    final (String headline, String detail) = switch (dayFraction) {
      null => ('Day length ${_formatLength(info.sunsetUtc.difference(info.sunriseUtc))}', ''),
      < 0 => ('Now ${_formatIst(now!)}', 'Sunrise at ${info.formattedSunriseIst}'),
      > 1 => ('Now ${_formatIst(now!)}', 'The sun has set'),
      _ => (
          'Now ${_formatIst(now!)}',
          current != null
              ? 'In ${current.name} until ${_formatIst(current.end)}'
              : 'Sunset at ${info.formattedSunsetIst}',
        ),
    };

    return Semantics(
      label: '$headline. $detail',
      excludeSemantics: true,
      child: AspectRatio(
        aspectRatio: 2,
        child: AnimatedBuilder(
          animation: _draw,
          builder: (context, _) => CustomPaint(
            painter: _DayArcPainter(
              progress: MotionCurves.standard.transform(_draw.value),
              periods: [
                for (final p in periods)
                  (p, _fraction(p.start, info), _fraction(p.end, info)),
              ],
              sunFraction: dayFraction != null && dayFraction >= 0 && dayFraction <= 1
                  ? dayFraction
                  : null,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      headline,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (detail.isNotEmpty)
                      Text(
                        detail,
                        style: TextStyle(
                          color: current != null ? current.color : Colors.white70,
                          fontSize: 14,
                          fontWeight: current != null ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Position of [t] between sunrise (0) and sunset (1); outside the day it
  // goes below 0 or above 1.
  static double _fraction(DateTime t, PanchangInfoEntity info) {
    final start = info.sunriseUtc.millisecondsSinceEpoch;
    final length = info.sunsetUtc.millisecondsSinceEpoch - start;
    if (length <= 0) return 0;
    return (t.millisecondsSinceEpoch - start) / length;
  }

  static String _formatIst(DateTime utc) {
    final ist = utc.toUtc().add(const Duration(hours: 5, minutes: 30));
    final h = ist.hour > 12 ? ist.hour - 12 : (ist.hour == 0 ? 12 : ist.hour);
    final m = ist.minute.toString().padLeft(2, '0');
    final period = ist.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
  }

  static String _formatLength(Duration d) => '${d.inHours}h ${d.inMinutes % 60}m';
}

class _Period {
  final String label; // short label drawn on the arc
  final String name;
  final DateTime start;
  final DateTime end;
  final Color color;

  const _Period(this.label, this.name, this.start, this.end, this.color);
}

class _DayArcPainter extends CustomPainter {
  final double progress; // 0..1 draw-in
  final List<(_Period, double, double)> periods; // period, start, end fractions
  final double? sunFraction;

  _DayArcPainter({
    required this.progress,
    required this.periods,
    required this.sunFraction,
  });

  static const double _labelGap = 18;

  @override
  void paint(Canvas canvas, Size size) {
    // Semicircle sitting on the bottom edge, leaving room for labels on top.
    final radius = math.min(size.width / 2 - 40, size.height - _labelGap - 20);
    final center = Offset(size.width / 2, size.height - 6);
    final rect = Rect.fromCircle(center: center, radius: radius);
    // Fraction of the day to angle: sunrise on the left, over the top, sunset on the right.
    double angle(double f) => math.pi + math.pi * f;

    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..color = Colors.white24;
    canvas.drawArc(rect, angle(0), math.pi * progress, false, base);

    // The part of today already gone.
    final sun = sunFraction;
    if (sun != null) {
      final elapsed = math.min(sun, progress);
      if (elapsed > 0) {
        canvas.drawArc(rect, angle(0), math.pi * elapsed, false,
            base..color = Colors.white60);
      }
    }

    for (final (period, start, end) in periods) {
      final from = start.clamp(0.0, 1.0);
      final to = math.min(end.clamp(0.0, 1.0), progress);
      if (to <= from) continue;
      canvas.drawArc(
        rect,
        angle(from),
        math.pi * (to - from),
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10
          ..strokeCap = StrokeCap.butt
          ..color = period.color,
      );
      // Label outside the arc once its segment is fully drawn.
      if (progress >= end.clamp(0.0, 1.0)) {
        final mid = angle((from + end.clamp(0.0, 1.0)) / 2);
        final at = center + Offset(math.cos(mid), math.sin(mid)) * (radius + _labelGap);
        final text = TextPainter(
          text: TextSpan(
            text: period.label,
            style: TextStyle(
              color: period.color,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        text.paint(canvas, at - Offset(text.width / 2, text.height / 2));
      }
    }

    // Sun at the current time, appearing as the sweep reaches it.
    if (sun != null && progress >= sun) {
      final at = center + Offset(math.cos(angle(sun)), math.sin(angle(sun))) * radius;
      canvas.drawCircle(at, 9, Paint()..color = const Color(0xFF010036));
      canvas.drawCircle(at, 7, Paint()..color = const Color(0xFFFFD146));
    }
  }

  @override
  bool shouldRepaint(_DayArcPainter old) =>
      old.progress != progress || old.sunFraction != sunFraction || old.periods != periods;
}
