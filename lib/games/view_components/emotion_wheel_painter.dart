import 'dart:math';
import 'package:flutter/material.dart';

enum EmotionLevel {
  base,
  middle,
  deep
}

enum EmotionColor {
  happiness(Color(0xFF90EE90)),
  sadness(Color(0xFF87CEEB)),
  anger(Color(0xFF4169E1)),
  disgust(Color(0xFFFF6B6B)),
  fear(Color.fromARGB(255, 148, 67, 148)),
  surprise(Color.fromARGB(255, 251, 148, 255));

  final Color value;
  const EmotionColor(this.value);
}

class EmotionData {
  final String text;
  final String emoji;
  final EmotionColor color;

  const EmotionData({
    required this.text,
    required this.emoji,
    required this.color,
  });
}

class EmotionWheelPainter extends CustomPainter {
  final bool showEmojis;
  final EmotionLevel level;
  final double pointerAngle;
  final int? selectedIndex;
  final double animationValue;
  // Base emotions
  static const List<EmotionData> baseEmotions = [
    EmotionData(text: 'felicità', emoji: '😊', color: EmotionColor.happiness),
    EmotionData(text: 'tristezza', emoji: '😢', color: EmotionColor.sadness),
    EmotionData(text: 'rabbia', emoji: '😠', color: EmotionColor.anger),
    EmotionData(text: 'disgusto', emoji: '🤢', color: EmotionColor.disgust),
    EmotionData(text: 'paura', emoji: '😨', color: EmotionColor.fear),
    EmotionData(text: 'sorpresa', emoji: '😲', color: EmotionColor.surprise),
  ];

  // Middle emotions from image
  static const List<EmotionData> middleEmotions = [
    // Green section (felicità)
    EmotionData(text: 'ottimista', emoji: '😊', color: EmotionColor.happiness),
    EmotionData(text: 'ispirato', emoji: '🌟', color: EmotionColor.happiness),
    EmotionData(text: 'fiducioso', emoji: '🌈', color: EmotionColor.happiness),
    EmotionData(text: 'gioioso', emoji: '🎉', color: EmotionColor.happiness),
    // Blue section (tristezza)
    EmotionData(text: 'pensieroso', emoji: '🤔', color: EmotionColor.sadness),
    EmotionData(text: 'disconnesso', emoji: '💔', color: EmotionColor.sadness),
    EmotionData(text: 'solo', emoji: '😔', color: EmotionColor.sadness),
    // Royal blue section (rabbia)
    EmotionData(text: 'frustrato', emoji: '😤', color: EmotionColor.anger),
    EmotionData(text: 'irritato', emoji: '😠', color: EmotionColor.anger),
    EmotionData(text: 'distante', emoji: '🏃', color: EmotionColor.anger),
    // Red section (disgusto)
    EmotionData(text: 'critico', emoji: '🧐', color: EmotionColor.disgust),
    EmotionData(text: 'scettico', emoji: '🤨', color: EmotionColor.disgust),
    EmotionData(text: 'disapprovazione', emoji: '👎', color: EmotionColor.disgust),
    // Purple section (paura)
    EmotionData(text: 'preoccupato', emoji: '😟', color: EmotionColor.fear),
    EmotionData(text: 'confuso', emoji: '😕', color: EmotionColor.fear),
    EmotionData(text: 'insicuro', emoji: '😰', color: EmotionColor.fear),
    // Orange section (sorpresa)
    EmotionData(text: 'eccitato', emoji: '🤩', color: EmotionColor.surprise),
    EmotionData(text: 'energico', emoji: '⚡', color: EmotionColor.surprise),
    EmotionData(text: 'meravigliato', emoji: '😲', color: EmotionColor.surprise),
  ];

  // Deep emotions from image
  static const List<EmotionData> deepEmotions = [
    // Green section
    EmotionData(text: 'realizzato', emoji: '🌟', color: EmotionColor.happiness),
    EmotionData(text: 'grato', emoji: '🙏', color: EmotionColor.happiness),
    EmotionData(text: 'orgoglioso', emoji: '🦁', color: EmotionColor.happiness),
    EmotionData(text: 'coraggioso', emoji: '💪', color: EmotionColor.happiness),
    // Blue section
    EmotionData(text: 'abbandonato', emoji: '💔', color: EmotionColor.sadness),
    EmotionData(text: 'disperato', emoji: '😢', color: EmotionColor.sadness),
    EmotionData(text: 'depresso', emoji: '😞', color: EmotionColor.sadness),
    // Royal blue section
    EmotionData(text: 'furioso', emoji: '😡', color: EmotionColor.anger),
    EmotionData(text: 'violento', emoji: '💥', color: EmotionColor.anger),
    EmotionData(text: 'ostile', emoji: '👊', color: EmotionColor.anger),
    // Red section
    EmotionData(text: 'detestabile', emoji: '🤮', color: EmotionColor.disgust),
    EmotionData(text: 'ripugnante', emoji: '🤢', color: EmotionColor.disgust),
    EmotionData(text: 'nauseato', emoji: '😫', color: EmotionColor.disgust),
    // Purple section
    EmotionData(text: 'terrorizzato', emoji: '😱', color: EmotionColor.fear),
    EmotionData(text: 'spaventato', emoji: '😨', color: EmotionColor.fear),
    EmotionData(text: 'ansioso', emoji: '😰', color: EmotionColor.fear),
    // Orange section
    EmotionData(text: 'sbalordito', emoji: '😲', color: EmotionColor.surprise),
    EmotionData(text: 'scioccato', emoji: '😱', color: EmotionColor.surprise),
    EmotionData(text: 'stupefatto', emoji: '😮', color: EmotionColor.surprise),
  ];

  EmotionWheelPainter({
    required this.showEmojis,
    required this.level,
    required this.pointerAngle,
    this.selectedIndex,
    required this.animationValue,
  });

  List<EmotionData> get currentEmotions {
    switch (level) {
      case EmotionLevel.base:
        return baseEmotions;
      case EmotionLevel.middle:
        return middleEmotions;
      case EmotionLevel.deep:
        return deepEmotions;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    final center = Offset(size.width/2, size.height/2);
    final radius = size.width/2;
    final emotions = currentEmotions;
    final angle = 2 * pi / emotions.length;

    // Draw segments and texts
    for (var i = 0; i < emotions.length; i++) {
      final startAngle = i * angle;
      final emotion = emotions[i];
      
      // Draw segment
      paint.color = emotion.color.value;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        angle,
        true,
        paint,
      );

      // Draw segment border
      paint
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        angle,
        true,
        paint,
      );
      paint.style = PaintingStyle.fill;

      // Draw text
      final textPainter = TextPainter(
        text: TextSpan(
          text: showEmojis ? emotion.emoji : emotion.text,
          style: TextStyle(
            fontSize: showEmojis ? 34 : level == EmotionLevel.base ? 20:  14,
            color: Colors.black,
            fontWeight: showEmojis ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      // Position and rotate text
      final textRadius = radius * 0.7;
      final textAngle = startAngle + (angle / 2);
      final textX = center.dx + (textRadius * cos(textAngle));
      final textY = center.dy + (textRadius * sin(textAngle));
      
      canvas.save();
      canvas.translate(textX, textY);
      canvas.rotate(textAngle);
      textPainter.paint(canvas, Offset(-textPainter.width/2, -textPainter.height/2));
      canvas.restore();
    }

    // Highlight selected segment
    if (selectedIndex != null) {
      final opacity = 0.3 * (1 + sin(animationValue * 2 * pi));
      final highlightPaint = Paint()
        ..color = Colors.yellow.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      final startAngle = selectedIndex! * angle;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        angle,
        true,
        highlightPaint,
      );
    }

    // Draw center circle
    paint
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.1, paint);

    // Pointer drawing removed
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
