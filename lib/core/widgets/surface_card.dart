import 'package:flutter/material.dart';

class SurfaceCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final double? width; // Added width support as it was used in GlassContainer
  final double? height; // Added height support as it was used in GlassContainer

  const SurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(32),
    this.radius = 20,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFF161616), // calm dark surface
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}
