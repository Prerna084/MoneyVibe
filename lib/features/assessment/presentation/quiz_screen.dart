import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;

import 'quiz_provider.dart';
import '../../auth/presentation/auth_provider.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen>
    with SingleTickerProviderStateMixin {
  int? _selectedValue;
  bool _isExiting = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Scale labels with emojis
  final List<Map<String, dynamic>> _scaleLabels = [
    {'value': 1, 'emoji': '😤', 'label': 'STRONGLY\nDISAGREE'},
    {'value': 2, 'emoji': '😐', 'label': 'DISAGREE'},
    {'value': 3, 'emoji': '😊', 'label': 'NEUTRAL'},
    {'value': 4, 'emoji': '😄', 'label': 'AGREE'},
    {'value': 5, 'emoji': '🤩', 'label': 'STRONGLY\nAGREE'},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.1, 0),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleSelect(int value) async {
    setState(() {
      _selectedValue = value;
      _isExiting = true;
      // Ensure slide animation is set to "forward" (left)
      _slideAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-0.1, 0),
      ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      );
    });

    _animationController.forward();

    await Future.delayed(const Duration(milliseconds: 300));

    final notifier = ref.read(quizProvider.notifier);
    final state = ref.read(quizProvider);
    final questionId = notifier.questions[state.currentIndex].id;

    await Future.delayed(const Duration(milliseconds: 100));
    final auth = ref.read(authProvider);
    await notifier.answerQuestion(questionId, value, token: auth.token);

    if (mounted) {
      _animationController.reset();
      setState(() {
        _selectedValue = null;
        _isExiting = false;
      });
    }
  }

  Future<void> _handleBack() async {
    if (_isExiting) return;

    setState(() {
      _isExiting = true;
      // Set slide animation to "back" (right)
      _slideAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(0.1, 0),
      ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      );
    });

    _animationController.forward();
    await Future.delayed(const Duration(milliseconds: 300));

    ref.read(quizProvider.notifier).previousQuestion();

    if (mounted) {
      _animationController.reset();
      setState(() {
        _isExiting = false;
        // Reset forward slide animation for next select
        _slideAnimation = Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-0.1, 0),
        ).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizProvider);
    final notifier = ref.read(quizProvider.notifier);
    final questions = notifier.questions;

    ref.listen(quizProvider, (_, next) {
      if (next.isAnalyzing) {
        context.go('/analyzing');
      } else if (next.isComplete && !next.isLoading) {
        final auth = ref.read(authProvider);
        if (auth.isAuthenticated) {
          context.go('/results');
        } else {
          context.go('/auth');
        }
      }
    });

    if (quizState.isLoading) {
      return const _ProcessingView();
    }

    final currentQuestion = questions[quizState.currentIndex];
    final progress = ((quizState.currentIndex + 1) / questions.length) * 100;
    
    // Sync local selected value with state if not currently animating
    if (!_isExiting) {
      _selectedValue = quizState.answers[currentQuestion.id];
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Column(
          children: [
            // Minimal Header with Logo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/twigg_logo_circles.png',
                    width: 32,
                    height: 32,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(width: 32, height: 32);
                    },
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'TWIGG',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 896),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Title above card
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    children: [
                                      TextSpan(text: 'Let\'s find your '),
                                      TextSpan(
                                        text: 'MoneyVibe',
                                        style: TextStyle(
                                          color: Color(0xFFD4AF37),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 32),

                                // Glass Premium Container
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(40),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF181818).withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(40),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.1),
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      // Top gradient border
                                      Positioned(
                                        top: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          height: 2,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.transparent,
                                                const Color(0xFFD4AF37).withOpacity(0.5),
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      Column(
                                        children: [
                                           // Header with Back Button and Progress Ring
                                           Row(
                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                             children: [
                                               _QuizBackButton(
                                                 isEnabled: quizState.currentIndex > 0,
                                                 onTap: _handleBack,
                                               ),
                                               _CircularProgressRing(
                                                 progress: (quizState.currentIndex + 1) / questions.length,
                                                 percentage: progress.round(),
                                               ),
                                             ],
                                           ),

                                          const SizedBox(height: 48),

                                          // Question Text with Animation
                                          FadeTransition(
                                            opacity: _fadeAnimation,
                                            child: SlideTransition(
                                              position: _slideAnimation,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    '"${currentQuestion.text}"',
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      color: Color(0xFFE0E0E0),
                                                      fontSize: 48,
                                                      fontWeight: FontWeight.w400,
                                                      height: 1.3,
                                                    ),
                                                  ),

                                                  const SizedBox(height: 64),

                                                  // Scale Buttons
                                                  Wrap(
                                                    alignment: WrapAlignment.center,
                                                    spacing: 16,
                                                    runSpacing: 16,
                                                    children: _scaleLabels.map((item) {
                                                      final isSelected = _selectedValue == item['value'];
                                                      return _ScaleButton(
                                                        emoji: item['emoji'],
                                                        label: item['label'],
                                                        isSelected: isSelected,
                                                        isDisabled: _isExiting,
                                                        onTap: () => _handleSelect(item['value']),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 48),

                                // Modern Progress Line
                                SizedBox(
                                  width: 512,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        height: 1,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.1),
                                        ),
                                      ),
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 1000),
                                        curve: Curves.easeOut,
                                        height: 1,
                                        width: 512 * (progress / 100),
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFD4AF37),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFFD4AF37),
                                              blurRadius: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        color: const Color(0xFF121212),
                                        child: Text(
                                          'BEHAVIORAL SYNC',
                                          style: TextStyle(
                                            color: const Color(0xFFE0E0E0).withOpacity(0.2),
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 3.6,
                                          ),
                                        ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScaleButton extends StatefulWidget {
  final String emoji;
  final String label;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback onTap;

  const _ScaleButton({
    required this.emoji,
    required this.label,
    required this.isSelected,
    required this.isDisabled,
    required this.onTap,
  });

  @override
  State<_ScaleButton> createState() => _ScaleButtonState();
}

class _ScaleButtonState extends State<_ScaleButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.isDisabled ? null : widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          width: 128,
          height: 128,
          decoration: BoxDecoration(
            color: widget.isSelected
                ? const Color(0xFFD4AF37)
                : Colors.white.withOpacity(_isHovering ? 0.1 : 0.05),
            border: Border.all(
              color: widget.isSelected
                  ? const Color(0xFFD4AF37)
                  : Colors.white.withOpacity(_isHovering ? 0.3 : 0.1),
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFFD4AF37).withOpacity(0.4),
                      blurRadius: 40,
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: widget.isSelected
                    ? 1.1
                    : _isHovering
                        ? 1.25
                        : 1.0,
                duration: const Duration(milliseconds: 500),
                child: Text(
                  widget.emoji,
                  style: const TextStyle(fontSize: 40),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: widget.isSelected
                      ? Colors.black
                      : _isHovering
                          ? const Color(0xFFE0E0E0)
                          : const Color(0xFFE0E0E0).withOpacity(0.4),
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.6,
                  height: 1.2,
                ),
              ),
              if (widget.isSelected) ...[
                const SizedBox(height: 8),
                Container(
                  width: 64,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ProcessingView extends StatefulWidget {
  const _ProcessingView();

  @override
  State<_ProcessingView> createState() => _ProcessingViewState();
}

class _ProcessingViewState extends State<_ProcessingView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Custom Spinner
            SizedBox(
              width: 96, // w-24
              height: 96, // h-24
              child: Stack(
                children: [
                  // Outer border (static opacity)
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFD4AF37).withOpacity(0.2),
                        width: 4,
                      ),
                    ),
                  ),
                  // Spinning border
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
                    strokeWidth: 4,
                  ),
                  // Inner pulsing circle
                  FadeTransition(
                    opacity: Tween<double>(begin: 0.5, end: 1.0).animate(_controller),
                    child: Container(
                      margin: const EdgeInsets.all(16), // inset-4
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40), // mb-10
            
            // Pulsing Text
            FadeTransition(
              opacity: Tween<double>(begin: 0.6, end: 1.0).animate(_controller),
              child: const Text(
                'PROCESSING NEURAL PATTERNS',
                style: TextStyle(
                  color: Color(0xFFD4AF37),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 5, // tracking-[0.5em]
                ),
              ),
            ),
            const SizedBox(height: 8),
            
            // Subtitle
            Text(
              'Aligning behavioral metrics with global wealth standards...',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFFF5F5F5).withOpacity(0.4),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuizBackButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isEnabled;

  const _QuizBackButton({required this.onTap, required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isEnabled ? 1.0 : 0.0,
      child: MouseRegion(
        cursor: isEnabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: GestureDetector(
          onTap: isEnabled ? onTap : null,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white.withOpacity(0.7),
              size: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class _CircularProgressRing extends StatelessWidget {
  final double progress;
  final int percentage;

  const _CircularProgressRing({required this.progress, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: progress),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return SizedBox(
          width: 56,
          height: 56,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: CircularProgressIndicator(
                  value: value,
                  strokeWidth: 2,
                  backgroundColor: Colors.white.withOpacity(0.05),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '${(value * 100).round()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Text(
                    '%',
                    style: TextStyle(
                      color: Color(0xFFD4AF37),
                      fontSize: 8,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
