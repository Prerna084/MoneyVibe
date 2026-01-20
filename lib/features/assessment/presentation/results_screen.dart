import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_markdown/flutter_markdown.dart'; // Using this from your pubspec
import 'package:google_fonts/google_fonts.dart';
import '../domain/trait.dart';
import 'quiz_provider.dart';

class ResultsScreen extends ConsumerStatefulWidget {
  const ResultsScreen({super.key});

  @override
  ConsumerState<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends ConsumerState<ResultsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isCopied = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizProvider);

    final result = state.result;
    
    if (result == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF121212),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
        ),
      );
    }

    final scores = result.scores;
    final radarDataEntries = [
      RadarEntry(value: (scores[TraitCategory.planning] ?? 0).toDouble()),
      RadarEntry(value: (scores[TraitCategory.impulse] ?? 0).toDouble()),
      RadarEntry(value: (scores[TraitCategory.risk] ?? 0).toDouble()),
      RadarEntry(value: (scores[TraitCategory.calmness] ?? 0).toDouble()),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth > 900;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 48),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeader(context, ref, result, isDesktop),
                        const SizedBox(height: 64),
                        if (isDesktop)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 420,
                                child: _buildVisualReport(
                                    context, radarDataEntries, scores, result),
                              ),
                              const SizedBox(width: 48),
                              Expanded(
                                // This Expanded is CRITICAL for horizontal text
                                child: _buildNarrativeSide(context, result),
                              ),
                            ],
                          )
                        else
                          Column(
                            children: [
                              _buildVisualReport(
                                  context, radarDataEntries, scores, result),
                              const SizedBox(height: 48),
                              _buildNarrativeSide(context, result),
                            ],
                          ),
                        const SizedBox(height: 80),
                        _buildDeepDiveSection(context, scores),
                        const SizedBox(height: 80),
                        _buildFooterActions(context, ref),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, WidgetRef ref, QuizResult result, bool isDesktop) {
    final onReset = () {
      ref.read(quizProvider.notifier).reset();
      context.go('/');
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'ELITE ANALYSIS COMPLETE',
              style: TextStyle(
                  color: Color(0xFFD4AF37),
                  letterSpacing: 4,
                  fontSize: 10,
                  fontWeight: FontWeight.w900),
            ),
            if (isDesktop)
              _buildHeaderButton(
                  label: 'RESTART', onTap: onReset, isPrimary: true),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Your Money\nVibe Score.',
          style: TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 0.9),
        ),
      ],
    );
  }

  Widget _buildHeaderButton(
      {required String label,
      required VoidCallback onTap,
      required bool isPrimary}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFFD4AF37) : Colors.white10,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(label,
            style: TextStyle(
                color: isPrimary ? Colors.black : Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 10)),
      ),
    );
  }

  Widget _buildVisualReport(BuildContext context, List<RadarEntry> entries,
      Map<TraitCategory, double> scores, QuizResult result) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: const Color(0xFF181818),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          const Text('CORE METRICS',
              style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 2.4,
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 48),
          SizedBox(
            height: 300,
            child: RadarChart(
              RadarChartData(
                radarShape: RadarShape.polygon,
                dataSets: [
                  RadarDataSet(
                    fillColor: const Color(0xFFD4AF37).withOpacity(0.2),
                    borderColor: const Color(0xFFD4AF37),
                    dataEntries: entries,
                    borderWidth: 2,
                  ),
                ],
                gridBorderData: const BorderSide(color: Colors.white12),
                tickCount: 3,
                ticksTextStyle: const TextStyle(color: Colors.transparent),
                getTitle: (index, angle) {
                  switch (index) {
                    case 0:
                      return const RadarChartTitle(text: 'Planning');
                    case 1:
                      return const RadarChartTitle(text: 'Impulse');
                    case 2:
                      return const RadarChartTitle(text: 'Risk');
                    case 3:
                      return const RadarChartTitle(text: 'Calmness');
                    default:
                      return const RadarChartTitle(text: '');
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 48),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.8,
            children: scores.entries.take(4).map((e) {
              return Container(
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(e.key.name.toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 8)),
                    Text('${e.value.round()}%',
                        style: const TextStyle(
                            color: Color(0xFFD4AF37),
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNarrativeSide(BuildContext context, QuizResult result) {
    final fullText = result.insights.join('\n\n');

    // Logic to isolate North Star
    String northStarText = "";
    String remainingText = fullText;

    if (fullText.contains('**NORTH STAR**')) {
      final parts = fullText.split('**NORTH STAR**');
      remainingText = parts[0];
      northStarText = _ResultsScreenState._normalizeNorthStarText(parts[1]);
    }

    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: const Color(0xFF181818),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.flash_on, color: Color(0xFFD4AF37), size: 16),
              const SizedBox(width: 12),
              const Text('FINANCIAL DNA REPORT',
                  style: TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2)),
            ],
          ),
          const SizedBox(height: 32),
        MarkdownBody(
          data: remainingText,
          styleSheet: MarkdownStyleSheet(
            p: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18,
                height: 1.7,
                fontWeight: FontWeight.w400),
            strong: GoogleFonts.outfit(
                color: const Color(0xFFD4AF37),
                fontWeight: FontWeight.w900,
                fontSize: 12,
                letterSpacing: 2.5),
          ),
        ),
          if (northStarText.isNotEmpty) ...[
            const SizedBox(height: 48),
            _buildNorthStarCard(northStarText),
          ],
        ],
      ),
    );
  }

  Widget _buildNorthStarCard(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 36),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFD4AF37).withOpacity(0.15),
            const Color(0xFFD4AF37).withOpacity(0.05),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4AF37).withOpacity(0.08),
            blurRadius: 40,
            spreadRadius: -10,
          ),
        ],
        border: Border.all(
          color: const Color(0xFFD4AF37).withOpacity(0.35),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Color(0xFFD4AF37), size: 20),
              const SizedBox(width: 12),
              Text(
                'STRATEGIC NORTH STAR',
                style: GoogleFonts.outfit(
                  color: const Color(0xFFD4AF37),
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 4,
                height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFD4AF37), Colors.transparent],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Text(
                  text,
                  style: GoogleFonts.outfit(
                    color: Colors.white.withOpacity(0.95),
                    fontSize: 22,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _normalizeNorthStarText(String text) {
    if (text.trim().isEmpty) return text;

    // Use a special literal-split to detect double-space word boundaries
    final tokens = text.replaceAll('\n', ' ').replaceAll('\r', ' ').split(' ');
    final result = StringBuffer();
    final wordAcc = StringBuffer();

    void flushWord() {
      if (wordAcc.isNotEmpty) {
        if (result.isNotEmpty) result.write(' ');
        result.write(wordAcc.toString());
        wordAcc.clear();
      }
    }

    for (final token in tokens) {
      if (token.isEmpty) {
        // Double space encountered = end of current word build
        flushWord();
        continue;
      }

      // If it's a single letter, part of a spaced word
      if (token.length == 1 && RegExp(r'[a-zA-Z]').hasMatch(token)) {
        wordAcc.write(token);
      } 
      // Handle punctuation - join to word buffer then flush
      else if (RegExp(r'^[.,!?:]$').hasMatch(token)) {
        wordAcc.write(token);
        flushWord();
      }
      // Typical multi-char word or other content
      else {
        flushWord();
        if (result.isNotEmpty) result.write(' ');
        result.write(token);
      }
    }

    flushWord();
    
    // Final cleanup: if the heuristic failed and we have excessive length words,
    // we may need a backup split, but let's try this standard spacing first.
    return result.toString().trim();
  }
  
  Widget _buildDeepDiveSection(
      BuildContext context, Map<TraitCategory, double> scores) {
    return LayoutBuilder(builder: (context, constraints) {
      int count = constraints.maxWidth < 600 ? 1 : 4;
      return GridView.count(
        crossAxisCount: count,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 24,
        crossAxisSpacing: 24,
        childAspectRatio: 1.6,
        children: scores.entries.map((e) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(24)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(e.key.name.toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 10)),
                    Text('${e.value.round()}%',
                        style: const TextStyle(
                            color: Color(0xFFD4AF37), fontSize: 24)),
                  ],
                ),
                LinearProgressIndicator(
                    value: e.value / 100,
                    color: const Color(0xFFD4AF37),
                    backgroundColor: Colors.white10),
              ],
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildFooterActions(BuildContext context, WidgetRef ref) {
    return Center(
      child: _buildHeaderButton(
          label: 'DOWNLOAD PDF REPORT', onTap: () {}, isPrimary: true),
    );
  }
}