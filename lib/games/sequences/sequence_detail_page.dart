import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/sequence_detail_bloc.dart';
import 'bloc/sequence_runner_bloc.dart';
import 'models/sequence.dart';
import 'models/sequence_step.dart';
import 'sequence_runner_page.dart';
import 'utils/time_format.dart';
import 'view_components/step_editor_sheet.dart';
import 'view_components/step_tile.dart';

class SequenceDetailPage extends StatelessWidget {
  const SequenceDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SequenceDetailBloc, SequenceDetailState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(state.isNew
                ? 'Nuova sequenza'
                : (state.draft.name.isEmpty
                    ? 'Sequenza'
                    : state.draft.name)),
            actions: [
              IconButton(
                icon: Icon(state.isEditMode ? Icons.close : Icons.edit),
                tooltip: state.isEditMode ? 'Annulla' : 'Modifica',
                onPressed: () async {
                  if (state.isEditMode && state.isNew) {
                    // Creating new → cancel pops the page
                    Navigator.of(context).maybePop();
                    return;
                  }
                  context
                      .read<SequenceDetailBloc>()
                      .add(const ToggleEditMode());
                },
              ),
            ],
          ),
          body: _DetailBody(state: state),
          bottomNavigationBar: _BottomBar(state: state),
        );
      },
    );
  }
}

class _DetailBody extends StatelessWidget {
  final SequenceDetailState state;
  const _DetailBody({required this.state});

  @override
  Widget build(BuildContext context) {
    final draft = state.draft;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _HeaderCard(state: state),
        const SizedBox(height: 24),
        Row(
          children: [
            Text(
              'Passi',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Spacer(),
            Text(
              '${draft.steps.length}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (state.isEditMode)
          _EditableStepsList(state: state)
        else
          _ReadonlyStepsList(state: state),
        if (state.isEditMode) ...[
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _openStepEditor(context, null, null),
            icon: const Icon(Icons.add),
            label: const Text('Aggiungi passo'),
          ),
        ],
        if (state.error != null) ...[
          const SizedBox(height: 16),
          SelectableText.rich(
            TextSpan(
              text: state.error!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
        const SizedBox(height: 80),
      ],
    );
  }
}

void _openStepEditor(BuildContext context, int? index, SequenceStep? step) {
  final bloc = context.read<SequenceDetailBloc>();
  final stepsCount = bloc.state.draft.steps.length;
  // When creating a new step, suggest "Passo N"; when editing, keep existing.
  final defaultName =
      index == null ? 'Passo ${stepsCount + 1}' : 'Passo ${index + 1}';
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => StepEditorSheet(
      initial: step,
      defaultName: defaultName,
      onSubmit: (newStep) {
        if (index == null) {
          bloc.add(AddStep(newStep));
        } else {
          bloc.add(UpdateStep(index, newStep));
        }
      },
    ),
  );
}

class _HeaderCard extends StatefulWidget {
  final SequenceDetailState state;
  const _HeaderCard({required this.state});

  @override
  State<_HeaderCard> createState() => _HeaderCardState();
}

class _HeaderCardState extends State<_HeaderCard> {
  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;
  SequenceDetailState? _lastState;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.state.draft.name);
    _descCtrl = TextEditingController(text: widget.state.draft.description);
    _lastState = widget.state;
  }

  @override
  void didUpdateWidget(covariant _HeaderCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If draft changed externally (e.g. cancel edit), sync controllers.
    if (_lastState?.draft.name != widget.state.draft.name &&
        _nameCtrl.text != widget.state.draft.name) {
      _nameCtrl.text = widget.state.draft.name;
    }
    if (_lastState?.draft.description != widget.state.draft.description &&
        _descCtrl.text != widget.state.draft.description) {
      _descCtrl.text = widget.state.draft.description;
    }
    _lastState = widget.state;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final draft = state.draft;
    final theme = Theme.of(context);
    final bloc = context.read<SequenceDetailBloc>();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state.isEditMode)
              TextField(
                controller: _nameCtrl,
                style: theme.textTheme.headlineSmall,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => bloc.add(UpdateName(v)),
              )
            else
              Text(
                draft.name.isEmpty ? '(Senza nome)' : draft.name,
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Chip(
                  avatar: const Icon(Icons.schedule, size: 16),
                  label: Text(
                    'Durata totale: ${formatDuration(draft.totalDurationSeconds)}',
                  ),
                ),
                const SizedBox(width: 8),
                Chip(
                  avatar: const Icon(Icons.format_list_numbered, size: 16),
                  label: Text('${draft.steps.length} passi'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (state.isEditMode)
              TextField(
                controller: _descCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descrizione',
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => bloc.add(UpdateDescription(v)),
              )
            else
              Text(
                draft.description.isEmpty
                    ? 'Nessuna descrizione'
                    : draft.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: draft.description.isEmpty ? Colors.grey : null,
                  fontStyle:
                      draft.description.isEmpty ? FontStyle.italic : null,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ReadonlyStepsList extends StatelessWidget {
  final SequenceDetailState state;
  const _ReadonlyStepsList({required this.state});

  @override
  Widget build(BuildContext context) {
    final steps = state.draft.steps;
    if (steps.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            'Nessun passo. Attiva la modalità modifica per aggiungerne.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return Column(
      children: [
        for (int i = 0; i < steps.length; i++)
          StepTile(
            key: ValueKey('ro_$i'),
            index: i,
            step: steps[i],
            editMode: false,
          ),
      ],
    );
  }
}

class _EditableStepsList extends StatelessWidget {
  final SequenceDetailState state;
  const _EditableStepsList({required this.state});

  @override
  Widget build(BuildContext context) {
    final steps = state.draft.steps;
    final bloc = context.read<SequenceDetailBloc>();
    if (steps.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            'Aggiungi il primo passo.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      buildDefaultDragHandles: true,
      itemCount: steps.length,
      onReorder: (oldIndex, newIndex) {
        bloc.add(ReorderStep(oldIndex, newIndex));
      },
      itemBuilder: (ctx, i) {
        final step = steps[i];
        return StepTile(
          key: ValueKey('edit_${step.id ?? 'new'}_$i'),
          index: i,
          step: step,
          editMode: true,
          canMoveUp: i > 0,
          canMoveDown: i < steps.length - 1,
          onTap: () => _openStepEditor(context, i, step),
          onMoveUp: () => bloc.add(ReorderStep(i, i - 1)),
          onMoveDown: () => bloc.add(ReorderStep(i, i + 2)),
          onDelete: () => bloc.add(RemoveStep(i)),
        );
      },
    );
  }
}

class _BottomBar extends StatelessWidget {
  final SequenceDetailState state;
  const _BottomBar({required this.state});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SequenceDetailBloc>();
    if (state.isEditMode) {
      if (!state.isDirty) {
        return const SizedBox.shrink();
      }
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: FilledButton.icon(
            onPressed: () => bloc.add(const SaveChanges()),
            icon: const Icon(Icons.save),
            label: const Text('Salva modifiche'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
          ),
        ),
      );
    }

    // View mode: show Start button
    final canStart = state.draft.steps.isNotEmpty;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: FilledButton.icon(
          onPressed: canStart
              ? () => _startSequence(context, state.draft)
              : null,
          icon: const Icon(Icons.play_arrow),
          label: const Text('Start'),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  void _startSequence(BuildContext context, Sequence seq) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider<SequenceRunnerBloc>(
          create: (_) =>
              SequenceRunnerBloc(sequence: seq)..add(const RunnerStart()),
          child: const SequenceRunnerPage(),
        ),
      ),
    );
  }
}
