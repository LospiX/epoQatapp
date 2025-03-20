import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class Game {
  final String title;
  final String description;
  final String imagePath;
  final String routeName;
  final IconData? icon;

  const Game({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.routeName,
    required this.icon,
  });
}
