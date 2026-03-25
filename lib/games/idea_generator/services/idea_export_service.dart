import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:epoQatapp/games/idea_generator/repositories/idea_generator_repository.dart';

class IdeaExportService {
  final IdeaGeneratorRepository _repository;

  IdeaExportService(this._repository);

  // ─── Export ───

  Future<void> exportAll(BuildContext context) async {
    final categories = await _repository.getCategories();
    final exportData = <String, dynamic>{
      'version': 1,
      'exported_at': DateTime.now().toIso8601String(),
      'categories': <Map<String, dynamic>>[],
    };

    for (final category in categories) {
      final items = await _repository.getOptionsByCategoryId(category.id);
      (exportData['categories'] as List).add({
        'name': category.name,
        'display_name': category.displayName,
        'color': category.colorValue,
        'icon': category.iconCodePoint,
        'sort_order': category.sortOrder,
        'items': items,
      });
    }

    final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/epoqat_ideas.json');
    await file.writeAsString(jsonString);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'Dati Generatore di Idee - epoQatapp',
    );
  }

  // ─── Import ───

  Future<ImportPreview?> pickAndPreview() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null || result.files.single.path == null) return null;

    final file = File(result.files.single.path!);
    final jsonString = await file.readAsString();

    try {
      final data = json.decode(jsonString) as Map<String, dynamic>;
      final version = data['version'] as int?;
      if (version != 1) return null;

      final categoriesJson = data['categories'] as List<dynamic>;
      final previewCategories = categoriesJson.map((catJson) {
        final cat = catJson as Map<String, dynamic>;
        return ImportCategoryPreview(
          name: cat['name'] as String,
          displayName: cat['display_name'] as String,
          colorValue: cat['color'] as int,
          iconCodePoint: cat['icon'] as int,
          sortOrder: cat['sort_order'] as int? ?? 0,
          items: (cat['items'] as List<dynamic>).cast<String>(),
        );
      }).toList();

      return ImportPreview(categories: previewCategories);
    } catch (e) {
      return null;
    }
  }

  Future<int> importCategories(ImportPreview preview, {List<int>? selectedIndices}) async {
    int importedCount = 0;
    final indicesToImport = selectedIndices ??
        List.generate(preview.categories.length, (i) => i);

    for (final index in indicesToImport) {
      final cat = preview.categories[index];
      await _repository.importCategoryWithElements(
        name: cat.name,
        displayName: cat.displayName,
        color: cat.colorValue,
        icon: cat.iconCodePoint,
        items: cat.items,
      );
      importedCount++;
    }
    return importedCount;
  }
}

class ImportPreview {
  final List<ImportCategoryPreview> categories;
  const ImportPreview({required this.categories});
}

class ImportCategoryPreview {
  final String name;
  final String displayName;
  final int colorValue;
  final int iconCodePoint;
  final int sortOrder;
  final List<String> items;

  const ImportCategoryPreview({
    required this.name,
    required this.displayName,
    required this.colorValue,
    required this.iconCodePoint,
    required this.sortOrder,
    required this.items,
  });

  Color get color => Color(colorValue);
  IconData get icon => IconData(iconCodePoint, fontFamily: 'MaterialIcons');
}
