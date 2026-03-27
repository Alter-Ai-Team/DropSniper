import 'package:flutter/material.dart';

import '../core/theme.dart';

class BudgetRing extends StatelessWidget {
  const BudgetRing({
    super.key,
    required this.total,
    required this.budget,
  });

  final double total;
  final double budget;

  @override
  Widget build(BuildContext context) {
    final ratio = budget == 0 ? 1.0 : (total / budget).clamp(0.0, 1.0);
    final under = total <= budget;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 72,
          height: 72,
          child: CircularProgressIndicator(
            value: ratio,
            strokeWidth: 8,
            color: under ? AppColors.neonGreen : AppColors.crimson,
            backgroundColor: Colors.white10,
          ),
        ),
        Text('${(ratio * 100).toStringAsFixed(0)}%'),
      ],
    );
  }
}
