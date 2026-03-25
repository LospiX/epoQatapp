import 'package:flutter/material.dart';
import 'package:epoQatapp/games/idea_generator/models/idea_category.dart';
import 'package:epoQatapp/games/idea_generator/repositories/idea_generator_repository.dart';
import 'package:epoQatapp/games/idea_generator/services/idea_export_service.dart';
import 'package:epoQatapp/games/idea_generator/settings/category_items_page.dart';
import 'package:epoQatapp/games/idea_generator/settings/view_components/category_list_item.dart';
import 'package:epoQatapp/games/idea_generator/settings/view_components/create_category_dialog.dart';
import 'package:epoQatapp/games/idea_generator/settings/view_components/delete_category_modal.dart';
import 'package:epoQatapp/games/idea_generator/settings/view_components/empty_categories_placeholder.dart';
import 'package:epoQatapp/games/idea_generator/settings/view_components/import_preview_dialog.dart';

class IdeaGeneratorSettingsPage extends StatefulWidget {
  final IdeaGeneratorRepository repository;

  const IdeaGeneratorSettingsPage({
    Key? key,
    required this.repository,
  }) : super(key: key);

  @override
  State<IdeaGeneratorSettingsPage> createState() => _IdeaGeneratorSettingsPageState();
}

class _IdeaGeneratorSettingsPageState extends State<IdeaGeneratorSettingsPage> {
  List<IdeaCategory> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() => _isLoading = true);
    final categories = await widget.repository.getCategories();
    setState(() {
      _categories = categories;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorie'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_upload_outlined),
            tooltip: 'Importa',
            onPressed: _onImport,
          ),
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            tooltip: 'Esporta',
            onPressed: _onExport,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _categories.isEmpty
              ? const EmptyCategoriesPlaceholder()
              : _buildCategoryList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onCreateCategory,
        icon: const Icon(Icons.add),
        label: const Text('Nuova Categoria'),
      ),
    );
  }

  Widget _buildCategoryList() {
    return ReorderableListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      onReorder: _onReorder,
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        return CategoryListItem(
          key: ValueKey(category.id),
          category: category,
          repository: widget.repository,
          onTap: () => _onCategoryTap(category),
          onDelete: () => _onDeleteCategory(category),
          onEdit: () => _onEditCategory(category),
        );
      },
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = _categories.removeAt(oldIndex);
      _categories.insert(newIndex, item);
    });
    final orderedIds = _categories.map((c) => c.id).toList();
    widget.repository.reorderCategories(orderedIds);
  }

  Future<void> _onDeleteCategory(IdeaCategory category) async {
    final itemCount = await widget.repository.getElementCountForCategory(category.id);
    if (!mounted) return;

    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DeleteCategoryModal(
        category: category,
        itemCount: itemCount,
      ),
    );

    if (confirmed == true) {
      await widget.repository.deleteCategoryWithElements(category.id);
      await _loadCategories();
    }
  }

  Future<void> _onEditCategory(IdeaCategory category) async {
    final result = await showDialog<CategoryDialogResult>(
      context: context,
      builder: (_) => CreateCategoryDialog(
        title: 'Modifica Categoria',
        initialName: category.displayName,
        initialColor: category.color,
        initialIcon: category.icon,
      ),
    );

    if (result != null) {
      await widget.repository.updateCategory(
        id: category.id,
        displayName: result.name,
        color: result.color.value,
        icon: result.icon.codePoint,
      );
      await _loadCategories();
    }
  }

  Future<void> _onCreateCategory() async {
    final result = await showDialog<CategoryDialogResult>(
      context: context,
      builder: (_) => const CreateCategoryDialog(),
    );

    if (result != null) {
      final safeName = result.name
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-z0-9]'), '_');
      await widget.repository.addCategory(
        name: safeName,
        displayName: result.name,
        color: result.color.value,
        icon: result.icon.codePoint,
      );
      await _loadCategories();
    }
  }

  void _onCategoryTap(IdeaCategory category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryItemsPage(
          category: category,
          repository: widget.repository,
        ),
      ),
    ).then((_) => _loadCategories());
  }

  Future<void> _onExport() async {
    final service = IdeaExportService(widget.repository);
    await service.exportAll(context);
  }

  Future<void> _onImport() async {
    final service = IdeaExportService(widget.repository);
    final preview = await service.pickAndPreview();
    if (preview == null || !mounted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Formato file non valido o nessun file selezionato')),
        );
      }
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => ImportPreviewDialog(preview: preview),
    );

    if (confirmed == true) {
      final count = await service.importCategories(preview);
      await _loadCategories();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$count categorie importate con successo')),
        );
      }
    }
  }
}
