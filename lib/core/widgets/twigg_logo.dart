import 'package:flutter/material.dart';

class TwiggLogo extends StatelessWidget {
  final double imageSize;
  final double fontSize;
  final double spacing;
  final Color textColor;

  const TwiggLogo({
    super.key,
    this.imageSize = 32,
    this.fontSize = 16,
    this.spacing = 12,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/twigg_logo_circles.png',
          width: imageSize,
          height: imageSize,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Fallback to a gold circle if image fails to load
            return Container(
              width: imageSize,
              height: imageSize,
              decoration: const BoxDecoration(
                color: Color(0xFFD4AF37),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.circle,
                size: imageSize * 0.6,
                color: Colors.black.withOpacity(0.5),
              ),
            );
          },
        ),
        SizedBox(width: spacing),
        Text(
          'TWIGG',
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
