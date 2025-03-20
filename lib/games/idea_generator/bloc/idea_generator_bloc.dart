import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:epoQatapp/games/idea_generator/bloc/idea_generator_event.dart';
import 'package:epoQatapp/games/idea_generator/bloc/idea_generator_state.dart';
import 'package:epoQatapp/games/idea_generator/repositories/idea_generator_repository.dart';
import '../models/game_element.dart';
import 'dart:math';

// part 'idea_generator_bloc.freezed.dart';
// part 'idea_generator_event.dart';
// part 'idea_generator_state.dart';

class IdeaGeneratorBloc extends Bloc<IdeaGeneratorEvent, IdeaGeneratorState> {
  final IdeaGeneratorRepository repository;

  IdeaGeneratorBloc({required this.repository}) : super(const IdeaGeneratorState.initial()) {
    on<ElementAdded>(_onElementAdded);
    on<ElementRemoved>(_onElementRemoved);
    on<GenerateValues>(_onGenerateValues);
    on<RegenerateSingle>(_onRegenerateSingle);
    on<NavigateToSettings>(_onNavigateToSettings);
    on<ClearAllElements>(_onClearAllElements);
  }

  void _onElementAdded(ElementAdded event, Emitter<IdeaGeneratorState> emit) {
    state.when(
      initial: () => emit(
        IdeaGeneratorState.loaded(
          elements: [
            GameElement(
              id: UniqueKey().toString(),
              type: event.type,
            ),
          ],
          canGenerate: true,
        ),
      ),
      loaded: (elements, canGenerate) => emit(
        IdeaGeneratorState.loaded(
          elements: [
            ...elements,
            GameElement(
              id: UniqueKey().toString(),
              type: event.type,
            ),
          ],
          canGenerate: true,
        ),
      ),
      loading: () {},
    );
  }

  Future<void> _onGenerateValues(GenerateValues event, Emitter<IdeaGeneratorState> emit) async {
    await state.whenOrNull(
      loaded: (elements, _) async {
        // First emit a loading state
        emit(const IdeaGeneratorState.loading());
        
        final updatedElements = <GameElement>[];
        
        // Process each element
        for (final element in elements) {
          final value = await _generateRandomValue(element.type);
          updatedElements.add(element.copyWith(value: value));
        }

        emit(IdeaGeneratorState.loaded(
          elements: updatedElements,
          canGenerate: true,
        ));
      },
    );
  }

  Future<void> _onRegenerateSingle(RegenerateSingle event, Emitter<IdeaGeneratorState> emit) async {
    await state.whenOrNull(
      loaded: (elements, canGenerate) async {
        final updatedElements = <GameElement>[];
        
        for (final element in elements) {
          if (element.id == event.elementId) {
            final value = await _generateRandomValue(element.type);
            updatedElements.add(element.copyWith(value: value));
          } else {
            updatedElements.add(element);
          }
        }

        emit(IdeaGeneratorState.loaded(
          elements: updatedElements,
          canGenerate: canGenerate,
        ));
      },
    );
  }

  void _onElementRemoved(ElementRemoved event, Emitter<IdeaGeneratorState> emit) {
    state.whenOrNull(
      loaded: (elements, canGenerate) {
        final updatedElements = elements.where(
          (e) => e.id != event.elementId
        ).toList();
        
        emit(IdeaGeneratorState.loaded(
          elements: updatedElements,
          canGenerate: canGenerate,
        ));
      },
    );
  }

  void _onNavigateToSettings(NavigateToSettings event, Emitter<IdeaGeneratorState> emit) {
    // This event is handled by the UI to navigate to settings
    // No state change needed
  }

  void _onClearAllElements(ClearAllElements event, Emitter<IdeaGeneratorState> emit) {
    emit(const IdeaGeneratorState.initial());
  }

  Future<String> _generateRandomValue(ElementType type) async {
    final random = Random();
    final options = await repository.getOptionsForType(type);
    if (options.isEmpty) {
      return "Nessun elemento disponibile";
    }
    return options[random.nextInt(options.length)];
  }
}
