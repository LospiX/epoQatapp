import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/sequences_list_bloc.dart';
import 'bloc/sequence_detail_bloc.dart';
import 'models/sequence.dart';
import 'repositories/sequence_repository.dart';
import 'sequence_detail_page.dart';
import 'utils/time_format.dart';

class SequencesListPage extends StatelessWidget {
  const SequencesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SequencesListBloc>(
      create: (ctx) => SequencesListBloc(
        repository: ctx.read<SequenceRepository>(),
      )..add(const LoadSequences()),
      child: const _SequencesListView(),
    );
  }
}

class _SequencesListView extends StatelessWidget {
  const _SequencesListView();

  Future<void> _openDetail(BuildContext context, int? id) async {
    final repo = context.read<SequenceRepository>();
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider<SequenceDetailBloc>(
          create: (_) =>
              SequenceDetailBloc(repository: repo)..add(LoadSequence(id)),
          child: const SequenceDetailPage(),
        ),
      ),
    );
    if (context.mounted) {
      context.read<SequencesListBloc>().add(const LoadSequences());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SeQuences'),
      ),
      body: BlocBuilder<SequencesListBloc, SequencesListState>(
        builder: (context, state) {
          return switch (state) {
            SequencesListLoading() =>
              const Center(child: CircularProgressIndicator()),
            SequencesListError(message: final m) =>
              Center(child: Text('Errore: $m')),
            SequencesListLoaded(sequences: final list) => list.isEmpty
                ? _EmptyState(onCreate: () => _openDetail(context, null))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: list.length,
                    itemBuilder: (ctx, i) => _SequenceCard(
                      sequence: list[i],
                      onTap: () => _openDetail(context, list[i].id),
                      onDelete: () =>
                          _confirmDelete(context, list[i]),
                    ),
                  ),
          };
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openDetail(context, null),
        icon: const Icon(Icons.add),
        label: const Text('Nuova'),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Sequence seq) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminare la sequenza?'),
        content: Text('"${seq.name}" verrà eliminata definitivamente.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annulla'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Elimina'),
          ),
        ],
      ),
    );
    if (ok == true && seq.id != null && context.mounted) {
      context.read<SequencesListBloc>().add(DeleteSequence(seq.id!));
    }
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onCreate;
  const _EmptyState({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined,
              size: 72,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            'Nessuna sequenza salvata',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Crea la tua prima sequenza di passi a tempo.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.add),
            label: const Text('Crea sequenza'),
          ),
        ],
      ),
    );
  }
}

class _SequenceCard extends StatelessWidget {
  final Sequence sequence;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _SequenceCard({
    required this.sequence,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        onLongPress: onDelete,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.timer_outlined, size: 34),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sequence.name,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${sequence.steps.length} passi · '
                      '${formatDuration(sequence.totalDurationSeconds)}',
                      style: theme.textTheme.bodySmall,
                    ),
                    if (sequence.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        sequence.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
