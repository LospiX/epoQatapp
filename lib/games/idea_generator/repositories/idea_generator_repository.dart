import 'package:epoQatapp/core/database/database_helper.dart';
import 'package:epoQatapp/games/idea_generator/models/game_element.dart';
import 'package:epoQatapp/games/idea_generator/models/idea_category.dart';

class IdeaGeneratorRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // ─── Category operations ───

  Future<List<IdeaCategory>> getCategories() async {
    final rows = await _databaseHelper.getCategories();
    return rows.map((row) => IdeaCategory.fromMap(row)).toList();
  }

  Future<IdeaCategory?> getCategoryById(int id) async {
    final row = await _databaseHelper.getCategoryById(id);
    return row == null ? null : IdeaCategory.fromMap(row);
  }

  Future<int> addCategory({
    required String name,
    required String displayName,
    required int color,
    required int icon,
  }) async {
    return await _databaseHelper.addCategory(
      name: name,
      displayName: displayName,
      color: color,
      icon: icon,
    );
  }

  Future<int> updateCategory({
    required int id,
    required String displayName,
    required int color,
    required int icon,
  }) async {
    return await _databaseHelper.updateCategory(
      id: id,
      displayName: displayName,
      color: color,
      icon: icon,
    );
  }

  Future<void> deleteCategoryWithElements(int categoryId) async {
    await _databaseHelper.deleteCategoryWithElements(categoryId);
  }

  Future<void> reorderCategories(List<int> orderedCategoryIds) async {
    await _databaseHelper.reorderCategories(orderedCategoryIds);
  }

  Future<int> getElementCountForCategory(int categoryId) async {
    return await _databaseHelper.getElementCountForCategory(categoryId);
  }

  // ─── Element operations ───

  Future<List<String>> getOptionsByCategoryId(int categoryId) async {
    final elements = await _databaseHelper.getElementsByCategoryId(categoryId);
    return elements.map((e) => e['value'] as String).toList();
  }

  // Legacy: kept for backward compat
  Future<List<String>> getOptionsForType(ElementType type) async {
    final elements = await _databaseHelper.getElementsByType(type.name);
    return elements.map((e) => e['value'] as String).toList();
  }

  Future<int> addElementToCategory(int categoryId, String categoryName, String value) async {
    return await _databaseHelper.addElement(categoryName, value, categoryId: categoryId);
  }

  Future<int> deleteElement(int id) async {
    return await _databaseHelper.deleteElement(id);
  }

  Future<List<Map<String, dynamic>>> getElementsByCategoryId(int categoryId) async {
    return await _databaseHelper.getElementsByCategoryId(categoryId);
  }

  // Legacy: kept for backward compat
  Future<List<Map<String, dynamic>>> getElementsWithIdsByType(ElementType type) async {
    return await _databaseHelper.getElementsByType(type.name);
  }

  // ─── Import/Export helpers ───

  Future<void> importCategoryWithElements({
    required String name,
    required String displayName,
    required int color,
    required int icon,
    required List<String> items,
  }) async {
    await _databaseHelper.importCategoryWithElements(
      name: name,
      displayName: displayName,
      color: color,
      icon: icon,
      items: items,
    );
  }
}
