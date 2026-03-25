import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:epoQatapp/games/idea_generator/bloc/idea_generator_bloc.dart';
import 'package:epoQatapp/games/idea_generator/bloc/idea_generator_event.dart';
import 'package:epoQatapp/games/idea_generator/bloc/idea_generator_state.dart';

class GenerateButton extends StatelessWidget {
  const GenerateButton({super.key});

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
