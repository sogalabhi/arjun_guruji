import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Shared motion tokens so everything in the app moves the same way.
/// Calm by default: short durations, no bouncy easing.
class Motion {
  Motion._();

  // Durations.
  static const Duration quick = Duration(milliseconds: 150);
  static const Duration standard = Duration(milliseconds: 300);
  static const Duration emphasis = Duration(milliseconds: 450);

  /// True when the user asked the OS to reduce animations.
  static bool reduced(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context);

  /// [d], or [Duration.zero] when reduce-motion is on.
  static Duration duration(BuildContext context, Duration d) =>
      reduced(context) ? Duration.zero : d;
}

/// Shared curves.
class MotionCurves {
  MotionCurves._();

  static const Curve standard = Curves.easeOutCubic;
  // Gentle settle with a tiny overshoot, never bouncy.
  static const Curve spring = Cubic(0.34, 1.1, 0.64, 1.0);
}

/// Haptic feedback helpers.
class Haptics {
  Haptics._();

  /// Light tap for presses and play/pause.
  static void tap() => HapticFeedback.lightImpact();

  /// Selection tick for toggles and pickers.
  static void select() => HapticFeedback.selectionClick();
}
