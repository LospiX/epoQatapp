import 'package:flutter/material.dart';
import '../models/sequence_step.dart';
import '../utils/time_format.dart';

class StepTile extends StatelessWidget {
  final int index;
  final SequenceStep step;
  final bool editMode;
  final bool canMoveUp;
  final bool canMoveDown;
  final VoidCallback? onTap;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;
  final VoidCallback? onDelete;

  const StepTile({
    super.key,
    required this.index,
    required this.step,
    required this.editMode,
    this.canMoveUp = false,
    this.canMoveDown = false,
    this.onTap,
    this.onMoveUp,
    this.onMoveDown,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = step.name.isEmpty ? 'Passo ${index + 1}' : step.name;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
          child: Text('${index + 1}'),
        ),
        title: Text(title, style: theme.textTheme.titleSmall),
        subtitle: Row(
          children: [
            const Icon(Icons.timer_outlined, size: 14),
            const SizedBox(width: 4),
            Text(formatDuration(step.durationSeconds)),
            const SizedBox(width: 12),
            const Icon(Icons.repeat, size: 14),
            const SizedBox(width: 4),
            Text('×${step.repetitions}'),
            const SizedBox(width: 12),
            if (step.repEndSound != null)
              Tooltip(
                message: 'Suono fine ripetizione: ${step.repEndSound}',
                child: const Icon(Icons.notifications_active, size: 14),
              ),
            if (step.stepEndSound != null) ...[
              const SizedBox(width: 6),
              Tooltip(
                message: 'Suono fine passo: ${step.stepEndSound}',
                child: const Icon(Icons.music_note, size: 14),
              ),
            ],
          ],
        ),
        trailing: editMode
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_upward),
                    onPressed: canMoveUp ? onMoveUp : null,
                    tooltip: 'Sposta su',
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_downward),
                    onPressed: canMoveDown ? onMoveDown : null,
                    tooltip: 'Sposta giù',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: onDelete,
                    tooltip: 'Elimina',
                  ),
                ],
              )
            : null,
      ),
    );
  }
}
