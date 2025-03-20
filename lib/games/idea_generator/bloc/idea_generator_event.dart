import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/game_element.dart';

part 'idea_generator_event.freezed.dart';

@freezed
class IdeaGeneratorEvent with _$IdeaGeneratorEvent {
  const factory IdeaGeneratorEvent.elementAdded(ElementType type) = ElementAdded;
  const factory IdeaGeneratorEvent.elementRemoved(String elementId) = ElementRemoved;
  const factory IdeaGeneratorEvent.generateValues() = GenerateValues;
  const factory IdeaGeneratorEvent.regenerateSingle(String elementId) = RegenerateSingle;
  const factory IdeaGeneratorEvent.navigateToSettings() = NavigateToSettings;
  const factory IdeaGeneratorEvent.clearAllElements() = ClearAllElements;
}
