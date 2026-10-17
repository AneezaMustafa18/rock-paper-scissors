
import 'package:flutter/material.dart';

import '../constants/game_constants.dart';
import 'battle_widgets.dart';

class WelcomeScreen extends StatelessWidget {
  final Animation<double> introAnimation;
  final Animation<double> pulseAnimation;
  final VoidCallback onStart;

  const WelcomeScreen({
    super.key,
    required this.introAnimation,
    required this.pulseAnimation,
    required this.onStart,
  });

  Widget _neonButton() {
    return SizedBox(
      width: 285,
      height: 49,
      child: ElevatedButton.icon(
        onPressed: onStart,
        icon: const Icon(Icons.play_arrow_rounded, size: 22),
        label: const Text(
          'START GAME',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: neonBlue,
          foregroundColor: darkBg,
          elevation: 8,
          shadowColor: neonBlue.withOpacity(0.35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: introAnimation,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: pulseAnimation,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: neonBlue.withOpacity(0.08),
                    border: Border.all(
                      color: neonBlue,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: neonBlue.withOpacity(0.25),
                        blurRadius: 28,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.sports_martial_arts,
                    color: neonBlue,
                    size: 48,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              gameGlowText(
                'WELCOME TO',
                size: 18,
                color: Colors.white70,
                spacing: 4,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: gameGlowText(
                    'ROCK PAPER SCISSORS',
                    size: 42,
                    color: neonBlue,
                    spacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              gameGlowText(
                "ANEEZA'S FLUTTER WEB APP SERIES",
                size: 12,
                color: neonPink,
              ),
              const SizedBox(height: 22),
              Container(
                width: 150,
                height: 2,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      neonBlue,
                      neonPink,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Choose your fighter. Pick your move. Win the battle!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              _neonButton(),
              const SizedBox(height: 18),
              gameGlowText(
                'BUILT WITH FLUTTER',
                size: 10,
                color: neonOrange,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
