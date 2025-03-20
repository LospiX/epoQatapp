import 'dart:math';
import 'package:flutter/material.dart';
import 'view_components/emotion_wheel_painter.dart';
import 'view_components/emotion_level_selector.dart';


class EmotionWheelGame extends StatefulWidget {
  const EmotionWheelGame({super.key});

  @override
  State<EmotionWheelGame> createState() => _EmotionWheelGameState();
}

class _EmotionWheelGameState extends State<EmotionWheelGame> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _spinningAnimationController;
  late AnimationController _highlightController;
  double _currentRotation = 0.0;
  bool _showEmojis = true;
  EmotionLevel _currentLevel = EmotionLevel.base;
  String? _selectedEmotion;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _spinningAnimationController = CurvedAnimation(
      parent: _controller,
      curve: Curves.decelerate,
    );
    _highlightController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    
    _controller.addStatusListener(_onAnimationStatus);
  }

  void _onAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _updateSelectedEmotion();
    }
  }

  void _updateSelectedEmotion() {
    print("spinning angle: $_currentRotation");
    print("spinning controller: ${_spinningAnimationController.value}");
    List<EmotionData> emotions = switch (_currentLevel) {
      EmotionLevel.base => EmotionWheelPainter.baseEmotions,
      EmotionLevel.middle => EmotionWheelPainter.middleEmotions,
      EmotionLevel.deep => EmotionWheelPainter.deepEmotions
    };

    final angle = _currentRotation;
    final segmentAngle = 2.0 * pi / emotions.length;
    final pointerOffset = segmentAngle; 
    
    

    // final segmentAngle = 2 * pi / emotions.length;
    final index = (angle / segmentAngle).floor();
    print("segment angle: $segmentAngle");
    print("index: $index");
    // print("index: $index");
    setState(() {
      _selectedEmotion = emotions[index].text;
      _selectedIndex = index;
      // _selectedIndex = index;
    });
  }

  void _spinWheel() {
    final random = Random().nextDouble() * 2 * pi;
    _controller
      ..reset()
      ..forward(from: 0.0);
    setState(() {
      _currentRotation = random;
      _selectedEmotion = null;
      _selectedIndex = null;
    });
  }

  Widget _buildWheel() {
    return AnimatedBuilder(
      animation: _spinningAnimationController,
      builder: (context, child) {
        return Transform.rotate(
          angle: (_currentRotation + 2 * pi ) *  _spinningAnimationController.value,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[300]!, width: 2),
            ),
            child: AnimatedBuilder(
              animation: _highlightController,
              builder: (context, _) {
                return CustomPaint(
                  painter: EmotionWheelPainter(
                    showEmojis: _showEmojis,
                    level: _currentLevel,
                    selectedIndex: _selectedIndex,
                    animationValue: _highlightController.value,
                    pointerAngle: 90,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildPointer() {
    return const Icon(
      Icons.arrow_left,
      size: 80,
      color: Colors.red,
      shadows: [
        Shadow(
          color: Colors.black45,
          blurRadius: 4,
          offset: Offset(2, 2),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ruota delle Emozioni'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text('Emoji'),
                Switch(
                  value: !_showEmojis,
                  onChanged: (value) => setState(() => _showEmojis = !value),
                ),
                const Text('Testo'),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          SizedBox(
            width: 500,

            child: EmotionLevelSelector(
              value: _currentLevel,
              onChanged: (level) => setState(() => _currentLevel = level),
            ),
          ),
          if (_selectedEmotion != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  _selectedEmotion!,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _buildWheel(),
                  Positioned(
                    right: 10,
                    child: Transform.translate(
                      offset: const Offset(45, 0),
                      child: _buildPointer(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _spinWheel,
        tooltip: 'Gira la ruota',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_onAnimationStatus);
    _controller.dispose();
    _highlightController.dispose();
    super.dispose();
  }
}
