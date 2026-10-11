import 'package:animations/animations.dart';
import 'package:arjun_guruji/core/motion/motion.dart';
import 'package:flutter/material.dart';

/// Home menu tile: staggered entrance (first Home build per session only)
/// and a small press-down scale.
class AnimatedGridItem extends StatefulWidget {
  final Map<String, dynamic> item;
  final int index;
  final int columns;

  const AnimatedGridItem({
    super.key,
    required this.item,
    required this.index,
    required this.columns,
  });

  // Entrance plays once per app session, not on every return to Home.
  static bool _entrancePlayed = false;

  @override
  State<AnimatedGridItem> createState() => _AnimatedGridItemState();
}

class _AnimatedGridItemState extends State<AnimatedGridItem>
    with SingleTickerProviderStateMixin {
  static const Duration _rowDelay = Duration(milliseconds: 70);
  static const double _slideDistance = 12;
  static const Color _tileColor = Color.fromARGB(255, 255, 209, 70);

  late final AnimationController _controller;
  late final Animation<double> _progress;
  late final bool _playEntrance;
  bool _started = false;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _playEntrance = !AnimatedGridItem._entrancePlayed;

    // Stagger by row; the delay is a real start delay via the Interval.
    final delay = _rowDelay * (widget.index ~/ widget.columns);
    final total = Motion.standard + delay;
    _controller = AnimationController(vsync: this, duration: total);
    _progress = CurvedAnimation(
      parent: _controller,
      curve: Interval(
        delay.inMilliseconds / total.inMilliseconds,
        1.0,
        curve: MotionCurves.standard,
      ),
    );

    // Mark as played once the first frame (all visible tiles) is built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AnimatedGridItem._entrancePlayed = true;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (_playEntrance && !Motion.reduced(context)) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final reduced = Motion.reduced(context);

    // The yellow tile grows into its page and shrinks back on return.
    final tile = AnimatedScale(
      scale: _pressed && !reduced ? 0.97 : 1.0,
      duration: Motion.duration(context, Motion.quick),
      curve: MotionCurves.spring,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: OpenContainer(
          transitionType: ContainerTransitionType.fadeThrough,
          transitionDuration: Motion.duration(context, Motion.emphasis),
          closedColor: _tileColor,
          closedElevation: 1,
          closedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          openColor: const Color(0xFF010036),
          middleColor: const Color(0xFF010036),
          tappable: false,
          openBuilder: (context, _) => item['page'] as Widget,
          closedBuilder: (context, open) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (_) => _setPressed(true),
            onTapUp: (_) => _setPressed(false),
            onTapCancel: () => _setPressed(false),
            onTap: () {
              Haptics.tap();
              open();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  item['imagePath'],
                  height: 50,
                  width: 50,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),
                Text(
                  item['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _progress,
      child: tile,
      builder: (context, child) {
        final t = _progress.value;
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, _slideDistance * (1 - t)),
            child: Transform.scale(
              scale: 0.96 + 0.04 * t,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
