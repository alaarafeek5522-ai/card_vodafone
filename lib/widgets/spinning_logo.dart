import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class SpinningLogo extends StatefulWidget {
  final double size;
  const SpinningLogo({super.key, this.size = 160});

  @override
  State<SpinningLogo> createState() => _SpinningLogoState();
}

class _SpinningLogoState extends State<SpinningLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.red.withOpacity(0.3),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
              // Spinning ring
              AnimatedBuilder(
                animation: _ctrl,
                builder: (_, __) {
                  return Transform.rotate(
                    angle: _ctrl.value * 2 * pi,
                    child: CustomPaint(
                      size: Size(widget.size, widget.size),
                      painter: _RingPainter(),
                    ),
                  );
                },
              ),
              // Center circle
              Container(
                width: widget.size * 0.68,
                height: widget.size * 0.68,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppTheme.redLight, AppTheme.redDark],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.red.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Team\nMaro',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontSize: widget.size * 0.155,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'By developer Alaa',
          style: GoogleFonts.dancingScript(
            color: AppTheme.grey,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

class _RingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    // Dashed ring
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..shader = SweepGradient(
        colors: [
          AppTheme.red,
          AppTheme.redLight,
          AppTheme.redDark,
          AppTheme.red.withOpacity(0.2),
          AppTheme.red,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    // Dots around ring
    const dotCount = 12;
    final dotPaint = Paint()..color = AppTheme.redLight;
    for (int i = 0; i < dotCount; i++) {
      final angle = (i / dotCount) * 2 * pi;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      canvas.drawCircle(Offset(x, y), i % 3 == 0 ? 4 : 2.5, dotPaint);
    }

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_) => true;
}
