import 'package:flutter/foundation.dart';

@immutable
class SequenceStep {
  final int? id;
  final String name;
  final int durationSeconds;
  final int repetitions;
  final String? repEndSound;
  final String? stepEndSound;

  const SequenceStep({
    this.id,
    this.name = '',
    required this.durationSeconds,
    required this.repetitions,
    this.repEndSound,
    this.stepEndSound,
  });

  int get totalSeconds => durationSeconds * repetitions;

  SequenceStep copyWith({
    int? id,
    String? name,
    int? durationSeconds,
    int? repetitions,
    Object? repEndSound = _sentinel,
    Object? stepEndSound = _sentinel,
  }) {
    return SequenceStep(
      id: id ?? this.id,
      name: name ?? this.name,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      repetitions: repetitions ?? this.repetitions,
      repEndSound: identical(repEndSound, _sentinel)
          ? this.repEndSound
          : repEndSound as String?,
      stepEndSound: identical(stepEndSound, _sentinel)
          ? this.stepEndSound
          : stepEndSound as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SequenceStep &&
          other.id == id &&
          other.name == name &&
          other.durationSeconds == durationSeconds &&
          other.repetitions == repetitions &&
          other.repEndSound == repEndSound &&
          other.stepEndSound == stepEndSound;

  @override
  int get hashCode => Object.hash(
        id,
        name,
        durationSeconds,
        repetitions,
        repEndSound,
        stepEndSound,
      );
}

const Object _sentinel = Object();
