import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../models/product_link.dart';

class PriceSparkline extends StatelessWidget {
  const PriceSparkline({super.key, required this.points});

  final List<PricePoint> points;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SparklinePainter(points),
      size: const Size(double.infinity, 40),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter(this.points);

  final List<PricePoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final minPrice = points.map((e) => e.price).reduce((a, b) => a < b ? a : b);
    final maxPrice = points.map((e) => e.price).reduce((a, b) => a > b ? a : b);
    final range = (maxPrice - minPrice) == 0 ? 1 : (maxPrice - minPrice);

    final paint = Paint()
      ..color = AppColors.accentBlue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = (i / (points.length - 1)) * size.width;
      final y = size.height - ((points[i].price - minPrice) / range * size.height);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) => oldDelegate.points != points;
}
