import 'package:flutter/material.dart';
import 'package:glass_kit/glass_kit.dart' as gk;

class GlassContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;

  const GlassContainer({
    super.key,
    this.height,
    this.width,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return gk.GlassContainer.clearGlass(
      height: height ?? double.infinity,
      width: width ?? double.infinity,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius ?? BorderRadius.circular(20),
      blur: 12, // Reduced blur slightly for performance/clarity as requested
      borderWidth: 0.0, // NO BORDERS
      borderColor: Colors.transparent,
      gradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.06), // Very subtle
          Colors.white.withOpacity(0.03),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: child,
    );
  }
}
