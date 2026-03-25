import 'package:freezed_annotation/freezed_annotation.dart';

part 'idea_generator_event.freezed.dart';

@freezed
class IdeaGeneratorEvent with _$IdeaGeneratorEvent {
  const factory IdeaGeneratorEvent.loadCategories() = LoadCategories;
  const factory IdeaGeneratorEvent.elementAdded(int categoryId) = ElementAdded;
  const factory IdeaGeneratorEvent.elementRemoved(String elementId) = ElementRemoved;
  const factory IdeaGeneratorEvent.generateValues() = GenerateValues;
  const factory IdeaGeneratorEvent.regenerateSingle(String elementId) = RegenerateSingle;
  const factory IdeaGeneratorEvent.navigateToSettings() = NavigateToSettings;
  const factory IdeaGeneratorEvent.clearAllElements() = ClearAllElements;
}
