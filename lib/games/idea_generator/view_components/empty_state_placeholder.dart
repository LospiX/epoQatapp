import 'package:flutter/material.dart';

class EmptyStatePlaceholder extends StatelessWidget {
  const EmptyStatePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
          ),
          const SizedBox(height: 16),
          Text(
            'Aggiungi elementi per iniziare',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
