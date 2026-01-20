import 'package:flutter/material.dart';
import 'dart:math' as math;

class CertifiedSeal extends StatefulWidget {
  final Color color;
  final double size;

  const CertifiedSeal({
    super.key,
    required this.color,
    this.size = 70,
  });

  @override
  State<CertifiedSeal> createState() => _CertifiedSealState();
}

class _CertifiedSealState extends State<CertifiedSeal>
    with SingleTickerProviderStateMixin {
  late AnimationController _glintController;

  @override
  void initState() {
    super.initState();
    _glintController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _glintController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        children: [
          // Star badge background
          CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _StarBadgePainter(color: widget.color),
          ),
          
          // Glint animation
          AnimatedBuilder(
            animation: _glintController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  math.sin(_glintController.value * 2 * math.pi) * widget.size * 0.5,
                  math.cos(_glintController.value * 2 * math.pi) * widget.size * 0.5,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withOpacity(0.3 * (1 - _glintController.value)),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Center text
          Center(
            child: Text(
              'MV',
              style: TextStyle(
                fontSize: widget.size * 0.23,
                fontWeight: FontWeight.w900,
                color: widget.color,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StarBadgePainter extends CustomPainter {
  final Color color;

  _StarBadgePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius * 0.5;
    final points = 12;

    final path = Path();
    for (int i = 0; i < points * 2; i++) {
      final angle = (i * math.pi / points) - math.pi / 2;
      final radius = i.isEven ? outerRadius : innerRadius;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);

    // Inner dashed circle
    final dashedPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final innerCircleRadius = size.width * 0.43;
    const dashWidth = 3.0;
    const dashSpace = 3.0;
    final circumference = 2 * math.pi * innerCircleRadius;
    final dashCount = (circumference / (dashWidth + dashSpace)).floor();

    for (int i = 0; i < dashCount; i++) {
      final startAngle = (i * (dashWidth + dashSpace) / innerCircleRadius);
      final sweepAngle = dashWidth / innerCircleRadius;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: innerCircleRadius),
        startAngle,
        sweepAngle,
        false,
        dashedPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
