import 'package:flutter/material.dart';

/// Colours for the reader, one set per `readingTheme` setting value.
/// Amber is only ever a fill; text and thin lines use [accentLine].
class ReadingPalette {
  final Color background;
  final Color bar;
  final Color surface;
  final Color ink;
  final Color muted;
  final Color line;
  final Color buttonEdge;
  final Color accent;
  final Color onAccent;
  final Color accentLine;
  final Color accentWash;
  final Color bubbleBg;
  final Color bubbleFg;
  final Brightness brightness;

  const ReadingPalette({
    required this.background,
    required this.bar,
    required this.surface,
    required this.ink,
    required this.muted,
    required this.line,
    required this.buttonEdge,
    required this.accent,
    required this.onAccent,
    required this.accentLine,
    required this.accentWash,
    required this.bubbleBg,
    required this.bubbleFg,
    required this.brightness,
  });

  static const _amber = Color(0xFFFFA000);
  static const _navy = Color(0xFF010036);

  static const light = ReadingPalette(
    background: Color(0xFFFBF7EF),
    bar: Color(0xFFF2EADC),
    surface: Color(0xFFFFFDF8),
    ink: Color(0xFF000000),
    muted: Color(0xFF5C5045),
    line: Color(0xFFDDD1BD),
    buttonEdge: Color(0xFF9C8C76),
    accent: _amber,
    onAccent: Color(0xFF000000),
    accentLine: _navy,
    accentWash: Color(0x3DFFA000), // amber at 24%
    bubbleBg: _navy,
    bubbleFg: Color(0xFFFFFFFF),
    brightness: Brightness.light,
  );

  static const sepia = ReadingPalette(
    background: Color(0xFFF4ECD8),
    bar: Color(0xFFEADFC6),
    surface: Color(0xFFFAF4E6),
    ink: Color(0xFF000000),
    muted: Color(0xFF5E4A39),
    line: Color(0xFFD9C9A8),
    buttonEdge: Color(0xFF9A8463),
    accent: _amber,
    onAccent: Color(0xFF000000),
    accentLine: _navy,
    accentWash: Color(0x3DFFA000), // amber at 24%
    bubbleBg: _navy,
    bubbleFg: Color(0xFFFFFFFF),
    brightness: Brightness.light,
  );

  static const dark = ReadingPalette(
    background: Color(0xFF15120F),
    bar: Color(0xFF1E1A16),
    surface: Color(0xFF241F1A),
    ink: Color(0xFFEDE6D8),
    muted: Color(0xFFB9AE9E),
    line: Color(0xFF3A322A),
    buttonEdge: Color(0xFF6E6253),
    accent: _amber,
    onAccent: Color(0xFF000000),
    accentLine: _amber,
    accentWash: Color(0x29FFA000), // amber at 16%
    bubbleBg: Color(0xFFEDE6D8),
    bubbleFg: Color(0xFF15120F),
    brightness: Brightness.dark,
  );

  /// The app's own navy-to-blue screens (books list, the old chapters list):
  /// white text on [appGradient]. The contents screen uses this whatever the
  /// reading theme, so it looks like the rest of the app.
  static const appBlue = ReadingPalette(
    background: Color(0xFF010036),
    bar: Color(0x00000000),
    surface: Color(0x1AFFFFFF),
    ink: Color(0xFFFFFFFF),
    muted: Color(0xCCFFFFFF),
    line: Color(0x33FFFFFF),
    buttonEdge: Color(0x8AFFFFFF),
    accent: _amber,
    onAccent: Color(0xFF000000),
    accentLine: _amber,
    accentWash: Color(0x29FFA000),
    bubbleBg: Color(0xFFFFFFFF),
    bubbleFg: _navy,
    brightness: Brightness.dark,
  );

  /// Same colours and direction as the app's GradientBackground.
  static const appGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color.fromARGB(255, 1, 0, 54), Color.fromARGB(255, 51, 47, 255)],
  );

  /// Unknown theme names fall back to light.
  static ReadingPalette of(String readingTheme) {
    switch (readingTheme) {
      case 'sepia':
        return sepia;
      case 'dark':
        return dark;
      default:
        return light;
    }
  }
}
