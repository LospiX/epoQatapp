import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:epoQatapp/games/idea_generator/bloc/idea_generator_bloc.dart';
import 'package:epoQatapp/games/idea_generator/bloc/idea_generator_event.dart';
import 'package:epoQatapp/games/idea_generator/bloc/idea_generator_state.dart';
import 'package:epoQatapp/games/idea_generator/models/game_element.dart';
import 'package:epoQatapp/games/idea_generator/repositories/idea_generator_repository.dart';
import 'package:epoQatapp/games/idea_generator/view_components/element_card.dart';
import 'package:epoQatapp/games/idea_generator/settings/idea_generator_settings_page.dart';

@immutable
class IdeaGeneratorPage extends StatelessWidget {
  const IdeaGeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generatore di Idee Creative'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.read<IdeaGeneratorBloc>().add(
                const IdeaGeneratorEvent.navigateToSettings(),
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => IdeaGeneratorSettingsPage(
                    repository: context.read<IdeaGeneratorRepository>(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<IdeaGeneratorBloc, IdeaGeneratorState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            orElse: () => const _GamePanel(),
          );
        },
      ),
    );
  }
}

class _GamePanel extends StatelessWidget {
  const _GamePanel();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const _ElementSelector(),
          const SizedBox(height: 24),
          Expanded(
            child: _SelectedElementsList(),
          ),
          const _GenerateButton(),
        ],
      ),
    );
  }
}

class _ElementSelector extends StatelessWidget {
  const _ElementSelector();
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: ElementType.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final type = ElementType.values[index];
          return ElementCard(
            type: type,
            onPressed: () => context.read<IdeaGeneratorBloc>().add(
              IdeaGeneratorEvent.elementAdded(type),
            ),
          );
        },
      ),
    );
  }
}

class _SelectedElementsList extends StatelessWidget {
  const _SelectedElementsList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IdeaGeneratorBloc, IdeaGeneratorState>(
      builder: (context, state) {
        return state.maybeWhen(
          loaded: (elements, canGenerate) {
            if (elements.isEmpty) {
              return const _EmptyStatePlaceholder();
            }
            
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8, right: 16),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: TextButton.icon(
                      icon: const Icon(Icons.clear_all),
                      label: const Text('Cancella tutto'),
                      onPressed: () {
                        // Remove all elements one by one
                        for (final element in List.from(elements)) {
                          context.read<IdeaGeneratorBloc>().add(
                            IdeaGeneratorEvent.elementRemoved(element.id),
                          );
                        }
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemCount: elements.length,
                    itemBuilder: (context, index) {
                      final element = elements[index];
                      return _ElementListItem(element: element);
                    },
                  ),
                ),
              ],
            );
          },
          orElse: () => const _EmptyStatePlaceholder(),
        );
      },
    );
  }
}

class _ElementListItem extends StatelessWidget {
  final GameElement element;

  const _ElementListItem({required this.element});

  @override
  Widget build(BuildContext context) {
    return // In _ElementListItem widget
        Container(
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
            color: element.type.color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            element.type.icon,
            color: element.type.color,
          ),
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
          element.type.displayName.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: element.type.color,
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
              icon: Icon(Icons.autorenew, color: element.type.color),
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

class _EmptyStatePlaceholder extends StatelessWidget {
  const _EmptyStatePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lightbulb_outline_rounded,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
          ),
          const SizedBox(height: 16),
          Text('Aggiungi elementi per iniziare',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _GenerateButton extends StatelessWidget {
  const _GenerateButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IdeaGeneratorBloc, IdeaGeneratorState>(
      builder: (context, state) {
        return ElevatedButton.icon(
          icon: Icon(Icons.auto_awesome, color: Theme.of(context).colorScheme.onPrimary),
          label: const Text('Genera Idee'),
          onPressed: () => context.read<IdeaGeneratorBloc>().add(
            const IdeaGeneratorEvent.generateValues(),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        );
      },
    );
  }
}
