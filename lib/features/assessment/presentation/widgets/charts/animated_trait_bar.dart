import 'package:flutter/material.dart';

class AnimatedTraitBar extends StatelessWidget {
  final String label;
  final double value; // 0.0 to 1.0
  final int durationMs;

  const AnimatedTraitBar({
    super.key,
    required this.label,
    required this.value,
    this.durationMs = 1000,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label.toUpperCase(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "${(value * 100).toInt()}%",
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 6,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(3),
          ),
          child: TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: durationMs),
            curve: Curves.easeOutQuart,
            tween: Tween<double>(begin: 0, end: value),
            builder: (context, animatedValue, _) {
              return FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: animatedValue,
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.5),
                        blurRadius: 6,
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
