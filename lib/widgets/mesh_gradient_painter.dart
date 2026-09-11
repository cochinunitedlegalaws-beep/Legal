import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// Elegant Animated Mesh Gradient Background Painter
class MeshGradientPainter extends CustomPainter {
  final double animationValue;

  MeshGradientPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final rect = Offset.zero & size;

    // Base background color
    paint.color = AppTheme.backgroundColor;
    canvas.drawRect(rect, paint);

    // Create moving glowing orbs using radial gradients (extremely subtle premium look)
    _drawOrb(canvas, size, 
      offset: Offset(size.width * (0.3 + 0.3 * math.sin(animationValue * math.pi * 2)), size.height * (0.3 + 0.3 * math.cos(animationValue * math.pi * 2))), 
      color: AppTheme.accentColor.withValues(alpha: 0.03),
      radius: size.width * 0.8,
    );

    _drawOrb(canvas, size, 
      offset: Offset(size.width * (0.7 + 0.3 * math.cos(animationValue * math.pi * 2)), size.height * (0.7 + 0.3 * math.sin(animationValue * math.pi * 2))), 
      color: AppTheme.accentColor.withValues(alpha: 0.02),
      radius: size.width * 0.9,
    );
    
    _drawOrb(canvas, size, 
      offset: Offset(size.width * (0.5 + 0.4 * math.sin(animationValue * math.pi)), size.height * (0.5 + 0.4 * math.cos(animationValue * math.pi))), 
      color: AppTheme.highlightColor.withValues(alpha: 0.015),
      radius: size.width * 0.7,
    );
  }

  void _drawOrb(Canvas canvas, Size size, {required Offset offset, required Color color, required double radius}) {
    final paint = Paint()
      ..shader = ui.Gradient.radial(
        offset,
        radius,
        [color, color.withValues(alpha: 0)],
        [0.0, 1.0],
      );
    canvas.drawCircle(offset, radius, paint);
  }

  @override
  bool shouldRepaint(covariant MeshGradientPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
