import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'idea_category.freezed.dart';

@freezed
class IdeaCategory with _$IdeaCategory {
  const IdeaCategory._();

  const factory IdeaCategory({
    required int id,
    required String name,
    required String displayName,
    required int colorValue,
    required int iconCodePoint,
    required int sortOrder,
    @Default(false) bool isDefault,
  }) = _IdeaCategory;

  Color get color => Color(colorValue);

  IconData get icon => IconData(iconCodePoint, fontFamily: 'MaterialIcons');

  factory IdeaCategory.fromMap(Map<String, dynamic> map) => IdeaCategory(
        id: map['id'] as int,
        name: map['name'] as String,
        displayName: map['display_name'] as String,
        colorValue: map['color'] as int,
        iconCodePoint: map['icon'] as int,
        sortOrder: map['sort_order'] as int,
        isDefault: (map['is_default'] as int) == 1,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'display_name': displayName,
        'color': colorValue,
        'icon': iconCodePoint,
        'sort_order': sortOrder,
        'is_default': isDefault ? 1 : 0,
      };
}
