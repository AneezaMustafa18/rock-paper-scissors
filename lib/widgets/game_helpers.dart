
import 'package:flutter/material.dart';

/// Returns the asset path for game images.
String gameImagePath(String name) {
  return 'assets/images/$name.png';
}

/// Reusable glowing text style for the game UI.
Widget gameGlowText(
    String text, {
      double size = 18,
      Color color = Colors.white,
      FontWeight weight = FontWeight.bold,
      double spacing = 1.1,
      int maxLines = 1,
    }) {
  return Text(
    text,
    textAlign: TextAlign.center,
    maxLines: maxLines,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      color: color,
      fontSize: size,
      fontWeight: weight,
      letterSpacing: spacing,
      shadows: [
        Shadow(
          color: color.withOpacity(0.55),
          blurRadius: 12,
        ),
      ],
    ),
  );
}
