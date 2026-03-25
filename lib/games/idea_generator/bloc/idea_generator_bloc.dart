import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:epoQatapp/games/idea_generator/bloc/idea_generator_event.dart';
import 'package:epoQatapp/games/idea_generator/bloc/idea_generator_state.dart';
import 'package:epoQatapp/games/idea_generator/repositories/idea_generator_repository.dart';
import '../models/game_element.dart';
import '../models/idea_category.dart';
import 'dart:math';

class IdeaGeneratorBloc extends Bloc<IdeaGeneratorEvent, IdeaGeneratorState> {
  final IdeaGeneratorRepository repository;
  List<IdeaCategory> _categories = [];

  IdeaGeneratorBloc({required this.repository}) : super(const IdeaGeneratorState.initial()) {
    on<LoadCategories>(_onLoadCategories);
    on<ElementAdded>(_onElementAdded);
    on<ElementRemoved>(_onElementRemoved);
    on<GenerateValues>(_onGenerateValues);
    on<RegenerateSingle>(_onRegenerateSingle);
    on<NavigateToSettings>(_onNavigateToSettings);
    on<ClearAllElements>(_onClearAllElements);
  }

  Future<void> _onLoadCategories(LoadCategories event, Emitter<IdeaGeneratorState> emit) async {
    _categories = await repository.getCategories();
    state.when(
      initial: () => emit(
        IdeaGeneratorState.loaded(
          categories: _categories,
          elements: [],
          canGenerate: false,
        ),
      ),
      loaded: (categories, elements, canGenerate) => emit(
        IdeaGeneratorState.loaded(
          categories: _categories,
          elements: elements,
          canGenerate: canGenerate,
        ),
      ),
      loading: () => emit(
        IdeaGeneratorState.loaded(
          categories: _categories,
          elements: [],
          canGenerate: false,
        ),
      ),
    );
  }

  void _onElementAdded(ElementAdded event, Emitter<IdeaGeneratorState> emit) {
    state.when(
      initial: () => emit(
        IdeaGeneratorState.loaded(
          categories: _categories,
          elements: [
            GameElement(
              id: UniqueKey().toString(),
              categoryId: event.categoryId,
            ),
          ],
          canGenerate: true,
        ),
      ),
      loaded: (categories, elements, canGenerate) => emit(
        IdeaGeneratorState.loaded(
          categories: categories,
          elements: [
            ...elements,
            GameElement(
              id: UniqueKey().toString(),
              categoryId: event.categoryId,
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
      loaded: (categories, elements, _) async {
        emit(const IdeaGeneratorState.loading());
        
        final updatedElements = <GameElement>[];
        
        for (final element in elements) {
          final value = await _generateRandomValueByCategoryId(element.categoryId);
          updatedElements.add(element.copyWith(value: value));
        }

        emit(IdeaGeneratorState.loaded(
          categories: categories,
          elements: updatedElements,
          canGenerate: true,
        ));
      },
    );
  }

  Future<void> _onRegenerateSingle(RegenerateSingle event, Emitter<IdeaGeneratorState> emit) async {
    await state.whenOrNull(
      loaded: (categories, elements, canGenerate) async {
        final updatedElements = <GameElement>[];
        
        for (final element in elements) {
          if (element.id == event.elementId) {
            final value = await _generateRandomValueByCategoryId(element.categoryId);
            updatedElements.add(element.copyWith(value: value));
          } else {
            updatedElements.add(element);
          }
        }

        emit(IdeaGeneratorState.loaded(
          categories: categories,
          elements: updatedElements,
          canGenerate: canGenerate,
        ));
      },
    );
  }

  void _onElementRemoved(ElementRemoved event, Emitter<IdeaGeneratorState> emit) {
    state.whenOrNull(
      loaded: (categories, elements, canGenerate) {
        final updatedElements = elements.where(
          (e) => e.id != event.elementId
        ).toList();
        
        emit(IdeaGeneratorState.loaded(
          categories: categories,
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

  Future<String> _generateRandomValueByCategoryId(int categoryId) async {
    final random = Random();
    final options = await repository.getOptionsByCategoryId(categoryId);
    if (options.isEmpty) {
      return "Nessun elemento disponibile";
    }
    return options[random.nextInt(options.length)];
  }
}
