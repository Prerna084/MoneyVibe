import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'dart:math' as math;

class HolographicCard extends StatefulWidget {
  final String personaName;
  final String insight;
  final String serialNumber;
  final Color powerColor;
  final Color secondaryColor;

  const HolographicCard({
    super.key,
    required this.personaName,
    required this.insight,
    required this.serialNumber,
    required this.powerColor,
    required this.secondaryColor,
  });

  @override
  State<HolographicCard> createState() => _HolographicCardState();
}

class _HolographicCardState extends State<HolographicCard>
    with SingleTickerProviderStateMixin {
  // Mouse tracking
  Offset _mousePosition = const Offset(0.5, 0.5); // Normalized 0-1
  
  // Gyroscope tracking
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  double _gyroX = 0.0;
  double _gyroY = 0.0;
  
  // Glint animation
  late AnimationController _glintController;
  
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    
    // Glint animation
    _glintController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    // Start gyroscope listening for mobile
    _startGyroscope();
  }

  void _startGyroscope() {
    _gyroscopeSubscription = gyroscopeEventStream().listen((event) {
      if (mounted) {
        setState(() {
          // Accumulate rotation with damping
          _gyroX = (_gyroX + event.y * 0.5).clamp(-1.0, 1.0);
          _gyroY = (_gyroY + event.x * 0.5).clamp(-1.0, 1.0);
        });
      }
    });
  }

  @override
  void dispose() {
    _glintController.dispose();
    _gyroscopeSubscription?.cancel();
    super.dispose();
  }

  void _onPointerMove(PointerEvent details, BoxConstraints constraints) {
    setState(() {
      _mousePosition = Offset(
        (details.localPosition.dx / constraints.maxWidth).clamp(0.0, 1.0),
        (details.localPosition.dy / constraints.maxHeight).clamp(0.0, 1.0),
      );
    });
  }

  void _onPointerExit(PointerEvent details) {
    setState(() {
      _isHovering = false;
      _mousePosition = const Offset(0.5, 0.5);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate tilt based on mouse (desktop) or gyroscope (mobile)
    final xOffset = _isHovering ? (_mousePosition.dx - 0.5) * 2 : _gyroY;
    final yOffset = _isHovering ? (_mousePosition.dy - 0.5) * 2 : _gyroX;

    final rotateY = xOffset * 18; // Max 18deg horizontal
    final rotateX = -yOffset * 18; // Max 18deg vertical (inverted)

    return LayoutBuilder(
      builder: (context, constraints) {
        return MouseRegion(
          onEnter: (_) => setState(() => _isHovering = true),
          onExit: _onPointerExit,
          child: Listener(
            onPointerMove: (event) => _onPointerMove(event, constraints),
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
              tween: Tween(begin: 0, end: _isHovering ? 1.0 : 0.0),
              builder: (context, hoverProgress, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001) // perspective
                    ..rotateX(rotateX * math.pi / 180)
                    ..rotateY(rotateY * math.pi / 180)
                    ..scale(1.0 + (hoverProgress * 0.06))
                    ..translate(0.0, 0.0, hoverProgress * 40),
                  child: child,
                );
              },
              child: Container(
                width: constraints.maxWidth,
                height: 300,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.05),
                      Colors.white.withOpacity(0.01),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.8),
                      blurRadius: 100,
                      offset: const Offset(0, 40),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      // Texture overlay
                      Positioned.fill(
                        child: Opacity(
                          opacity: 0.1,
                          child: Image.network(
                            'https://www.transparenttextures.com/patterns/carbon-fibre.png',
                            repeat: ImageRepeat.repeat,
                            color: Colors.white,
                            colorBlendMode: BlendMode.overlay,
                          ),
                        ),
                      ),

                      // Radial glow following mouse/gyro
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: Alignment(
                                _mousePosition.dx * 2 - 1,
                                _mousePosition.dy * 2 - 1,
                              ),
                              radius: 0.6,
                              colors: [
                                widget.powerColor.withOpacity(0.15),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Glare effect
                      AnimatedBuilder(
                        animation: _glintController,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: 20 * math.pi / 180,
                            child: Transform.translate(
                              offset: Offset(
                                (_mousePosition.dx - 0.5) * constraints.maxWidth,
                                0,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Colors.transparent,
                                      Colors.white.withOpacity(0.05),
                                      Colors.white.withOpacity(0.1),
                                      Colors.white.withOpacity(0.05),
                                      Colors.transparent,
                                    ],
                                    stops: const [0.4, 0.45, 0.5, 0.55, 0.6],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      // Card content
                      Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Top bar
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'CERTIFIED PRESTIGE',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 2.5,
                                    color: widget.powerColor,
                                  ),
                                ),
                                Icon(
                                  Icons.auto_awesome,
                                  color: widget.powerColor,
                                  size: 20,
                                ),
                              ],
                            ),

                            // Insight text
                            Expanded(
                              child: Center(
                                child: Text(
                                  widget.insight,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    height: 1.5,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),

                            // Bottom bar
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ACCESS KEY',
                                      style: TextStyle(
                                        fontSize: 9,
                                        letterSpacing: 1.5,
                                        color: Colors.white.withOpacity(0.5),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.serialNumber,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'Courier',
                                        color: Colors.white.withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                                // Certified seal placeholder (will create separate widget)
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: widget.powerColor.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'MV',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                        color: widget.powerColor,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
