import 'dart:math' as math;

import 'package:hive/hive.dart';

import 'section_parser.dart';

/// Where the reader is: a section (0-based) and how far through it (0-1).
class ReaderPosition {
  final int index;
  final double r;
  const ReaderPosition(this.index, this.r);

  @override
  bool operator ==(Object other) =>
      other is ReaderPosition && other.index == index && other.r == r;

  @override
  int get hashCode => Object.hash(index, r);

  @override
  String toString() => 'ReaderPosition($index, ${r.toStringAsFixed(3)})';
}

/// Maps between a (section, r) position and a 0-1 fraction of the whole book,
/// weighting each section by its length. The list is lazy, so there is no
/// total pixel height to use instead.
class SectionWeights {
  /// Smallest weight a section gets, so tiny sections stay tappable.
  static const minWeight = 400;

  final List<double> weights;
  final List<double> _before;
  final double total;

  SectionWeights._(this.weights, this._before, this.total);

  factory SectionWeights.of(List<ReaderSection> sections) {
    final weights =
        sections.map((s) => math.max(s.length, minWeight).toDouble()).toList();
    final before = <double>[];
    var sum = 0.0;
    for (final w in weights) {
      before.add(sum);
      sum += w;
    }
    return SectionWeights._(weights, before, sum);
  }

  double fractionOf(ReaderPosition p) {
    if (total == 0) return 0;
    return ((_before[p.index] + p.r * weights[p.index]) / total)
        .clamp(0.0, 1.0);
  }

  ReaderPosition positionAt(double fraction) {
    final target = fraction.clamp(0.0, 1.0) * total;
    var i = weights.length - 1;
    while (i > 0 && _before[i] > target) {
      i--;
    }
    final r = ((target - _before[i]) / weights[i]).clamp(0.0, 1.0);
    return ReaderPosition(i, r);
  }
}

/// Saves the reading place per content in the settings box under
/// `pos:<kind>:<title>`. A null box disables saving.
class ReaderPositionStore {
  final Box? _box;
  final String key;

  ReaderPositionStore(this._box, {required String kind, required String title})
      : key = 'pos:$kind:$title';

  void save(List<ReaderSection> sections, ReaderPosition p) {
    final box = _box;
    if (box == null || p.index < 0 || p.index >= sections.length) return;
    try {
      box.put(key, {
        'index': p.index,
        'title': sections[p.index].title,
        'r': p.r,
      });
    } catch (_) {
      // Resume is a convenience; never let it break reading.
    }
  }

  /// Same title at the saved index, else the first section with that title,
  /// else the saved index clamped into range.
  ReaderPosition? restore(List<ReaderSection> sections) {
    final box = _box;
    if (box == null || sections.length < 2) return null;
    try {
      final saved = box.get(key);
      if (saved is! Map) return null;
      final index = (saved['index'] as num).toInt();
      final title = saved['title'] as String;
      final r = ((saved['r'] as num).toDouble()).clamp(0.0, 1.0);
      if (index >= 0 &&
          index < sections.length &&
          sections[index].title == title) {
        return ReaderPosition(index, r);
      }
      final byTitle = sections.indexWhere((s) => s.title == title);
      if (byTitle != -1) return ReaderPosition(byTitle, r);
      return ReaderPosition(index.clamp(0, sections.length - 1), r);
    } catch (_) {
      return null;
    }
  }
}
