import 'package:flutter/foundation.dart';
import 'sequence_step.dart';

@immutable
class Sequence {
  final int? id;
  final String name;
  final String description;
  final List<SequenceStep> steps;

  const Sequence({
    this.id,
    required this.name,
    required this.description,
    required this.steps,
  });

  int get totalDurationSeconds =>
      steps.fold(0, (sum, s) => sum + s.totalSeconds);

  Sequence copyWith({
    int? id,
    String? name,
    String? description,
    List<SequenceStep>? steps,
  }) {
    return Sequence(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      steps: steps ?? this.steps,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Sequence &&
          other.id == id &&
          other.name == name &&
          other.description == description &&
          listEquals(other.steps, steps);

  @override
  int get hashCode => Object.hash(id, name, description, Object.hashAll(steps));
}
