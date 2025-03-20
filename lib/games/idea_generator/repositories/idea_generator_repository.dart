import 'package:epoQatapp/core/database/database_helper.dart';
import 'package:epoQatapp/games/idea_generator/models/game_element.dart';

class IdeaGeneratorRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Get all options for a specific element type
  Future<List<String>> getOptionsForType(ElementType type) async {
    final elements = await _databaseHelper.getElementsByType(type.name);
    return elements.map((e) => e['value'] as String).toList();
  }

  // Add a new element
  Future<int> addElement(ElementType type, String value) async {
    return await _databaseHelper.addElement(type.name, value);
  }

  // Delete an element
  Future<int> deleteElement(int id) async {
    return await _databaseHelper.deleteElement(id);
  }

  // Get all elements with their IDs for a specific type (for management UI)
  Future<List<Map<String, dynamic>>> getElementsWithIdsByType(ElementType type) async {
    return await _databaseHelper.getElementsByType(type.name);
  }
}
