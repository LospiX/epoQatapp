import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:epoQatapp/core/database/database_helper.dart';
import 'package:epoQatapp/core/theme/app_theme.dart';
import 'package:epoQatapp/core/theme/theme_provider.dart';
import 'package:epoQatapp/data/games_data.dart';
import 'package:epoQatapp/games/idea_generator/repositories/idea_generator_repository.dart';
import 'package:epoQatapp/models/game.dart';
import 'package:epoQatapp/games/idea_generator/idea_generator_page.dart';
import 'package:epoQatapp/games/idea_generator/bloc/idea_generator_bloc.dart';
import 'package:epoQatapp/games/sequences/repositories/sequence_repository.dart';
import 'package:epoQatapp/games/sequences/sequences_list_page.dart';
import 'package:epoQatapp/settings/settings_page.dart';
import 'games/emotion_wheel.dart';

// Import for Windows/Linux/macOS
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  // Ensure Flutter is initialized before using platform channels
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize FFI for desktop platforms only
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    // Set the database factory for desktop
    databaseFactory = databaseFactoryFfi;
  }
  
  // Initialize the database
  await DatabaseHelper.instance.database;
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create the repository instance once
    final ideaGeneratorRepository = IdeaGeneratorRepository();
    final sequenceRepository = SequenceRepository();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: ideaGeneratorRepository),
        RepositoryProvider.value(value: sequenceRepository),
      ],
      child: ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) => MultiBlocProvider(
            providers: [
              BlocProvider<IdeaGeneratorBloc>(
                create: (context) => IdeaGeneratorBloc(repository: ideaGeneratorRepository),
              ),
            ],
            child: MaterialApp(
              title: 'epoQatapp',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeProvider.themeMode,
              routes: {
                '/emotion-wheel': (context) => const EmotionWheelGame(),
                '/idea-generator': (context) => const IdeaGeneratorPage(),
                '/sequences': (context) => const SequencesListPage(),
                '/settings': (context) => const SettingsPage(),
              },
              home: HomeScreen(),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
   HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Image(image: AssetImage('assets/icon/icon.png'), width: 36, height: 36),
            const SizedBox(width: 8),
            const Text('epoQatapp', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),),
          ],
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.background,
              theme.colorScheme.background.withOpacity(0.8),
            ],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: games.length,
          itemBuilder: (context, index) => GameCard(game: games[index])
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/settings');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Image(image: AssetImage('assets/icon/icon.png'), width: 24, height: 24),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final Game game;
  final VoidCallback? onTap;

  const GameCard({super.key, required this.game, this.onTap});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap ??
            () {
              if (game.routeName.isNotEmpty) {
                Navigator.pushNamed(context, game.routeName);
              }
            },
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        // borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        game.icon ?? Icons.extension,
                        size: 55,
                        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.7),
                      ),
                    ),
                    // Positioned(
                    //   bottom: 7,
                    //   right: 7,
                    //   child: Container(
                    //     padding: const EdgeInsets.all(4),
                    //     decoration: BoxDecoration(
                    //       color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.7),
                    //       borderRadius: const BorderRadius.only(
                    //         topLeft: Radius.circular(12),
                    //         bottomRight: Radius.circular(12),
                    //       ),
                    //     ),
                    //     child: Icon(
                    //       game.icon ?? Icons.extension,
                    //       color: Theme.of(context).colorScheme.onSecondary,
                    //       size: 45,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        game.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        game.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
