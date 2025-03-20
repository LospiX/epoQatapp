import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/game_element.dart';

part 'idea_generator_state.freezed.dart';

@freezed
class IdeaGeneratorState with _$IdeaGeneratorState {
  const factory IdeaGeneratorState.initial() = _Initial;
  const factory IdeaGeneratorState.loading() = _Loading;
  const factory IdeaGeneratorState.loaded({
    required List<GameElement> elements,
    required bool canGenerate,
  }) = _Loaded;
}
