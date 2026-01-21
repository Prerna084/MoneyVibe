import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;
import '../../../core/widgets/twigg_logo.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _orbitController;
  late AnimationController _spinController;
  late Animation<double> _fadeAnimation;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    
    _orbitController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    _spinController = AnimationController(
      duration: const Duration(seconds: 40),
      vsync: this,
    )..repeat();
    
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _orbitController.dispose();
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Stack(
        children: [
          const _BackgroundNetwork(),
          
          // Header Logo
          const SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: const TwiggLogo(),
            ),
          ),
          
          // Main Content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 1024;
                
                return Center(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                        maxWidth: 1400,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isDesktop ? 96 : 32,
                          vertical: 48,
                        ),
                        child: isDesktop
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: _buildLeftColumn(),
                                  ),
                                  const SizedBox(width: 128),
                                  Flexible(
                                    flex: 1,
                                    child: _buildRightColumn(),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  _buildLeftColumn(),
                                  const SizedBox(height: 64),
                                  _buildRightColumn(),
                                ],
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Footer Branding Bar
          _buildFooterBar(),
        ],
      ),
    );
  }

  Widget _buildLeftColumn() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Behavioral Engine Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37).withOpacity(0.05),
              border: Border.all(
                color: const Color(0xFFD4AF37).withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFD4AF37),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'BEHAVIORAL ENGINE V3.0',
                  style: TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3.6,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 48),
          
          // Main Heading
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 96,
                fontWeight: FontWeight.w700,
                height: 0.85,
                letterSpacing: -2,
              ),
              children: [
                const TextSpan(
                  text: 'Define your\n',
                  style: TextStyle(color: Color(0xFFE0E0E0)),
                ),
                WidgetSpan(
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFFD4AF37),
                        Color(0xFFF1D279),
                        Color(0xFFD4AF37),
                      ],
                    ).createShader(bounds),
                    child: const Text(
                      'wealth\nidentity',
                      style: TextStyle(
                        fontSize: 96,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 0.85,
                        letterSpacing: -2,
                      ),
                    ),
                  ),
                ),
                const TextSpan(
                  text: '.',
                  style: TextStyle(color: Color(0xFFD4AF37)),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 48),
          
          // Subtitle
          Text(
            'A scientific deep-dive into the subconscious patterns\ngoverning your financial future. No generic advice.\nOnly precise psychological insights.',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w300,
              color: const Color(0xFFE0E0E0).withOpacity(0.4),
              height: 1.6,
            ),
          ),
          
          const SizedBox(height: 56),
          
          // CTA Button and Security Badge
          Row(
            children: [
              MouseRegion(
                onEnter: (_) => setState(() => _isHovering = true),
                onExit: (_) => setState(() => _isHovering = false),
                child: GestureDetector(
                  onTap: () => context.go('/quiz'),
                  child: AnimatedScale(
                    scale: _isHovering ? 1.05 : 1.0,
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 56,
                        vertical: 24,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFD4AF37).withOpacity(0.3),
                            blurRadius: 24,
                          ),
                        ],
                      ),
                      child: const Text(
                        'UNLOCK IDENTITY',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3.3,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 40),
              Opacity(
                opacity: 0.3,
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 1,
                      color: const Color(0xFFE0E0E0),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'ENCRYPTED & ANONYMOUS',
                      style: TextStyle(
                        color: Color(0xFFE0E0E0),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRightColumn() {
    return SizedBox(
      height: 500,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Orbital paths
          _buildOrbitalPath(0, 0.03),
          _buildOrbitalPath(60, 0.05),
          _buildOrbitalPath(100, 0.03),
          
          // Outer orbit with nodes
          AnimatedBuilder(
            animation: _spinController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _spinController.value * 2 * math.pi,
                child: Container(
                  width: 500,
                  height: 500,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFD4AF37).withOpacity(0.1),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 250 - 4,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4AF37),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFD4AF37),
                                blurRadius: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 250 - 3,
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4AF37).withOpacity(0.4),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          // Orbital elements
          _buildOrbitalElement(Icons.shield_outlined, 0),
          _buildOrbitalElement(Icons.show_chart, 0.25),
          _buildOrbitalElement(Icons.settings, 0.5),
          _buildOrbitalElement(Icons.analytics_outlined, 0.75),
          
          // Segmented progress ring
          SizedBox(
            width: 340,
            height: 340,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(340, 340),
                  painter: _SegmentedRingPainter(),
                ),
                AnimatedBuilder(
                  animation: _spinController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: -_spinController.value * 2 * math.pi / 1.6,
                      child: Container(
                        width: 310,
                        height: 310,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFD4AF37).withOpacity(0.2),
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          
          // Hexagonal central hub
          _buildHexagonalHub(),
        ],
      ),
    );
  }

  Widget _buildOrbitalPath(double inset, double opacity) {
    return Container(
      width: 500 - (inset * 2),
      height: 500 - (inset * 2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(opacity),
        ),
      ),
    );
  }

  Widget _buildOrbitalElement(IconData icon, double offset) {
    return AnimatedBuilder(
      animation: _orbitController,
      builder: (context, child) {
        final angle = (_orbitController.value + offset) * 2 * math.pi;
        final radius = 220.0;
        final x = radius * math.cos(angle);
        final y = radius * math.sin(angle);
        
        return Transform.translate(
          offset: Offset(x, y),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF050505),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFD4AF37).withOpacity(0.6),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD4AF37).withOpacity(0.4),
                  blurRadius: 15,
                ),
              ],
            ),
            child: Icon(
              icon,
              color: const Color(0xFFD4AF37),
              size: 18,
            ),
          ),
        );
      },
    );
  }

  Widget _buildHexagonalHub() {
    return ClipPath(
      clipper: _HexagonClipper(),
      child: Container(
        width: 224,
        height: 224,
        decoration: BoxDecoration(
          color: const Color(0xFF181818),
          border: Border.all(
            color: const Color(0xFFD4AF37).withOpacity(0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD4AF37).withOpacity(0.2),
              blurRadius: 100,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'TWIGG',
              style: TextStyle(
                color: Color(0xFFE0E0E0),
                fontSize: 36,
                fontWeight: FontWeight.w700,
                letterSpacing: 7.2,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 48,
              height: 1,
              color: const Color(0xFFD4AF37).withOpacity(0.4),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => context.go('/quiz'),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text(
                  'INITIATE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 3.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(0.05),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'INSTITUTIONAL PARTNERS',
                    style: TextStyle(
                      color: const Color(0xFFE0E0E0).withOpacity(0.3),
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3.6,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Opacity(
                    opacity: 0.3,
                    child: Row(
                      children: [
                        Text(
                          'TWIGG',
                          style: TextStyle(
                            color: Color(0xFFE0E0E0),
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(width: 32),
                        Text(
                          'CRED',
                          style: TextStyle(
                            color: Color(0xFFE0E0E0),
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(width: 32),
                        Text(
                          'JUPITER',
                          style: TextStyle(
                            color: Color(0xFFE0E0E0),
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color(0xFF06B6D4),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF06B6D4).withOpacity(0.6),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'SECURE IDENTITY SYNC',
                    style: TextStyle(
                      color: const Color(0xFFE0E0E0).withOpacity(0.4),
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.8,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Background Network Pattern
class _BackgroundNetwork extends StatelessWidget {
  const _BackgroundNetwork();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.2,
        child: Stack(
          children: [
            CustomPaint(
              size: Size.infinite,
              painter: _NetworkPatternPainter(),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      const Color(0xFF0d2119).withOpacity(0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NetworkPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD4AF37).withOpacity(0.1)
      ..strokeWidth = 0.5;
    
    final circlePaint = Paint()
      ..color = const Color(0xFFD4AF37).withOpacity(0.3)
      ..style = PaintingStyle.fill;

    const spacing = 100.0;
    
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x + 2, y + 2), 1.5, circlePaint);
        canvas.drawLine(
          Offset(x + 2, y + 2),
          Offset(x + spacing, y + spacing),
          paint,
        );
        if (x > 0) {
          canvas.drawLine(
            Offset(x + 2, y + 2),
            Offset(x - spacing, y + spacing),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SegmentedRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 5;
    
    final paint = Paint()
      ..color = const Color(0xFFD4AF37).withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.butt;
    
    // First segment
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 0.4,
      false,
      paint,
    );
    
    // Second segment
    paint.color = const Color(0xFFD4AF37).withOpacity(0.3);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2 + math.pi * 0.93,
      math.pi * 0.2,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    
    path.moveTo(w * 0.5, 0);
    path.lineTo(w, h * 0.25);
    path.lineTo(w, h * 0.75);
    path.lineTo(w * 0.5, h);
    path.lineTo(0, h * 0.75);
    path.lineTo(0, h * 0.25);
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
