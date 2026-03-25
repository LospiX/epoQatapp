import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:epoQatapp/games/idea_generator/bloc/idea_generator_bloc.dart';
import 'package:epoQatapp/games/idea_generator/bloc/idea_generator_event.dart';
import 'package:epoQatapp/games/idea_generator/bloc/idea_generator_state.dart';
import 'package:epoQatapp/games/idea_generator/models/idea_category.dart';
import 'package:epoQatapp/games/idea_generator/view_components/category_card.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IdeaGeneratorBloc, IdeaGeneratorState>(
      builder: (context, state) {
        final categories = state.maybeWhen(
          loaded: (categories, elements, canGenerate) => categories,
          orElse: () => <IdeaCategory>[],
        );

        if (categories.isEmpty) {
          return const SizedBox(height: 120);
        }

        return SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final category = categories[index];
              return CategoryCard(
                category: category,
                onPressed: () => context.read<IdeaGeneratorBloc>().add(
                  IdeaGeneratorEvent.elementAdded(category.id),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
