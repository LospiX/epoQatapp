import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:epoQatapp/games/idea_generator/bloc/idea_generator_bloc.dart';
import 'package:epoQatapp/games/idea_generator/bloc/idea_generator_event.dart';
import 'package:epoQatapp/games/idea_generator/bloc/idea_generator_state.dart';
import 'package:epoQatapp/games/idea_generator/models/idea_category.dart';
import 'package:epoQatapp/games/idea_generator/view_components/element_list_item.dart';
import 'package:epoQatapp/games/idea_generator/view_components/empty_state_placeholder.dart';

class SelectedElementsList extends StatelessWidget {
  const SelectedElementsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IdeaGeneratorBloc, IdeaGeneratorState>(
      builder: (context, state) {
        return state.maybeWhen(
          loaded: (categories, elements, canGenerate) {
            if (elements.isEmpty) {
              return const EmptyStatePlaceholder();
            }

            return Column(
              children: [
                _ClearAllButton(
                  onPressed: () {
                    for (final element in List.from(elements)) {
                      context.read<IdeaGeneratorBloc>().add(
                        IdeaGeneratorEvent.elementRemoved(element.id),
                      );
                    }
                  },
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemCount: elements.length,
                    itemBuilder: (context, index) {
                      final element = elements[index];
                      final category = categories.cast<IdeaCategory?>().firstWhere(
                        (c) => c!.id == element.categoryId,
                        orElse: () => null,
                      );
                      return ElementListItem(
                        element: element,
                        category: category,
                      );
                    },
                  ),
                ),
              ],
            );
          },
          orElse: () => const EmptyStatePlaceholder(),
        );
      },
    );
  }
}

class _ClearAllButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ClearAllButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, right: 16),
      child: Align(
        alignment: Alignment.topRight,
        child: TextButton.icon(
          icon: const Icon(Icons.clear_all),
          label: const Text('Cancella tutto'),
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
        ),
      ),
    );
  }
}
