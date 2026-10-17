
import 'package:flutter/material.dart';

// Rock, Paper, Scissors — shared game constants.

const Color neonPink = Color(0xFFFF32E8);
const Color neonBlue = Color(0xFF00F5FF);
const Color neonOrange = Color(0xFFFFB547);

const Color darkBg = Color(0xFF090D1C);
const Color panelColor = Color(0xFF11182B);

const List<String> gameMoves = [
  'rock',
  'paper',
  'scissors',
];

const int targetScore = 3;

const Duration loadingDuration = Duration(milliseconds: 1800);
const Duration moveRevealDelay = Duration(milliseconds: 500);
const Duration cpuThinkingDelay = Duration(milliseconds: 1000);
const Duration resultDelay = Duration(milliseconds: 600);
