import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_element.freezed.dart';

@freezed
class GameElement with _$GameElement {
  const factory GameElement({
    required String id,
    required int categoryId,
    String? categoryName,
    String? value,
  }) = _GameElement;
}

// Kept for backward compatibility during transition; new code uses IdeaCategory
enum ElementType {
  character,
  trait,
  object,
  location,
  emotion,
}

extension ElementTypeExtension on ElementType {

  String get displayName {
    switch (this) {
      case ElementType.character: return 'Personaggio';
      case ElementType.trait: return 'Carattere';
      case ElementType.object: return 'Oggetto';
      case ElementType.location: return 'Luogo';
      case ElementType.emotion: return 'Emozione';
    }
  }

  Color get color {
    switch (this) {
      case ElementType.character: return Colors.blue;
      case ElementType.trait: return Colors.purple;
      case ElementType.object: return Colors.orange;
      case ElementType.location: return Colors.green;
      case ElementType.emotion: return Colors.red;
    }
  }

  IconData get icon {
    switch (this) {
      case ElementType.character: return Icons.person;
      case ElementType.trait: return Icons.psychology;
      case ElementType.object: return Icons.category;
      case ElementType.location: return Icons.location_on;
      case ElementType.emotion: return Icons.emoji_emotions;
    }
  }
}