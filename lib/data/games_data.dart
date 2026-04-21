import 'package:flutter/material.dart';
import '../models/game.dart';

final List<Game> games = [
  // Game(
  //   title: 'Math Puzzle',
  //   description: 'Learn numbers through fun puzzles',
  //   imagePath: 'assets/images/math_puzzle.png',
  //   routeName: '/math-puzzle',
  // ),
  // Game(
  //   title: 'Word Builder',
  //   description: 'Create words from letters',
  //   imagePath: 'assets/images/word_builder.png',
  //   routeName: '/word-builder',
  // ),
  // Game(
  //   title: 'Color Match',
  //   description: 'Match colors with names',
  //   imagePath: 'assets/images/color_match.png',
  //   routeName: '/color-match',
  // ),
  Game(
    title: 'Ruota delle Emozioni',
    description: 'Esplora le emozioni attraverso con l\'aiuto della fortuna',
    imagePath: 'assets/images/emotion_wheel.png',
    routeName: '/emotion-wheel',
    icon: Icons.emoji_emotions,
  ),
  Game(
    title: 'Idea Generator',
    description: 'Stimola la tua creatività con un generatore di idee che combina elementi casuali',
    imagePath: 'assets/images/idea_generator.png',
    routeName: '/idea-generator',
    icon: Icons.lightbulb_outline,
  ),
  Game(
    title: 'SeQuences',
    description: 'Crea ed esegui sequenze a tempo di passi ripetuti',
    imagePath: 'assets/images/sequences.png',
    routeName: '/sequences',
    icon: Icons.timer_outlined,
  ),
];
