
import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'constants/game_constants.dart';
import 'widgets/battle_screen.dart';
import 'widgets/character_selection.dart';
import 'widgets/loading_screen.dart';
import 'widgets/victory_dialog.dart';
import 'widgets/welcome_screen.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> with TickerProviderStateMixin {
  final Random random = Random();
  final AudioPlayer audioPlayer = AudioPlayer();

  late final AnimationController pulseController;
  late final AnimationController introController;

  Timer? loadingTimer;

  int currentScreen = 0;
  int selectedCharacter = 0;

  bool isLoading = true;
  bool isPlaying = false;
  bool matchOver = false;
  bool victoryDialogShown = false;

  final List<Map<String, dynamic>> characters = [
    {
      'name': 'NEON HERO',
      'image': 'player',
      'color': neonBlue,
      'description': 'THE NEON WARRIOR',
    },
    {
      'name': 'CYBER GIRL',
      'image': 'cpu',
      'color': neonPink,
      'description': 'THE CYBER FIGHTER',
    },
  ];

  final String robotImage = 'robot';
  final List<String> moves = ['rock', 'paper', 'scissors'];

  String playerMove = '';
  String cpuMove = '';

  String result = 'CHOOSE YOUR MOVE';
  String resultMessage = 'Your battle starts now!';
  String battleStatus = 'BOTH FIGHTERS READY';

  int playerScore = 0;
  int cpuScore = 0;
  int draws = 0;
  int rounds = 0;

  String imagePath(String name) => 'assets/images/$name.png';

  String get playerImage =>
      characters[selectedCharacter]['image'] as String;

  String get playerName =>
      characters[selectedCharacter]['name'] as String;

  Color get playerColor =>
      characters[selectedCharacter]['color'] as Color;

  @override
  void initState() {
    super.initState();

    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      lowerBound: 0.96,
      upperBound: 1.04,
    )..repeat(reverse: true);

    introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    loadingTimer = Timer(
      const Duration(milliseconds: 2800),
          () {
        if (!mounted) return;

        setState(() {
          isLoading = false;
        });

        introController.forward(from: 0);
      },
    );
  }

  @override
  void dispose() {
    loadingTimer?.cancel();
    pulseController.dispose();
    introController.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  // SOUND

  Future<void> playSound(String name) async {
    try {
      await audioPlayer.stop();
      await audioPlayer.play(
        AssetSource('audio/$name.mp3'),
      );
    } catch (e) {
      debugPrint('Sound error ($name): $e');
    }
  }

  // NAVIGATION

  void navigateTo(int screen) {
    if (isPlaying || isLoading || matchOver) return;

    setState(() {
      currentScreen = screen;
    });

    introController.forward(from: 0);

    if (screen != 0) {
      playSound('click');
    }
  }

  // BACKGROUND

  Widget backgroundImage(String name) {
    return Image.asset(
      imagePath(name),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF11152B),
                Color(0xFF080B18),
                Color(0xFF190D2A),
              ],
            ),
          ),
        );
      },
    );
  }

  // GAME LOGIC

  Future<void> playMove(String move) async {
    if (isPlaying || matchOver || !moves.contains(move)) {
      return;
    }

    setState(() {
      isPlaying = true;
      playerMove = move;
      cpuMove = '';
      result = 'FIGHT!';
      resultMessage = 'Your move: ${move.toUpperCase()}';
      battleStatus = 'PLAYER ATTACKING!';
    });

    await playSound('click');

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    if (!mounted) return;

    setState(() {
      battleStatus = 'CPU ROBOT IS THINKING...';
      resultMessage = 'Your opponent is choosing a move!';
    });

    await Future.delayed(
      const Duration(milliseconds: 1000),
    );

    if (!mounted) return;

    final computerMove = moves[random.nextInt(moves.length)];

    setState(() {
      cpuMove = computerMove;
      battleStatus = 'CPU CHOSE ${computerMove.toUpperCase()}!';
      resultMessage =
      '${move.toUpperCase()} VS ${computerMove.toUpperCase()}';
    });

    await Future.delayed(
      const Duration(milliseconds: 600),
    );

    if (!mounted) return;

    String roundResult;
    String message;
    String sound;

    if (move == computerMove) {
      roundResult = 'DRAW!';
      message = 'Both fighters chose ${move.toUpperCase()}!';
      sound = 'draw';
      draws++;
    } else if (
    (move == 'rock' && computerMove == 'scissors') ||
        (move == 'paper' && computerMove == 'rock') ||
        (move == 'scissors' && computerMove == 'paper')) {
      roundResult = 'YOU WIN!';
      message =
      '${move.toUpperCase()} defeats ${computerMove.toUpperCase()}!';
      sound = 'win';
      playerScore++;
    } else {
      roundResult = 'YOU LOSE!';
      message =
      '${computerMove.toUpperCase()} defeats ${move.toUpperCase()}!';
      sound = 'lose';
      cpuScore++;
    }

    rounds++;

    final bool finished =
        playerScore >= 3 || cpuScore >= 3;

    setState(() {
      result = roundResult;
      resultMessage = message;

      battleStatus = roundResult == 'YOU WIN!'
          ? 'PLAYER WINS THE ROUND!'
          : roundResult == 'YOU LOSE!'
          ? 'CPU WINS THE ROUND!'
          : 'PERFECT MATCH — DRAW!';

      isPlaying = false;

      if (finished) {
        matchOver = true;
        battleStatus = playerScore >= 3
            ? 'PLAYER WINS THE MATCH!'
            : 'CPU WINS THE MATCH!';
      }
    });

    // MATCH-WINNING SOUND
    // Player wins the match: yay.mp3
    // Robot wins the match: lose-pop.mp3
    // Regular rounds: existing win, lose, and draw sounds.

    if (finished) {
      if (playerScore >= 3) {
        await playSound('yay');
      } else {
        await playSound('youlose');
      }
    } else {
      await playSound(sound);
    }

    if (!mounted) return;

    if (finished) {
      showMatchDialog();
    }
  }

  // MATCH RESULT DIALOG

  Future<void> showMatchDialog() async {
    if (!mounted || victoryDialogShown) return;

    victoryDialogShown = true;

    await Future.delayed(
      const Duration(milliseconds: 350),
    );

    if (!mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return VictoryDialog(
          isChampion: playerScore >= 3,
          playerScore: playerScore,
          cpuScore: cpuScore,
          onContinue: () {
            Navigator.of(dialogContext).pop();

            if (!mounted) return;

            setState(() {
              currentScreen = 1;
              resetBattleState();
            });

            introController.forward(from: 0);
          },
          onPlayAgain: () {
            Navigator.of(dialogContext).pop();

            if (!mounted) return;

            resetBattle();
          },
        );
      },
    );
  }

  // RESET

  void resetBattleState() {
    playerMove = '';
    cpuMove = '';

    result = 'CHOOSE YOUR MOVE';
    resultMessage = 'Your battle starts now!';
    battleStatus = 'BOTH FIGHTERS READY';

    playerScore = 0;
    cpuScore = 0;
    draws = 0;
    rounds = 0;

    isPlaying = false;
    matchOver = false;
    victoryDialogShown = false;
  }

  void resetBattle() {
    if (isPlaying) return;

    setState(() {
      resetBattleState();
      currentScreen = 2;
    });

    introController.forward(from: 0);
    playSound('click');
  }

  // MAIN LAYOUT

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;
          final compact = height < 650;

          final background = isLoading
              ? 'backgrounds/ui_background'
              : currentScreen == 0
              ? 'backgrounds/ui_background'
              : currentScreen == 1
              ? 'backgrounds/game_over'
              : 'backgrounds/arena';

          return Stack(
            fit: StackFit.expand,
            children: [
              backgroundImage(background),
              Container(
                color: const Color(0xC9080B18),
              ),
              SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 900,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width > 650 ? 24 : 12,
                        vertical: compact ? 5 : 12,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: height - (compact ? 10 : 24),
                        child: isLoading
                            ? LoadingScreen(
                          introAnimation: introController,
                          pulseAnimation: pulseController,
                        )
                            : currentScreen == 0
                            ? WelcomeScreen(
                          introAnimation: introController,
                          pulseAnimation: pulseController,
                          onStart: () => navigateTo(1),
                        )
                            : currentScreen == 1
                            ? CharacterSelection(
                          width: width,
                          height: height,
                          selectedCharacter: selectedCharacter,
                          characters: characters,
                          onCharacterSelected: (index) {
                            setState(() {
                              selectedCharacter = index;
                            });

                            playSound('click');
                          },
                          onEnterArena: () => navigateTo(2),
                          onBack: () => navigateTo(0),
                        )
                            : BattleScreen(
                          width: width,
                          height: height,
                          character:
                          characters[selectedCharacter],
                          playerMove: playerMove,
                          cpuMove: cpuMove,
                          result: result == 'YOU WIN!'
                              ? 'WIN'
                              : result == 'YOU LOSE!'
                              ? 'LOSE'
                              : result,
                          resultMessage: resultMessage,
                          isPlaying: isPlaying,
                          playerScore: playerScore,
                          cpuScore: cpuScore,
                          draws: draws,
                          rounds: rounds,
                          onReset: resetBattle,
                          onBack: () => navigateTo(1),
                          onMoveSelected: playMove,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
