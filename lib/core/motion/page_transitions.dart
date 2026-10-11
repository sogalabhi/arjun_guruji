import 'dart:ui' show lerpDouble;

import 'package:animations/animations.dart';
import 'package:arjun_guruji/core/motion/motion.dart';
import 'package:flutter/material.dart';

/// App-wide page transition: a horizontal shared-axis slide and fade through
/// the app's navy, or no animation when the phone's "remove animations"
/// setting is on.
class MotionPageTransitionsBuilder extends PageTransitionsBuilder {
  const MotionPageTransitionsBuilder();

  static const _sharedAxis = SharedAxisPageTransitionsBuilder(
    transitionType: SharedAxisTransitionType.horizontal,
    fillColor: Color(0xFF010036),
  );

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (Motion.reduced(context)) return child;
    return _sharedAxis.buildTransitions(
        route, context, animation, secondaryAnimation, child);
  }
}

/// A page that grows out of [sourceRect] and shrinks back into it on close.
/// For widgets outside the Navigator (the global mini player), where
/// OpenContainer can't be used.
class ExpandRoute<T> extends PageRouteBuilder<T> {
  ExpandRoute({
    required WidgetBuilder builder,
    required Rect sourceRect,
    required Color sourceColor,
    double sourceRadius = 12,
  }) : super(
          transitionDuration: Motion.emphasis,
          reverseTransitionDuration: Motion.standard,
          pageBuilder: (context, _, __) => builder(context),
          transitionsBuilder: (context, animation, _, child) {
            if (Motion.reduced(context)) return child;
            final curved = CurvedAnimation(
              parent: animation,
              curve: MotionCurves.standard,
              reverseCurve: Curves.easeInCubic,
            );
            return AnimatedBuilder(
              animation: curved,
              child: child,
              builder: (context, child) {
                final t = curved.value;
                final screen = Offset.zero & MediaQuery.sizeOf(context);
                // The source colour fills the growing shape; the page fades
                // in over it once the shape is large enough to read.
                return ClipPath(
                  clipper: _RoundedRectClipper(
                    Rect.lerp(sourceRect, screen, t)!,
                    lerpDouble(sourceRadius, 0, t)!,
                  ),
                  child: ColoredBox(
                    color: sourceColor,
                    child: Opacity(
                      opacity: const Interval(0.15, 0.6).transform(t),
                      child: child,
                    ),
                  ),
                );
              },
            );
          },
        );
}

class _RoundedRectClipper extends CustomClipper<Path> {
  final Rect rect;
  final double radius;

  const _RoundedRectClipper(this.rect, this.radius);

  @override
  Path getClip(Size size) =>
      Path()..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));

  @override
  bool shouldReclip(_RoundedRectClipper oldClipper) =>
      oldClipper.rect != rect || oldClipper.radius != radius;
}
