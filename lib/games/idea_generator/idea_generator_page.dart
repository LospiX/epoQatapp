import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:epoQatapp/games/idea_generator/bloc/idea_generator_bloc.dart';
import 'package:epoQatapp/games/idea_generator/bloc/idea_generator_event.dart';
import 'package:epoQatapp/games/idea_generator/bloc/idea_generator_state.dart';
import 'package:epoQatapp/games/idea_generator/repositories/idea_generator_repository.dart';
import 'package:epoQatapp/games/idea_generator/settings/idea_generator_settings_page.dart';
import 'package:epoQatapp/games/idea_generator/view_components/category_selector.dart';
import 'package:epoQatapp/games/idea_generator/view_components/selected_elements_list.dart';
import 'package:epoQatapp/games/idea_generator/view_components/generate_button.dart';

@immutable
class IdeaGeneratorPage extends StatelessWidget {
  const IdeaGeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<IdeaGeneratorBloc>();
    if (bloc.state == const IdeaGeneratorState.initial()) {
      bloc.add(const IdeaGeneratorEvent.loadCategories());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Generatore di Idee Creative'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => IdeaGeneratorSettingsPage(
                    repository: context.read<IdeaGeneratorRepository>(),
                  ),
                ),
              ).then((_) {
                context.read<IdeaGeneratorBloc>().add(
                  const IdeaGeneratorEvent.loadCategories(),
                );
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<IdeaGeneratorBloc, IdeaGeneratorState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            orElse: () => const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CategorySelector(),
                  SizedBox(height: 24),
                  Expanded(child: SelectedElementsList()),
                  GenerateButton(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
