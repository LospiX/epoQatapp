import 'package:flutter/material.dart';
import 'emotion_wheel_painter.dart';

class EmotionLevelSelector extends StatelessWidget {
  final EmotionLevel value;
  final ValueChanged<EmotionLevel> onChanged;

  const EmotionLevelSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SegmentedButton<EmotionLevel>(
        segments: const [
          ButtonSegment(
            value: EmotionLevel.base,
            label: Text('Base'),
            tooltip: 'Emozioni di base',
          ),
          ButtonSegment(
            value: EmotionLevel.middle,
            label: Text('Medio'),
            tooltip: 'Emozioni intermedie',
          ),
          ButtonSegment(
            value: EmotionLevel.deep,
            label: Text('Profondo'),
            tooltip: 'Emozioni profonde',
          ),
        ],
        selected: {value},
        onSelectionChanged: (Set<EmotionLevel> newSelection) {
          onChanged(newSelection.first);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return Theme.of(context).colorScheme.primaryContainer;
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}
