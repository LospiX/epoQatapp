import 'package:flutter/material.dart';
import 'package:epoQatapp/games/idea_generator/models/idea_category.dart';
import 'package:epoQatapp/games/idea_generator/repositories/idea_generator_repository.dart';

class CategoryListItem extends StatefulWidget {
  final IdeaCategory category;
  final IdeaGeneratorRepository repository;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const CategoryListItem({
    super.key,
    required this.category,
    required this.repository,
    required this.onTap,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  State<CategoryListItem> createState() => _CategoryListItemState();
}

class _CategoryListItemState extends State<CategoryListItem> {
  int _itemCount = 0;

  @override
  void initState() {
    super.initState();
    _loadCount();
  }

  Future<void> _loadCount() async {
    final count = await widget.repository.getElementCountForCategory(widget.category.id);
    if (mounted) setState(() => _itemCount = count);
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = widget.category.color;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.category.icon, color: categoryColor, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.category.displayName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$_itemCount elementi',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit_outlined, color: Colors.grey.shade500, size: 20),
                onPressed: widget.onEdit,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.red.shade400, size: 20),
                onPressed: widget.onDelete,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
              ReorderableDragStartListener(
                index: 0,
                child: Icon(Icons.drag_handle, color: Colors.grey.shade400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
