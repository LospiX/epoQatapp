import 'package:flutter/material.dart';
import 'package:epoQatapp/games/idea_generator/models/game_element.dart';
import 'package:epoQatapp/games/idea_generator/repositories/idea_generator_repository.dart';

class IdeaGeneratorSettingsPage extends StatefulWidget {
  final IdeaGeneratorRepository repository;

  const IdeaGeneratorSettingsPage({
    Key? key,
    required this.repository,
  }) : super(key: key);

  @override
  State<IdeaGeneratorSettingsPage> createState() => _IdeaGeneratorSettingsPageState();
}

class _IdeaGeneratorSettingsPageState extends State<IdeaGeneratorSettingsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _newElementController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  Color _currentIndicatorColor = Colors.blue; // Default to first tab color
  bool _isSearchExpanded = false;
  List<Map<String, dynamic>> _filteredElements = [];
  List<Map<String, dynamic>> _allElements = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: ElementType.values.length, vsync: this);
    _currentIndicatorColor = ElementType.values[0].color;
    _tabController.addListener(_handleTabChange);
    _searchController.addListener(_handleSearchChange);
    _loadElements();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging || _tabController.index != _tabController.previousIndex) {
      setState(() {
        _currentIndicatorColor = ElementType.values[_tabController.index].color;
        _searchController.clear();
        _isSearchExpanded = false;
        _loadElements();
      });
    }
  }

  void _filterElements() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _filteredElements = List.from(_allElements);
      });
      return;
    }

    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredElements = _allElements
          .where((element) => element['value'].toString().toLowerCase().contains(query))
          .toList();
    });
  }

  void _handleSearchChange() {
    _filterElements();
    
    // If search text is empty, collapse the search field after a short delay
    if (_searchController.text.isEmpty && _isSearchExpanded) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted && _searchController.text.isEmpty) {
          setState(() {
            _isSearchExpanded = false;
          });
        }
      });
    }
  }

  Future<void> _loadElements() async {
    final currentType = ElementType.values[_tabController.index];
    final elements = await widget.repository.getElementsWithIdsByType(currentType);
    setState(() {
      _allElements = elements;
      _filteredElements = List.from(elements);
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _searchController.removeListener(_handleSearchChange);
    _tabController.dispose();
    _newElementController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Impostazioni Generatore di Idee'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(top: 12),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Colors.black87,
              unselectedLabelColor: Colors.black54,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  width: 3,
                  color: _currentIndicatorColor,
                ),
                insets: const EdgeInsets.symmetric(horizontal: 8),
              ),
              tabs: ElementType.values.map((type) {
                return Tab(
                  icon: Icon(
                    type.icon,
                    color: type.color,
                    size: 28,
                  ),
                  text: type.displayName,
                  height: 60,
                );
              }).toList(),
            ),
          ),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: ElementType.values.map((type) {
                return _ElementTypeTab(
                  type: type,
                  repository: widget.repository,
                  onRefresh: () => setState(() {}),
                  searchController: _searchController,
                  filteredElements: _filteredElements,
                  allElements: _allElements,
                  loadElements: _loadElements,
                );
              }).toList(),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Search button
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _isSearchExpanded ? MediaQuery.of(context).size.width * 0.7 : 56,
            height: 56,
            child: _isSearchExpanded
                ? Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                hintText: 'Cerca...',
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              autofocus: true,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              // Always collapse on X click
                              setState(() {
                                _isSearchExpanded = false;
                                // Clear text if there is any
                                if (_searchController.text.isNotEmpty) {
                                  _searchController.clear();
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                : FloatingActionButton(
                    heroTag: 'search',
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    onPressed: () {
                      setState(() {
                        _isSearchExpanded = true;
                      });
                    },
                    child: const Icon(Icons.search),
                  ),
          ),
          const SizedBox(width: 16),
          // Add button
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () => _showAddElementDialog(context),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  void _showAddElementDialog(BuildContext context) {
    final currentType = ElementType.values[_tabController.index];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Aggiungi ${currentType.displayName}'),
        content: TextField(
          controller: _newElementController,
          decoration: InputDecoration(
            hintText: 'Inserisci nuovo ${currentType.displayName.toLowerCase()}',
            border: const OutlineInputBorder(),
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
                await widget.repository.addElement(currentType, value);
                if (mounted) {
                  Navigator.of(context).pop();
                  setState(() {});
                  _newElementController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${currentType.displayName} aggiunto')),
                  );
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

class _ElementTypeTab extends StatefulWidget {
  final ElementType type;
  final IdeaGeneratorRepository repository;
  final VoidCallback onRefresh;
  final TextEditingController searchController;
  final List<Map<String, dynamic>> filteredElements;
  final List<Map<String, dynamic>> allElements;
  final Future<void> Function() loadElements;

  const _ElementTypeTab({
    Key? key,
    required this.type,
    required this.repository,
    required this.onRefresh,
    required this.searchController,
    required this.filteredElements,
    required this.allElements,
    required this.loadElements,
  }) : super(key: key);

  @override
  State<_ElementTypeTab> createState() => _ElementTypeTabState();
}

class _ElementTypeTabState extends State<_ElementTypeTab> {
  late Future<List<Map<String, dynamic>>> _elementsFuture;

  @override
  void initState() {
    super.initState();
    _refreshElements();
  }

  void _refreshElements() {
    _elementsFuture = widget.repository.getElementsWithIdsByType(widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _elementsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(
            child: SelectableText.rich(
              TextSpan(
                text: 'Errore nel caricamento dei dati: ',
                style: TextStyle(color: Colors.red),
                children: [
                  TextSpan(
                    text: snapshot.error.toString(),
                  ),
                ],
              ),
            ),
          );
        }
        
        final elements = snapshot.data ?? [];
        
        if (elements.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.type.icon,
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
        
        return RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _refreshElements();
            });
            await _elementsFuture; // Fix: Wait for the future to complete without returning it
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: widget.filteredElements.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final element = widget.filteredElements[index];
              return _ElementListItem(
                id: element['id'],
                value: element['value'],
                type: widget.type,
                onDelete: () async {
                  await widget.repository.deleteElement(element['id']);
                  setState(() {
                    _refreshElements();
                  });
                  widget.onRefresh();
                  widget.loadElements();
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _ElementListItem extends StatelessWidget {
  final int id;
  final String value;
  final ElementType type;
  final VoidCallback onDelete;

  const _ElementListItem({
    Key? key,
    required this.id,
    required this.value,
    required this.type,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: type.color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            type.icon,
            color: type.color,
          ),
        ),
        title: Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          type.displayName.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: type.color,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
          onPressed: () => _showDeleteConfirmationDialog(context),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Conferma eliminazione'),
        content: Text('Sei sicuro di voler eliminare "$value"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ANNULLA'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDelete();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Elemento eliminato')),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('ELIMINA'),
          ),
        ],
      ),
    );
  }
}
