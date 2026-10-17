
import 'package:flutter/material.dart';

import '../constants/game_constants.dart';
import 'battle_widgets.dart';

class LoadingScreen extends StatelessWidget {
  final Animation<double> introAnimation;
  final Animation<double> pulseAnimation;

  const LoadingScreen({
    super.key,
    required this.introAnimation,
    required this.pulseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: introAnimation,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: pulseAnimation,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: neonBlue.withOpacity(0.08),
                    border: Border.all(
                      color: neonBlue,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: neonBlue.withOpacity(0.35),
                        blurRadius: 30,
                        spreadRadius: 4,
                      ),
                      BoxShadow(
                        color: neonPink.withOpacity(0.18),
                        blurRadius: 45,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.sports_martial_arts,
                    size: 55,
                    color: neonBlue,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: gameGlowText(
                    'ROCK PAPER SCISSORS',
                    size: 30,
                    color: neonBlue,
                    spacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              gameGlowText(
                "ANEEZA'S FLUTTER WEB APP SERIES",
                size: 11,
                color: neonPink,
              ),
              const SizedBox(height: 35),
              SizedBox(
                width: 180,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: const LinearProgressIndicator(
                    minHeight: 5,
                    backgroundColor: panelColor,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      neonBlue,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              gameGlowText(
                'INITIALIZING GAME...',
                size: 12,
                color: neonBlue,
                spacing: 2,
              ),
              const SizedBox(height: 10),
              gameGlowText(
                'PREPARING THE BATTLE ARENA',
                size: 9,
                color: Colors.white60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
