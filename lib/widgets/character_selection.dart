
import 'package:flutter/material.dart';

import '../constants/game_constants.dart';
import 'battle_widgets.dart';

class CharacterSelection extends StatelessWidget {
  final double width;
  final double height;
  final int selectedCharacter;
  final List<Map<String, dynamic>> characters;
  final ValueChanged<int> onCharacterSelected;
  final VoidCallback onEnterArena;
  final VoidCallback onBack;

  const CharacterSelection({
    super.key,
    required this.width,
    required this.height,
    required this.selectedCharacter,
    required this.characters,
    required this.onCharacterSelected,
    required this.onEnterArena,
    required this.onBack,
  });

  Widget _characterCard(int index, bool compact) {
    final character = characters[index];
    final color = character['color'] as Color;
    final selected = selectedCharacter == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onCharacterSelected(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.all(5),
          padding: EdgeInsets.all(compact ? 7 : 12),
          decoration: BoxDecoration(
            color: selected
                ? color.withOpacity(0.14)
                : panelColor.withOpacity(0.96),
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: selected ? color : color.withOpacity(0.35),
              width: selected ? 2.5 : 1,
            ),
            boxShadow: [
              if (selected)
                BoxShadow(
                  color: color.withOpacity(0.22),
                  blurRadius: 20,
                ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              gameGlowText(
                selected ? '✓ SELECTED' : 'SELECT FIGHTER',
                size: compact ? 9 : 11,
                color: color,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: AnimatedScale(
                  scale: selected ? 1.05 : 0.95,
                  duration: const Duration(milliseconds: 250),
                  child: Image.asset(
                    gameImagePath(character['image'] as String),
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.person,
                      color: color,
                      size: 65,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              gameGlowText(
                character['name'] as String,
                size: compact ? 11 : 15,
                color: color,
              ),
              const SizedBox(height: 4),
              gameGlowText(
                character['description'] as String,
                size: 8,
                color: Colors.white60,
              ),
              const SizedBox(height: 8),
              Icon(
                selected
                    ? Icons.check_circle
                    : Icons.circle_outlined,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _enterButton() {
    return SizedBox(
      height: 49,
      child: ElevatedButton.icon(
        onPressed: onEnterArena,
        icon: const Icon(Icons.flash_on_rounded, size: 19),
        label: const Text(
          'ENTER THE ARENA',
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
    final compact = height < 650;

    return FadeTransition(
      opacity: const AlwaysStoppedAnimation(1),
      child: Column(
        children: [
          gameGlowText(
            'CHOOSE YOUR FIGHTER',
            size: compact ? 21 : 29,
            color: neonBlue,
          ),
          const SizedBox(height: 7),
          gameGlowText(
            'SELECT ONE CHARACTER TO PLAY',
            size: 10,
            color: neonPink,
          ),
          SizedBox(height: compact ? 8 : 16),
          Expanded(
            child: Row(
              children: [
                _characterCard(0, compact),
                _characterCard(1, compact),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Your selected character will fight against the CPU robot.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white60,
              fontSize: 11,
            ),
          ),
          SizedBox(height: compact ? 8 : 14),
          SizedBox(
            width: width > 600 ? 320 : double.infinity,
            child: _enterButton(),
          ),
          TextButton.icon(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back, size: 16),
            label: const Text('BACK'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white60,
            ),
          ),
        ],
      ),
    );
  }
}
