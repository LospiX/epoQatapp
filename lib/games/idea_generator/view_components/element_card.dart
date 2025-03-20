import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:epoQatapp/games/idea_generator/bloc/idea_generator_bloc.dart';
import 'package:epoQatapp/games/idea_generator/bloc/idea_generator_event.dart';
import 'package:epoQatapp/games/idea_generator/models/game_element.dart';

class GameElementCard extends HookWidget {
  const GameElementCard({
    required this.elementType,
    required this.onPressed,
    super.key,
  });

  final String elementType;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                elementType,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              const Icon(Icons.add_circle_outline),
            ],
          ),
        ),
      ),
    );
  }
}

class ElementCard extends StatelessWidget {
  final ElementType type;
  final VoidCallback onPressed;

  const ElementCard({
    super.key,
    required this.type,
    required this.onPressed,
  });

   @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: SizedBox(
          width: 120,
          height: 140, // Add fixed height constraint
          child: Card(
            elevation: 4,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: type.color, width: 2),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onPressed,
              splashColor: type.color.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16, // Adjust vertical padding
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Prevent column expansion
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10), // Reduce padding
                      decoration: BoxDecoration(
                        color: type.color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        type.icon,
                        color: type.color,
                        size: 28, // Slightly reduce icon size
                      ),
                    ),
                    const SizedBox(height: 10),
                    Flexible( // Add Flexible to text container
                      child: Text(
                        type.displayName,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: type.color,
                          fontWeight: FontWeight.w700,
                          fontSize: 13, // Reduce font size slightly
                          height: 1.2, // Adjust line height
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}