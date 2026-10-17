
import 'package:flutter/material.dart';

import '../constants/game_constants.dart';

String gameImagePath(String name) => 'assets/images/$name.png';

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

class BattleWidgets {
  BattleWidgets._();

  static Widget panel({
    required Widget child,
    Color borderColor = neonBlue,
    EdgeInsets padding = const EdgeInsets.all(10),
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: panelColor.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor.withOpacity(0.85),
        ),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.10),
            blurRadius: 16,
          ),
        ],
      ),
      child: child,
    );
  }

  static Widget scoreCard({
    required String label,
    required int score,
    required Color color,
  }) {
    return Expanded(
      child: panel(
        borderColor: color,
        padding: const EdgeInsets.symmetric(
          vertical: 7,
          horizontal: 3,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            gameGlowText(label, size: 9, color: color),
            const SizedBox(height: 3),
            gameGlowText('$score', size: 21),
          ],
        ),
      ),
    );
  }

  static Widget fighterCard({
    required String title,
    required String characterAsset,
    required String move,
    required Color color,
    required bool isCpu,
    required bool isPlaying,
  }) {
    final bool thinking = isPlaying && isCpu && move.isEmpty;

    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: thinking ? neonOrange : color,
            width: thinking ? 2 : 1,
          ),
          boxShadow: [
            if (thinking)
              BoxShadow(
                color: neonOrange.withOpacity(0.25),
                blurRadius: 16,
              ),
          ],
        ),
        child: Column(
          children: [
            gameGlowText(title, size: 10, color: color),
            const SizedBox(height: 4),
            Expanded(
              flex: 5,
              child: Image.asset(
                gameImagePath(characterAsset),
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  isCpu ? Icons.smart_toy : Icons.person,
                  size: 43,
                  color: color,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              flex: 5,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                child: move.isEmpty
                    ? Icon(
                  thinking
                      ? Icons.psychology_alt
                      : Icons.touch_app,
                  key: ValueKey('${isCpu}_waiting_$thinking'),
                  size: 35,
                  color: thinking ? neonOrange : color,
                )
                    : Image.asset(
                  gameImagePath(move),
                  key: ValueKey('${isCpu}_$move'),
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.pan_tool,
                    size: 35,
                    color: color,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            gameGlowText(
              thinking
                  ? 'THINKING...'
                  : move.isEmpty
                  ? 'READY'
                  : move.toUpperCase(),
              size: 10,
              color: thinking ? neonOrange : color,
            ),
          ],
        ),
      ),
    );
  }

  static Widget moveButton({
    required String move,
    required Color color,
    required IconData fallback,
    required String selectedMove,
    required bool isPlaying,
    required VoidCallback onTap,
  }) {
    final bool selected = selectedMove == move;

    return Expanded(
      child: GestureDetector(
        onTap: isPlaying ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: selected
                ? color.withOpacity(0.18)
                : panelColor.withOpacity(0.95),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? color : color.withOpacity(0.5),
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: Image.asset(
                  gameImagePath(move),
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                    fallback,
                    size: 32,
                    color: color,
                  ),
                ),
              ),
              gameGlowText(
                move.toUpperCase(),
                size: 9,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
