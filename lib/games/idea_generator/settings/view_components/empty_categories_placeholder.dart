import 'package:flutter/material.dart';

class EmptyCategoriesPlaceholder extends StatelessWidget {
  const EmptyCategoriesPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.category_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.outline.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'Nessuna categoria.\nCrea la tua prima categoria!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.6),
                ),
          ),
        ],
      ),
    );
  }
}
