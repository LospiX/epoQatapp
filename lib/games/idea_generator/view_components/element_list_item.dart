import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:epoQatapp/games/idea_generator/bloc/idea_generator_bloc.dart';
import 'package:epoQatapp/games/idea_generator/bloc/idea_generator_event.dart';
import 'package:epoQatapp/games/idea_generator/models/game_element.dart';
import 'package:epoQatapp/games/idea_generator/models/idea_category.dart';

class ElementListItem extends StatelessWidget {
  final GameElement element;
  final IdeaCategory? category;

  const ElementListItem({
    super.key,
    required this.element,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    final color = category?.color ?? Colors.grey;
    final icon = category?.icon ?? Icons.help_outline;
    final displayName = category?.displayName ?? 'Sconosciuto';

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
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          element.value ?? 'Clicca Genera per il risultato',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: element.value == null
                ? Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6)
                : Colors.grey.shade800,
          ),
        ),
        subtitle: Text(
          displayName.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
              onPressed: () => context.read<IdeaGeneratorBloc>().add(
                    IdeaGeneratorEvent.elementRemoved(element.id),
                  ),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: Icon(Icons.autorenew, color: color),
              onPressed: () => context.read<IdeaGeneratorBloc>().add(
                    IdeaGeneratorEvent.regenerateSingle(element.id),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
