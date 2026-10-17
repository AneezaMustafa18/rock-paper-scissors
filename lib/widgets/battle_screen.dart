
import 'package:flutter/material.dart';

import '../constants/game_constants.dart';
import 'battle_widgets.dart';

class BattleScreen extends StatelessWidget {
  final double width;
  final double height;
  final Map<String, dynamic> character;
  final String playerMove;
  final String cpuMove;
  final String result;
  final String resultMessage;
  final bool isPlaying;
  final int playerScore;
  final int cpuScore;
  final int draws;
  final int rounds;
  final VoidCallback onReset;
  final VoidCallback onBack;
  final ValueChanged<String> onMoveSelected;

  const BattleScreen({
    super.key,
    required this.width,
    required this.height,
    required this.character,
    required this.playerMove,
    required this.cpuMove,
    required this.result,
    required this.resultMessage,
    required this.isPlaying,
    required this.playerScore,
    required this.cpuScore,
    required this.draws,
    required this.rounds,
    required this.onReset,
    required this.onBack,
    required this.onMoveSelected,
  });

  @override
  Widget build(BuildContext context) {
    final compact = height < 650;
    final characterColor = character['color'] as Color;
    final characterImage = character['image'] as String;
    final characterName = character['name'] as String;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width < 500 ? 10 : 22,
        vertical: compact ? 5 : 12,
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: isPlaying ? null : onBack,
                icon: const Icon(Icons.arrow_back_rounded),
                color: neonBlue,
                tooltip: 'Back to character selection',
              ),
              Expanded(
                child: gameGlowText(
                  'BATTLE ARENA',
                  size: compact ? 19 : 26,
                  color: neonBlue,
                ),
              ),
              IconButton(
                onPressed: isPlaying ? null : onReset,
                icon: const Icon(Icons.refresh_rounded),
                color: neonPink,
                tooltip: 'Reset game',
              ),
            ],
          ),

          const SizedBox(height: 5),

          Row(
            children: [
              BattleWidgets.scoreCard(
                label: characterName.toUpperCase(),
                score: playerScore,
                color: characterColor,
              ),
              const SizedBox(width: 8),
              BattleWidgets.scoreCard(
                label: 'CPU ROBOT',
                score: cpuScore,
                color: neonPink,
              ),
              const SizedBox(width: 8),
              BattleWidgets.scoreCard(
                label: 'DRAWS',
                score: draws,
                color: neonOrange,
              ),
            ],
          ),

          const SizedBox(height: 8),

          gameGlowText(
            'ROUND ${rounds + (isPlaying ? 1 : 0)}',
            size: 11,
            color: neonOrange,
          ),

          const SizedBox(height: 8),

          Expanded(
            child: BattleWidgets.panel(
              borderColor: neonBlue,
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        BattleWidgets.fighterCard(
                          title: characterName.toUpperCase(),
                          characterAsset: characterImage,
                          move: playerMove,
                          color: characterColor,
                          isCpu: false,
                          isPlaying: isPlaying,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          child: gameGlowText(
                            'VS',
                            size: compact ? 17 : 23,
                            color: neonOrange,
                          ),
                        ),
                        BattleWidgets.fighterCard(
                          title: 'CPU ROBOT',
                          characterAsset: 'robot',
                          move: cpuMove,
                          color: neonPink,
                          isCpu: true,
                          isPlaying: isPlaying,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: result == 'WIN'
                          ? neonBlue.withOpacity(0.12)
                          : result == 'LOSE'
                          ? neonPink.withOpacity(0.12)
                          : panelColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: result == 'WIN'
                            ? neonBlue
                            : result == 'LOSE'
                            ? neonPink
                            : neonOrange.withOpacity(0.5),
                      ),
                    ),
                    child: Column(
                      children: [
                        gameGlowText(
                          isPlaying
                              ? 'BATTLE IN PROGRESS...'
                              : resultMessage.isEmpty
                              ? 'MAKE YOUR MOVE!'
                              : resultMessage,
                          size: compact ? 11 : 14,
                          color: result == 'WIN'
                              ? neonBlue
                              : result == 'LOSE'
                              ? neonPink
                              : neonOrange,
                          maxLines: 2,
                        ),
                        if (rounds > 0) ...[
                          const SizedBox(height: 4),
                          gameGlowText(
                            'ROUNDS PLAYED: $rounds',
                            size: 9,
                            color: Colors.white60,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          gameGlowText(
            'CHOOSE YOUR MOVE',
            size: compact ? 11 : 13,
            color: neonBlue,
          ),

          const SizedBox(height: 7),

          SizedBox(
            height: compact ? 76 : 95,
            child: Row(
              children: [
                BattleWidgets.moveButton(
                  move: 'rock',
                  color: neonBlue,
                  fallback: Icons.pan_tool_rounded,
                  selectedMove: playerMove,
                  isPlaying: isPlaying,
                  onTap: () => onMoveSelected('rock'),
                ),
                const SizedBox(width: 8),
                BattleWidgets.moveButton(
                  move: 'paper',
                  color: neonPink,
                  fallback: Icons.back_hand_rounded,
                  selectedMove: playerMove,
                  isPlaying: isPlaying,
                  onTap: () => onMoveSelected('paper'),
                ),
                const SizedBox(width: 8),
                BattleWidgets.moveButton(
                  move: 'scissors',
                  color: neonOrange,
                  fallback: Icons.content_cut_rounded,
                  selectedMove: playerMove,
                  isPlaying: isPlaying,
                  onTap: () => onMoveSelected('scissors'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
