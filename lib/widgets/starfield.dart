import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class Star {
  final double x; // 0.0 to 1.0
  final double y; // 0.0 to 1.0
  final double size; // star radius
  final Color color;
  final double phase; // random value for twinkle offset
  final double twinkleSpeed;

  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.phase,
    required this.twinkleSpeed,
  });
}

class Comet {
  final double startX; // 0.0 to 0.7
  final double startY; // 0.0 to 0.5
  final double angle; // angle in radians
  final double length; // streak length in px
  final double speed; // progress speed multiplier
  final double size; // thickness of comet
  double progress = 0.0; // 0.0 to 1.0

  Comet({
    required this.startX,
    required this.startY,
    required this.angle,
    required this.length,
    required this.speed,
    required this.size,
  });
}

class Starfield extends StatefulWidget {
  final Animation<double> animation;
  const Starfield({super.key, required this.animation});

  @override
  State<Starfield> createState() => _StarfieldState();
}

class _StarfieldState extends State<Starfield> {
  late final List<Star> _stars;
  final List<Comet> _activeComets = [];
  double _lastAnimationValue = 0.0;

  @override
  void initState() {
    super.initState();
    // Use a fixed random seed so that stars are deterministic and consistent
    final random = math.Random(42);
    final colors = [
      AppTheme.primaryColor, // Bright Gold
      const Color(0xFFFFF7D6), // Champagne Gold
      const Color(0xFFFFFFFF), // White
      const Color(0xFFF8FAFC), // Off-White
      const Color(0xFFC5A059), // Antique Gold
    ];

    _stars = List.generate(120, (index) {
      return Star(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 2.5 + 1.2, // radius between 1.2 and 3.7
        color: colors[random.nextInt(colors.length)],
        phase: random.nextDouble() * math.pi * 2,
        twinkleSpeed: random.nextDouble() * 1.2 + 0.4,
      );
    });

    widget.animation.addListener(_onAnimationTick);
    _lastAnimationValue = widget.animation.value;
  }

  @override
  void dispose() {
    widget.animation.removeListener(_onAnimationTick);
    super.dispose();
  }

  void _onAnimationTick() {
    if (!mounted) return;

    final double currentValue = widget.animation.value;
    double delta = (currentValue - _lastAnimationValue).abs();

    // Handle wrap around when animation loop repeats
    if (delta > 0.5) {
      delta = 1.0 - delta;
    }
    _lastAnimationValue = currentValue;

    setState(() {
      // Update active comets progress
      for (int i = _activeComets.length - 1; i >= 0; i--) {
        final comet = _activeComets[i];
        comet.progress += delta * comet.speed * 1.8;
        if (comet.progress >= 1.0) {
          _activeComets.removeAt(i);
        }
      }

      // Spawn a new comet with a low probability
      final random = math.Random();
      if (_activeComets.length < 2 && random.nextDouble() < 0.015) {
        _spawnComet(random);
      }
    });
  }

  void _spawnComet(math.Random random) {
    // Starts in the upper-left quadrants
    final double sx = random.nextDouble() * 0.7;
    final double sy = random.nextDouble() * 0.5;

    // Diagonal direction (either down-right or down-left)
    final bool travelRight = random.nextBool();
    final double baseAngle = travelRight ? (math.pi / 6) : (math.pi * 5 / 6);
    final double angleOffset = (random.nextDouble() - 0.5) * (math.pi / 6); // +/- 15 degrees
    final double angle = baseAngle + angleOffset;

    _activeComets.add(Comet(
      startX: sx,
      startY: sy,
      angle: angle,
      length: random.nextDouble() * 100.0 + 80.0, // length between 80 and 180 pixels
      speed: random.nextDouble() * 1.2 + 0.8,
      size: random.nextDouble() * 2.0 + 1.5,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: StarfieldPainter(
        stars: _stars,
        comets: _activeComets,
        animationValue: widget.animation.value,
      ),
    );
  }
}

class StarfieldPainter extends CustomPainter {
  final List<Star> stars;
  final List<Comet> comets;
  final double animationValue;

  StarfieldPainter({
    required this.stars,
    required this.comets,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final paint = Paint()..style = PaintingStyle.fill;

    // 1. Draw drifting & twinkling stars
    for (final star in stars) {
      // Calculate opacity based on a sine wave that twinkles.
      final double angle = star.phase + animationValue * math.pi * 2 * star.twinkleSpeed;
      final double twinkle = (math.sin(angle) + 1.0) / 2.0; // 0.0 to 1.0

      // Minimum opacity of 0.35, maximum of 1.0 for better visibility
      final double opacity = 0.35 + (twinkle * 0.65);
      paint.color = star.color.withValues(alpha: opacity);

      // Parallax-like slow movement effects:
      // Base horizontal drift (breeze effect)
      final double wind = animationValue * 12.0;

      // Minor individual orbital drift (shimmer sway)
      final double driftRadius = star.size * 2.0;
      final double driftAngle = star.phase + animationValue * math.pi * 2 * star.twinkleSpeed * 0.1;

      // Wrap around using modulo so stars stay on canvas bounds cleanly
      final double px = (star.x * size.width + wind + math.cos(driftAngle) * driftRadius) % size.width;
      final double py = (star.y * size.height + math.sin(driftAngle) * driftRadius) % size.height;

      // Draw the star spot
      canvas.drawCircle(Offset(px, py), star.size, paint);

      // Add a subtle outer glow for larger/brighter stars to make it look premium
      if (star.size > 2.0 && twinkle > 0.5) {
        final glowPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = star.color.withValues(alpha: (twinkle - 0.5) * 0.4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
        canvas.drawCircle(Offset(px, py), star.size * 2.8, glowPaint);
      }

      // For a few select stars, draw a premium 4-point star flare
      if (star.size > 2.0 && twinkle > 0.5) {
        final flarePaint = Paint()
          ..color = star.color.withValues(alpha: (twinkle - 0.5) * 0.4)
          ..strokeWidth = 0.5
          ..style = PaintingStyle.stroke;

        final double flareLength = star.size * 3.5;

        canvas.drawLine(
          Offset(px - flareLength, py),
          Offset(px + flareLength, py),
          flarePaint,
        );
        canvas.drawLine(
          Offset(px, py - flareLength),
          Offset(px, py + flareLength),
          flarePaint,
        );
      }
    }

    // 2. Draw active comets (shooting stars)
    for (final comet in comets) {
      final double totalTravelDistance = size.width > size.height ? size.width * 0.6 : size.height * 0.6;
      final double travel = comet.progress * totalTravelDistance;

      final double hx = comet.startX * size.width + math.cos(comet.angle) * travel;
      final double hy = comet.startY * size.height + math.sin(comet.angle) * travel;

      final double tx = hx - math.cos(comet.angle) * comet.length;
      final double ty = hy - math.sin(comet.angle) * comet.length;

      // Fade in at start, fade out at end
      double cometOpacity = 1.0;
      if (comet.progress < 0.2) {
        cometOpacity = comet.progress / 0.2;
      } else if (comet.progress > 0.7) {
        cometOpacity = (1.0 - comet.progress) / 0.3;
      }
      cometOpacity = cometOpacity.clamp(0.0, 1.0);

      // Tail trail with linear gradient fading out
      final Paint cometPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = comet.size
        ..strokeCap = StrokeCap.round;

      cometPaint.shader = ui.Gradient.linear(
        Offset(hx, hy),
        Offset(tx, ty),
        [
          const Color(0xFFFFF7D6).withValues(alpha: cometOpacity),
          const Color(0xFFD4AF37).withValues(alpha: cometOpacity * 0.45),
          const Color(0xFFD4AF37).withValues(alpha: 0.0),
        ],
        [0.0, 0.3, 1.0],
      );

      canvas.drawLine(Offset(hx, hy), Offset(tx, ty), cometPaint);

      // Glowing head dot
      final Paint headPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.white.withValues(alpha: cometOpacity);
      canvas.drawCircle(Offset(hx, hy), comet.size * 1.3, headPaint);

      // Subtle atmospheric halo around the head
      final Paint headGlowPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = const Color(0xFFFFF7D6).withValues(alpha: cometOpacity * 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
      canvas.drawCircle(Offset(hx, hy), comet.size * 3.5, headGlowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant StarfieldPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        comets.isNotEmpty ||
        oldDelegate.comets.isNotEmpty;
  }
}
