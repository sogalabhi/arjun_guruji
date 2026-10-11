import 'package:arjun_guruji/core/reader/reading_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('light values', () {
    final p = ReadingPalette.of('light');
    expect(p.background, const Color(0xFFFBF7EF));
    expect(p.bar, const Color(0xFFF2EADC));
    expect(p.surface, const Color(0xFFFFFDF8));
    expect(p.ink, const Color(0xFF000000));
    expect(p.muted, const Color(0xFF5C5045));
    expect(p.line, const Color(0xFFDDD1BD));
    expect(p.buttonEdge, const Color(0xFF9C8C76));
    expect(p.accent, const Color(0xFFFFA000));
    expect(p.onAccent, const Color(0xFF000000));
    expect(p.accentLine, const Color(0xFF010036));
    expect(p.accentWash, const Color(0x3DFFA000));
    expect(p.bubbleBg, const Color(0xFF010036));
    expect(p.bubbleFg, const Color(0xFFFFFFFF));
  });

  test('sepia values', () {
    final p = ReadingPalette.of('sepia');
    expect(p.background, const Color(0xFFF4ECD8));
    expect(p.bar, const Color(0xFFEADFC6));
    expect(p.surface, const Color(0xFFFAF4E6));
    expect(p.ink, const Color(0xFF000000));
    expect(p.muted, const Color(0xFF5E4A39));
    expect(p.line, const Color(0xFFD9C9A8));
    expect(p.buttonEdge, const Color(0xFF9A8463));
    expect(p.accentLine, const Color(0xFF010036));
    expect(p.accentWash, const Color(0x3DFFA000));
    expect(p.bubbleBg, const Color(0xFF010036));
  });

  test('dark values', () {
    final p = ReadingPalette.of('dark');
    expect(p.background, const Color(0xFF15120F));
    expect(p.bar, const Color(0xFF1E1A16));
    expect(p.surface, const Color(0xFF241F1A));
    expect(p.ink, const Color(0xFFEDE6D8));
    expect(p.muted, const Color(0xFFB9AE9E));
    expect(p.line, const Color(0xFF3A322A));
    expect(p.buttonEdge, const Color(0xFF6E6253));
    expect(p.accentLine, const Color(0xFFFFA000));
    expect(p.accentWash, const Color(0x29FFA000));
    expect(p.bubbleBg, const Color(0xFFEDE6D8));
    expect(p.bubbleFg, const Color(0xFF15120F));
  });

  test('unknown theme falls back to light', () {
    expect(ReadingPalette.of('neon'), same(ReadingPalette.light));
    expect(ReadingPalette.of(''), same(ReadingPalette.light));
  });
}
