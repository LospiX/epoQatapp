import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/sequence.dart';
import '../models/sequence_step.dart';
import '../repositories/sequence_repository.dart';

sealed class SequenceDetailEvent {
  const SequenceDetailEvent();
}

class LoadSequence extends SequenceDetailEvent {
  final int? id;
  const LoadSequence(this.id);
}

class ToggleEditMode extends SequenceDetailEvent {
  const ToggleEditMode();
}

class CancelEdit extends SequenceDetailEvent {
  const CancelEdit();
}

class UpdateName extends SequenceDetailEvent {
  final String value;
  const UpdateName(this.value);
}

class UpdateDescription extends SequenceDetailEvent {
  final String value;
  const UpdateDescription(this.value);
}

class AddStep extends SequenceDetailEvent {
  final SequenceStep step;
  const AddStep(this.step);
}

class UpdateStep extends SequenceDetailEvent {
  final int index;
  final SequenceStep step;
  const UpdateStep(this.index, this.step);
}

class RemoveStep extends SequenceDetailEvent {
  final int index;
  const RemoveStep(this.index);
}

class ReorderStep extends SequenceDetailEvent {
  final int oldIndex;
  final int newIndex;
  const ReorderStep(this.oldIndex, this.newIndex);
}

class SaveChanges extends SequenceDetailEvent {
  const SaveChanges();
}

@immutable
class SequenceDetailState {
  final bool isLoading;
  final Sequence? original;
  final Sequence draft;
  final bool isEditMode;
  final bool isNew;
  final String? error;

  const SequenceDetailState({
    required this.isLoading,
    required this.original,
    required this.draft,
    required this.isEditMode,
    required this.isNew,
    this.error,
  });

  bool get isDirty => original == null || draft != original;

  factory SequenceDetailState.initial() => const SequenceDetailState(
        isLoading: true,
        original: null,
        draft: Sequence(name: '', description: '', steps: []),
        isEditMode: false,
        isNew: false,
      );

  SequenceDetailState copyWith({
    bool? isLoading,
    Sequence? original,
    Sequence? draft,
    bool? isEditMode,
    bool? isNew,
    Object? error = _sentinel,
  }) {
    return SequenceDetailState(
      isLoading: isLoading ?? this.isLoading,
      original: original ?? this.original,
      draft: draft ?? this.draft,
      isEditMode: isEditMode ?? this.isEditMode,
      isNew: isNew ?? this.isNew,
      error: identical(error, _sentinel) ? this.error : error as String?,
    );
  }
}

const Object _sentinel = Object();

class SequenceDetailBloc extends Bloc<SequenceDetailEvent, SequenceDetailState> {
  final SequenceRepository repository;

  SequenceDetailBloc({required this.repository})
      : super(SequenceDetailState.initial()) {
    on<LoadSequence>(_onLoad);
    on<ToggleEditMode>((e, emit) {
      if (state.isEditMode) {
        // treat as cancel
        _cancel(emit);
      } else {
        emit(state.copyWith(isEditMode: true));
      }
    });
    on<CancelEdit>((e, emit) => _cancel(emit));
    on<UpdateName>((e, emit) =>
        emit(state.copyWith(draft: state.draft.copyWith(name: e.value))));
    on<UpdateDescription>((e, emit) =>
        emit(state.copyWith(draft: state.draft.copyWith(description: e.value))));
    on<AddStep>((e, emit) {
      final steps = [...state.draft.steps, e.step];
      emit(state.copyWith(draft: state.draft.copyWith(steps: steps)));
    });
    on<UpdateStep>((e, emit) {
      final steps = [...state.draft.steps];
      if (e.index >= 0 && e.index < steps.length) {
        steps[e.index] = e.step;
        emit(state.copyWith(draft: state.draft.copyWith(steps: steps)));
      }
    });
    on<RemoveStep>((e, emit) {
      final steps = [...state.draft.steps];
      if (e.index >= 0 && e.index < steps.length) {
        steps.removeAt(e.index);
        emit(state.copyWith(draft: state.draft.copyWith(steps: steps)));
      }
    });
    on<ReorderStep>((e, emit) {
      final steps = [...state.draft.steps];
      var newIndex = e.newIndex;
      if (newIndex > e.oldIndex) newIndex -= 1;
      if (e.oldIndex < 0 || e.oldIndex >= steps.length) return;
      final item = steps.removeAt(e.oldIndex);
      steps.insert(newIndex.clamp(0, steps.length), item);
      emit(state.copyWith(draft: state.draft.copyWith(steps: steps)));
    });
    on<SaveChanges>(_onSave);
  }

  Future<void> _onLoad(LoadSequence event, Emitter<SequenceDetailState> emit) async {
    if (event.id == null) {
      emit(state.copyWith(
        isLoading: false,
        original: null,
        draft: const Sequence(name: '', description: '', steps: []),
        isEditMode: true,
        isNew: true,
      ));
      return;
    }
    emit(state.copyWith(isLoading: true));
    final seq = await repository.getById(event.id!);
    if (seq == null) {
      emit(state.copyWith(isLoading: false, error: 'Sequenza non trovata'));
      return;
    }
    emit(state.copyWith(
      isLoading: false,
      original: seq,
      draft: seq,
      isEditMode: false,
      isNew: false,
    ));
  }

  void _cancel(Emitter<SequenceDetailState> emit) {
    if (state.original == null) {
      // new sequence cancel: leave as empty but exit edit mode
      emit(state.copyWith(isEditMode: false));
      return;
    }
    emit(state.copyWith(
      draft: state.original!,
      isEditMode: false,
    ));
  }

  Future<void> _onSave(SaveChanges event, Emitter<SequenceDetailState> emit) async {
    final draft = state.draft;
    if (draft.name.trim().isEmpty) {
      emit(state.copyWith(error: 'Il nome non può essere vuoto'));
      return;
    }
    if (state.original == null) {
      final id = await repository.create(draft);
      final saved = draft.copyWith(id: id);
      emit(state.copyWith(
        original: saved,
        draft: saved,
        isEditMode: false,
        isNew: false,
        error: null,
      ));
    } else {
      final updated = draft.copyWith(id: state.original!.id);
      await repository.update(updated);
      emit(state.copyWith(
        original: updated,
        draft: updated,
        isEditMode: false,
        error: null,
      ));
    }
  }
}
