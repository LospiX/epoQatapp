import 'package:flutter/material.dart';

class ExpandableSearchButton extends StatelessWidget {
  final bool isExpanded;
  final TextEditingController searchController;
  final VoidCallback onToggle;
  final VoidCallback onClose;
  final String heroTag;

  const ExpandableSearchButton({
    super.key,
    required this.isExpanded,
    required this.searchController,
    required this.onToggle,
    required this.onClose,
    this.heroTag = 'search_items',
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isExpanded ? MediaQuery.of(context).size.width * 0.7 : 56,
      height: 56,
      child: isExpanded ? _buildExpandedSearch() : _buildCollapsedButton(context),
    );
  }

  Widget _buildExpandedSearch() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Cerca...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                autofocus: true,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.grey),
              onPressed: onClose,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollapsedButton(BuildContext context) {
    return FloatingActionButton(
      heroTag: heroTag,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      onPressed: onToggle,
      child: const Icon(Icons.search),
    );
  }
}
