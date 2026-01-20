import 'package:flutter/material.dart';

class AnimatedScaleButton extends StatefulWidget {
  final int value;
  final bool isSelected;
  final VoidCallback onTap;

  const AnimatedScaleButton({
    super.key,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<AnimatedScaleButton> createState() => _AnimatedScaleButtonState();
}

class _AnimatedScaleButtonState extends State<AnimatedScaleButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = widget.isSelected;
    final isHovered = _isHovered;
    final isActive = isSelected || isHovered;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: isActive ? 1.1 : 1.0,
          curve: Curves.easeOutCubic,
          duration: const Duration(milliseconds: 120), // Fast, responsive
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // Background: Gold if selected, slight white if hovered, distinct dark if idle
              color: isSelected 
                  ? theme.colorScheme.primary 
                  : (isHovered ? Colors.white.withOpacity(0.1) : Colors.transparent),
              
              // Border: Gold if active, subtle grey if idle
              border: Border.all(
                color: isActive 
                    ? theme.colorScheme.primary 
                    : Colors.white.withOpacity(0.2), 
                width: 1.5,
              ),
              
              // Glow only when selected
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.4),
                        blurRadius: 16,
                        spreadRadius: 1,
                      )
                    ]
                  : [],
            ),
            alignment: Alignment.center,
            child: Text(
              "${widget.value}",
              style: theme.textTheme.titleMedium?.copyWith(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
