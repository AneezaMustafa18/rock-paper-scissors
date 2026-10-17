
import 'dart:math';
import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  final random = Random();
  final moves = ['✊', '✋', '✌️'];
  final names = ['ROCK', 'PAPER', 'SCISSORS'];

  String player = '❔';
  String computer = '❔';
  String result = 'MAKE YOUR MOVE';

  int playerScore = 0;
  int computerScore = 0;

  void play(int choice) {
    int cpu = random.nextInt(3);

    setState(() {
      player = moves[choice];
      computer = moves[cpu];

      if (choice == cpu) {
        result = "IT'S A DRAW!";
      } else if ((choice - cpu + 3) % 3 == 1) {
        result = 'YOU WIN! 🎉';
        playerScore++;
      } else {
        result = 'YOU LOSE!';
        computerScore++;
      }
    });
  }

  void reset() {
    setState(() {
      player = '❔';
      computer = '❔';
      result = 'MAKE YOUR MOVE';
      playerScore = 0;
      computerScore = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B18),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.bolt, color: Colors.purpleAccent, size: 45),
                const SizedBox(height: 10),
                const Text(
                  'NEON RPS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
                const Text(
                  'ROCK • PAPER • SCISSORS',
                  style: TextStyle(
                    color: Colors.purpleAccent,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 35),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    scoreBox('YOU', playerScore, Colors.purpleAccent),
                    const SizedBox(width: 20),
                    scoreBox('CPU', computerScore, Colors.cyanAccent),
                  ],
                ),

                const SizedBox(height: 40),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    battleBox('YOU', player, Colors.purpleAccent),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        'VS',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    battleBox('COMPUTER', computer, Colors.cyanAccent),
                  ],
                ),

                const SizedBox(height: 30),

                Text(
                  result,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.purpleAccent,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  'CHOOSE YOUR MOVE',
                  style: TextStyle(
                    color: Colors.white70,
                    letterSpacing: 2,
                  ),
                ),

                const SizedBox(height: 18),

                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(
                    3,
                        (i) => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF211936),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(
                            color: Colors.purpleAccent,
                          ),
                        ),
                      ),
                      onPressed: () => play(i),
                      child: Column(
                        children: [
                          Text(
                            moves[i],
                            style: const TextStyle(fontSize: 32),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            names[i],
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                TextButton.icon(
                  onPressed: reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('RESET GAME'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget scoreBox(String title, int score, Color color) {
    return Container(
      width: 130,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: color, letterSpacing: 2)),
          const SizedBox(height: 8),
          Text(
            '$score',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget battleBox(String title, String emoji, Color color) {
    return Column(
      children: [
        Container(
          width: 95,
          height: 95,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.6)),
          ),
          child: Text(emoji, style: const TextStyle(fontSize: 40)),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(color: color, fontSize: 11),
        ),
      ],
    );
  }
}
