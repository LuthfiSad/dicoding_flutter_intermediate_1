import 'dart:math' as math;
import 'package:flutter/material.dart';

class FunkyBouncyLoader extends CustomPainter {
  final double progress;
  final List<Color> dotColors;

  FunkyBouncyLoader({
    required this.progress,
    this.dotColors = const [
      Colors.blueAccent,
      Colors.purpleAccent,
      Colors.pinkAccent,
    ],
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final dotCount = dotColors.length;
    final radius = size.width / 6;
    final dotRadius = size.width / 12;

    // Background circle (optional)
    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 1.2, bgPaint);

    // Animated dots with bounce effect
    for (int i = 0; i < dotCount; i++) {
      final angle = 2 * math.pi * i / dotCount + progress * 2 * math.pi;
      final bounceHeight = math.sin(progress * 4 * math.pi + i) * 15;
      
      final dotPos = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle) - bounceHeight,
      );

      // Magic trail effect
      final trailPaint = Paint()
        ..color = dotColors[i].withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      
      for (int j = 1; j <= 3; j++) {
        final trailProgress = progress - j * 0.05;
        if (trailProgress >= 0) {
          final trailAngle = 2 * math.pi * i / dotCount + trailProgress * 2 * math.pi;
          final trailBounce = math.sin(trailProgress * 4 * math.pi + i) * 15;
          
          final trailPos = Offset(
            center.dx + radius * math.cos(trailAngle),
            center.dy + radius * math.sin(trailAngle) - trailBounce,
          );
          
          canvas.drawCircle(trailPos, dotRadius * 0.8, trailPaint);
        }
      }

      // Main dot
      final dotPaint = Paint()
        ..color = dotColors[i]
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
      
      canvas.drawCircle(dotPos, dotRadius, dotPaint);

      // Inner glow
      final innerPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(dotPos, dotRadius * 0.5, innerPaint);
    }

    // Optional: Central text (uncomment if needed)
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'Loading...',
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, center - Offset(textPainter.width / 2, -40));
  }

  @override
  bool shouldRepaint(covariant FunkyBouncyLoader oldDelegate) {
    return progress != oldDelegate.progress || dotColors != oldDelegate.dotColors;
  }
}