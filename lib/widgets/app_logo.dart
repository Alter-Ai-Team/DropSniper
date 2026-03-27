import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/theme.dart';

class DropSniperLogo extends StatelessWidget {
  const DropSniperLogo({super.key, this.size = 84});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _LogoPainter(),
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.09
      ..shader = const LinearGradient(
        colors: [AppColors.accentBlue, AppColors.neonGreen],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius * 0.86, ring);

    final pulse = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.neonGreen.withValues(alpha: 0.15);
    canvas.drawCircle(center, radius * 0.54, pulse);

    final crosshair = Paint()
      ..color = AppColors.accentBlue
      ..strokeWidth = size.width * 0.03;

    canvas.drawLine(Offset(center.dx, radius * 0.18), Offset(center.dx, radius * 1.82), crosshair);
    canvas.drawLine(Offset(radius * 0.18, center.dy), Offset(radius * 1.82, center.dy), crosshair);

    final dropPath = Path()
      ..moveTo(center.dx, size.height * 0.25)
      ..quadraticBezierTo(size.width * 0.78, size.height * 0.48, center.dx, size.height * 0.85)
      ..quadraticBezierTo(size.width * 0.22, size.height * 0.48, center.dx, size.height * 0.25)
      ..close();

    final dropPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFF7DFFEA), AppColors.accentBlue],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-math.pi / 18);
    canvas.translate(-center.dx, -center.dy);
    canvas.drawPath(dropPath, dropPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
