import 'package:flutter/material.dart';

class NoirPalette {
  static const background = Color(0xFF04070D);
  static const backgroundRaised = Color(0xFF09111C);
  static const panel = Color(0xFF101A2A);
  static const panelSoft = Color(0xFF0B1320);
  static const panelGlass = Color(0xCC101A2A);
  static const border = Color(0xFF20324C);
  static const grid = Color(0xFF16324D);

  static const cyan = Color(0xFF46F7FF);
  static const electricBlue = Color(0xFF3D7BFF);
  static const magenta = Color(0xFFFF4FD8);
  static const mint = Color(0xFF59FFC6);
  static const amber = Color(0xFFFFC857);
  static const danger = Color(0xFFFF6B8A);

  static const textPrimary = Color(0xFFF2F7FF);
  static const textSecondary = Color(0xFF91A8CB);
  static const textMuted = Color(0xFF627696);

  static List<BoxShadow> glow(
    Color color, {
    double blur = 26,
    double spread = 0,
    Offset offset = Offset.zero,
  }) {
    return [
      BoxShadow(
        color: color.withValues(alpha: 0.20),
        blurRadius: blur,
        spreadRadius: spread,
        offset: offset,
      ),
    ];
  }
}
