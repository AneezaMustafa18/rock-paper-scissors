
import 'package:flutter/material.dart';
import 'game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NeonClashApp());
}

class NeonClashApp extends StatelessWidget {
  const NeonClashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rock Paper Scissor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF080B18),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const Game(),
    );
  }
}
