import 'package:flutter/material.dart';
import 'package:epoQatapp/games/idea_generator/models/idea_category.dart';
import 'package:epoQatapp/games/idea_generator/repositories/idea_generator_repository.dart';
import 'package:epoQatapp/games/idea_generator/settings/view_components/category_item_tile.dart';
import 'package:epoQatapp/games/idea_generator/settings/view_components/expandable_search_button.dart';

class CategoryItemsPage extends StatefulWidget {
  final IdeaCategory category;
  final IdeaGeneratorRepository repository;

  const CategoryItemsPage({
    super.key,
    required this.category,
    required this.repository,
  });

  @override
  State<CategoryItemsPage> createState() => _CategoryItemsPageState();
}

class _CategoryItemsPageState extends State<CategoryItemsPage> {
  final TextEditingController _newElementController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allElements = [];
  List<Map<String, dynamic>> _filteredElements = [];
  bool _isSearchExpanded = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterElements);
    _loadElements();
  }

  @override
  void dispose() {
    _newElementController.dispose();
    _searchController.removeListener(_filterElements);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadElements() async {
    setState(() => _isLoading = true);
    final elements = await widget.repository.getElementsByCategoryId(widget.category.id);
    setState(() {
      _allElements = elements;
      _filteredElements = List.from(elements);
      _isLoading = false;
    });
  }

  void _filterElements() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredElements = List.from(_allElements);
      } else {
        _filteredElements = _allElements
            .where((e) => e['value'].toString().toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = widget.category.color;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(widget.category.icon, color: categoryColor, size: 24),
            const SizedBox(width: 8),
            Text(widget.category.displayName),
          ],
        ),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredElements.isEmpty && _allElements.isEmpty
              ? _buildEmptyState(context)
              : _buildElementList(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExpandableSearchButton(
            isExpanded: _isSearchExpanded,
            searchController: _searchController,
            onToggle: () => setState(() => _isSearchExpanded = !_isSearchExpanded),
            onClose: () => setState(() {
              _isSearchExpanded = false;
              _searchController.clear();
            }),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'add_item',
            backgroundColor: categoryColor,
            onPressed: () => _showAddElementDialog(context),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.category.icon,
            size: 64,
            color: Theme.of(context).colorScheme.outline.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'Nessun elemento trovato',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.6),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildElementList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      itemCount: _filteredElements.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final element = _filteredElements[index];
        return CategoryItemTile(
          value: element['value'] as String,
          category: widget.category,
          onDelete: () => _confirmDelete(context, element),
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, Map<String, dynamic> element) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Conferma eliminazione'),
        content: Text('Sei sicuro di voler eliminare "${element['value']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('ANNULLA'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('ELIMINA'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await widget.repository.deleteElement(element['id'] as int);
      await _loadElements();
    }
  }

  void _showAddElementDialog(BuildContext context) {
    final categoryColor = widget.category.color;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Aggiungi ${widget.category.displayName}'),
        content: TextField(
          controller: _newElementController,
          decoration: InputDecoration(
            hintText: 'Inserisci nuovo elemento',
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: categoryColor),
            ),
          ),
          maxLines: null,
          textCapitalization: TextCapitalization.sentences,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _newElementController.clear();
            },
            child: const Text('ANNULLA'),
          ),
          TextButton(
            onPressed: () async {
              final value = _newElementController.text.trim();
              if (value.isNotEmpty) {
                await widget.repository.addElementToCategory(
                  widget.category.id,
                  widget.category.name,
                  value,
                );
                if (mounted) {
                  Navigator.of(context).pop();
                  _newElementController.clear();
                  await _loadElements();
                }
              }
            },
            child: const Text('AGGIUNGI'),
          ),
        ],
      ),
    );
  }
}
