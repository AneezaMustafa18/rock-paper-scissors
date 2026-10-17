
import 'dart:math';

import 'package:flutter/material.dart';

import '../constants/game_constants.dart';

class VictoryDialog extends StatefulWidget {
  final bool isChampion;
  final int playerScore;
  final int cpuScore;
  final VoidCallback onContinue;
  final VoidCallback? onPlayAgain;

  const VictoryDialog({
    super.key,
    required this.isChampion,
    required this.playerScore,
    required this.cpuScore,
    required this.onContinue,
    this.onPlayAgain,
  });

  @override
  State<VictoryDialog> createState() => _VictoryDialogState();
}

class _VictoryDialogState extends State<VictoryDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  final Random _random = Random();

  late final List<_ConfettiPiece> _confetti;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _confetti = List.generate(
      65,
          (_) => _ConfettiPiece(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: 4 + _random.nextDouble() * 7,
        speed: 0.5 + _random.nextDouble() * 1.5,
        color: [
          neonPink,
          neonBlue,
          neonOrange,
          Colors.greenAccent,
          Colors.purpleAccent,
          Colors.yellowAccent,
        ][_random.nextInt(6)],
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool playerWon = widget.isChampion;

    final String title =
    playerWon ? 'YAAAYYYY!' : 'YOU LOSE!';

    final String message = playerWon
        ? 'YOU WON THE ENTIRE MATCH! AMAZING!'
        : 'THE CPU ROBOT WON THIS MATCH. TRY AGAIN!';

    final Color accentColor =
    playerWon ? neonOrange : neonPink;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 24,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Celebration confetti for the winning player.
          if (playerWon)
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: _ConfettiPainter(
                        pieces: _confetti,
                        progress: _controller.value,
                      ),
                    );
                  },
                ),
              ),
            ),

          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: 380,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: panelColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: accentColor,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withOpacity(0.25),
                    blurRadius: 28,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated winner / loser icon.
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      final double bounce = playerWon
                          ? 1 + 0.10 * sin(
                        _controller.value * pi * 4,
                      )
                          : 1.0;

                      return Transform.scale(
                        scale: bounce,
                        child: Icon(
                          playerWon
                              ? Icons.emoji_events_rounded
                              : Icons.sentiment_very_dissatisfied_rounded,
                          size: 68,
                          color: accentColor,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 14),

                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 29,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(
                          color: accentColor.withOpacity(0.55),
                          blurRadius: 18,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    playerWon ? 'YOU WIN!' : 'MATCH OVER!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 22),

                  Row(
                    children: [
                      Expanded(
                        child: _scoreTile(
                          'PLAYER',
                          widget.playerScore,
                          neonBlue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _scoreTile(
                          'CPU ROBOT',
                          widget.cpuScore,
                          neonPink,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: widget.onPlayAgain ??
                          widget.onContinue,
                      icon: Icon(
                        playerWon
                            ? Icons.replay_rounded
                            : Icons.refresh_rounded,
                      ),
                      label: Text(
                        playerWon ? 'PLAY AGAIN' : 'TRY AGAIN',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: darkBg,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextButton(
                    onPressed: widget.onContinue,
                    child: const Text(
                      'CHARACTER SELECT',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _scoreTile(String label, int score, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.65),
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '$score',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfettiPiece {
  final double x;
  final double y;
  final double size;
  final double speed;
  final Color color;

  const _ConfettiPiece({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.color,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiPiece> pieces;
  final double progress;

  _ConfettiPainter({
    required this.pieces,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final piece in pieces) {
      final double x = piece.x * size.width;
      final double y =
          ((piece.y + progress * piece.speed) % 1.0) *
              size.height;

      final paint = Paint()
        ..color = piece.color.withOpacity(
          (1.0 - progress * 0.35).clamp(0.0, 1.0),
        );

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(progress * pi * 4 + piece.x * pi);

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: piece.size,
            height: piece.size * 1.8,
          ),
          const Radius.circular(2),
        ),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
