import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/sequence.dart';
import '../repositories/sequence_repository.dart';

sealed class SequencesListEvent {
  const SequencesListEvent();
}

class LoadSequences extends SequencesListEvent {
  const LoadSequences();
}

class DeleteSequence extends SequencesListEvent {
  final int id;
  const DeleteSequence(this.id);
}

sealed class SequencesListState {
  const SequencesListState();
}

class SequencesListLoading extends SequencesListState {
  const SequencesListLoading();
}

class SequencesListLoaded extends SequencesListState {
  final List<Sequence> sequences;
  const SequencesListLoaded(this.sequences);
}

class SequencesListError extends SequencesListState {
  final String message;
  const SequencesListError(this.message);
}

class SequencesListBloc extends Bloc<SequencesListEvent, SequencesListState> {
  final SequenceRepository repository;

  SequencesListBloc({required this.repository})
      : super(const SequencesListLoading()) {
    on<LoadSequences>(_onLoad);
    on<DeleteSequence>(_onDelete);
  }

  Future<void> _onLoad(LoadSequences event, Emitter<SequencesListState> emit) async {
    emit(const SequencesListLoading());
    try {
      final list = await repository.getAll();
      emit(SequencesListLoaded(list));
    } catch (e) {
      emit(SequencesListError(e.toString()));
    }
  }

  Future<void> _onDelete(DeleteSequence event, Emitter<SequencesListState> emit) async {
    await repository.delete(event.id);
    final list = await repository.getAll();
    emit(SequencesListLoaded(list));
  }
}
