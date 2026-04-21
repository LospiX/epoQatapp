import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/sequence.dart';
import '../utils/sound_source.dart';

sealed class SequenceRunnerEvent {
  const SequenceRunnerEvent();
}

class RunnerStart extends SequenceRunnerEvent {
  const RunnerStart();
}

class RunnerPause extends SequenceRunnerEvent {
  const RunnerPause();
}

class RunnerResume extends SequenceRunnerEvent {
  const RunnerResume();
}

class RunnerRestartRep extends SequenceRunnerEvent {
  const RunnerRestartRep();
}

class RunnerCancel extends SequenceRunnerEvent {
  const RunnerCancel();
}

class _RunnerTick extends SequenceRunnerEvent {
  const _RunnerTick();
}

@immutable
class SequenceRunnerState {
  final int currentStepIndex;
  final int currentRepetition; // 1-based, current running rep
  final int remainingMsInRep;
  final int totalRemainingMs;
  final bool isPaused;
  final bool isFinished;
  final bool isCancelled;

  const SequenceRunnerState({
    required this.currentStepIndex,
    required this.currentRepetition,
    required this.remainingMsInRep,
    required this.totalRemainingMs,
    required this.isPaused,
    required this.isFinished,
    required this.isCancelled,
  });

  factory SequenceRunnerState.initial(Sequence seq) {
    final firstStep = seq.steps.isNotEmpty ? seq.steps.first : null;
    return SequenceRunnerState(
      currentStepIndex: 0,
      currentRepetition: 1,
      remainingMsInRep: (firstStep?.durationSeconds ?? 0) * 1000,
      totalRemainingMs: seq.totalDurationSeconds * 1000,
      isPaused: true,
      isFinished: false,
      isCancelled: false,
    );
  }

  SequenceRunnerState copyWith({
    int? currentStepIndex,
    int? currentRepetition,
    int? remainingMsInRep,
    int? totalRemainingMs,
    bool? isPaused,
    bool? isFinished,
    bool? isCancelled,
  }) {
    return SequenceRunnerState(
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      currentRepetition: currentRepetition ?? this.currentRepetition,
      remainingMsInRep: remainingMsInRep ?? this.remainingMsInRep,
      totalRemainingMs: totalRemainingMs ?? this.totalRemainingMs,
      isPaused: isPaused ?? this.isPaused,
      isFinished: isFinished ?? this.isFinished,
      isCancelled: isCancelled ?? this.isCancelled,
    );
  }
}

class SequenceRunnerBloc extends Bloc<SequenceRunnerEvent, SequenceRunnerState> {
  final Sequence sequence;
  Timer? _timer;
  final AudioPlayer _player = AudioPlayer();
  static const int _tickMs = 100;

  SequenceRunnerBloc({required this.sequence})
      : super(SequenceRunnerState.initial(sequence)) {
    on<RunnerStart>(_onStart);
    on<RunnerPause>(_onPause);
    on<RunnerResume>(_onResume);
    on<RunnerRestartRep>(_onRestart);
    on<RunnerCancel>(_onCancel);
    on<_RunnerTick>(_onTick);
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: _tickMs), (_) {
      add(const _RunnerTick());
    });
  }

  void _onStart(RunnerStart event, Emitter<SequenceRunnerState> emit) {
    if (sequence.steps.isEmpty) {
      emit(state.copyWith(isFinished: true, isPaused: true));
      return;
    }
    emit(state.copyWith(isPaused: false));
    _startTimer();
  }

  void _onPause(RunnerPause event, Emitter<SequenceRunnerState> emit) {
    _timer?.cancel();
    emit(state.copyWith(isPaused: true));
  }

  void _onResume(RunnerResume event, Emitter<SequenceRunnerState> emit) {
    if (state.isFinished) return;
    emit(state.copyWith(isPaused: false));
    _startTimer();
  }

  void _onRestart(RunnerRestartRep event, Emitter<SequenceRunnerState> emit) {
    if (state.isFinished) return;
    final step = sequence.steps[state.currentStepIndex];
    final repMs = step.durationSeconds * 1000;
    // recompute total remaining: completed reps in current step + remaining reps after this
    final completedRepsBefore = state.currentRepetition - 1;
    final remainingRepsIncludingCurrent = step.repetitions - completedRepsBefore;
    int remainingInStep = remainingRepsIncludingCurrent * repMs;
    int remainingAfter = 0;
    for (int i = state.currentStepIndex + 1; i < sequence.steps.length; i++) {
      remainingAfter += sequence.steps[i].totalSeconds * 1000;
    }
    emit(state.copyWith(
      remainingMsInRep: repMs,
      totalRemainingMs: remainingInStep + remainingAfter,
    ));
  }

  void _onCancel(RunnerCancel event, Emitter<SequenceRunnerState> emit) {
    _timer?.cancel();
    emit(state.copyWith(isPaused: true, isCancelled: true));
  }

  void _onTick(_RunnerTick event, Emitter<SequenceRunnerState> emit) {
    if (state.isPaused || state.isFinished) return;
    var remRep = state.remainingMsInRep - _tickMs;
    var remTotal = state.totalRemainingMs - _tickMs;
    if (remTotal < 0) remTotal = 0;

    if (remRep > 0) {
      emit(state.copyWith(
        remainingMsInRep: remRep,
        totalRemainingMs: remTotal,
      ));
      return;
    }

    // Rep finished
    final step = sequence.steps[state.currentStepIndex];
    final isLastRep = state.currentRepetition >= step.repetitions;
    final isLastStep = state.currentStepIndex >= sequence.steps.length - 1;

    // Play sounds
    if (isLastRep) {
      if (step.stepEndSound != null) {
        _play(step.stepEndSound!);
      } else if (step.repEndSound != null) {
        _play(step.repEndSound!);
      }
    } else if (step.repEndSound != null) {
      _play(step.repEndSound!);
    }

    if (!isLastRep) {
      emit(state.copyWith(
        currentRepetition: state.currentRepetition + 1,
        remainingMsInRep: step.durationSeconds * 1000,
        totalRemainingMs: remTotal,
      ));
      return;
    }

    if (isLastStep) {
      _timer?.cancel();
      emit(state.copyWith(
        remainingMsInRep: 0,
        totalRemainingMs: 0,
        isPaused: true,
        isFinished: true,
      ));
      return;
    }

    final nextIndex = state.currentStepIndex + 1;
    final nextStep = sequence.steps[nextIndex];
    emit(state.copyWith(
      currentStepIndex: nextIndex,
      currentRepetition: 1,
      remainingMsInRep: nextStep.durationSeconds * 1000,
      totalRemainingMs: remTotal,
    ));
  }

  Future<void> _play(String value) async {
    try {
      final source = await SoundRef.resolve(value);
      if (source == null) return;
      await _player.stop();
      await _player.play(source);
    } catch (_) {
      // ignore audio errors
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _player.dispose();
    return super.close();
  }
}
