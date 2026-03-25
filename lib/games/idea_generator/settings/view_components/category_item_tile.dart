import 'package:flutter/material.dart';
import 'package:epoQatapp/games/idea_generator/models/idea_category.dart';

class CategoryItemTile extends StatelessWidget {
  final String value;
  final IdeaCategory category;
  final VoidCallback onDelete;

  const CategoryItemTile({
    super.key,
    required this.value,
    required this.category,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final categoryColor = category.color;
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
            color: categoryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(category.icon, color: categoryColor),
        ),
        title: Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          category.displayName.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: categoryColor,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
