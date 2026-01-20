
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MoneyVibeApp());
}

class MoneyVibeApp extends StatelessWidget {
  const MoneyVibeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoneyVibe Clone',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: const Color(0xFFD4AF37),
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}

// --- MODELS ---
enum TraitCategory { planning, impulse, risk, calmness }

class Question {
  final String id;
  final String text;
  final TraitCategory category;

  Question({required this.id, required this.text, required this.category});
}

class QuizResult {
  final String persona;
  final Map<TraitCategory, double> scores;
  final List<String> insights;
  final DateTime timestamp;

  QuizResult({
    required this.persona,
    required this.scores,
    required this.insights,
    required this.timestamp,
  });
}

// --- SCREENS ---

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [const Color(0xFFD4AF37).withOpacity(0.1), Colors.black],
            radius: 1.5,
            center: const Alignment(0.8, -0.8),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD4AF37).withOpacity(0.3),
                    blurRadius: 40,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: const Icon(Icons.trending_up, color: Colors.black, size: 64),
            ),
            const SizedBox(height: 48),
            const Text(
              "What's your\nMoney Vibe?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              "Discover your financial personality with AI-powered insights.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizScreen())),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text("START TEST", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              child: Text("VIEW HISTORY", style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  final Map<String, int> _answers = {};
  
  final List<Question> _questions = [
    Question(id: '1', category: TraitCategory.planning, text: "I save a portion of my income every month, no matter what."),
    Question(id: '2', category: TraitCategory.planning, text: "I think a lot about how today's money decisions affect my future."),
    Question(id: '3', category: TraitCategory.impulse, text: "I often buy things I don't need when I'm feeling down."),
    Question(id: '4', category: TraitCategory.impulse, text: "I celebrate good news by spending money."),
    Question(id: '5', category: TraitCategory.risk, text: "I feel confident investing in stocks or mutual funds."),
    Question(id: '6', category: TraitCategory.risk, text: "I can tolerate temporary losses if it means higher long-term returns."),
    Question(id: '7', category: TraitCategory.calmness, text: "I stay calm even when markets fluctuate sharply."),
  ];

  void _onAnswer(int value) {
    setState(() {
      _answers[_questions[_currentIndex].id] = value;
      if (_currentIndex < _questions.length - 1) {
        _currentIndex++;
      } else {
        _processResults();
      }
    });
  }

  void _processResults() {
    // Nav to Results (Placeholder for brevity)
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ResultsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_currentIndex];
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (_currentIndex + 1) / _questions.length,
              backgroundColor: Colors.grey.shade900,
              color: const Color(0xFFD4AF37),
            ),
            const SizedBox(height: 48),
            Text(
              q.category.name.toUpperCase(),
              style: const TextStyle(color: Color(0xFFD4AF37), letterSpacing: 2, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              q.text,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (index) {
                int val = index + 1;
                return InkWell(
                  onTap: () => _onAnswer(val),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade800),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text("$val", style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                );
              }),
            ),
            const SizedBox(height: 64),
          ],
        ),
      ),
    );
  }
}

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_awesome, color: Color(0xFFD4AF37), size: 48),
            const SizedBox(height: 24),
            const Text("THE STRATEGIST", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade900.withOpacity(0.5),
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Text("Your radar chart would render here using a custom painter.", textAlign: TextAlign.center),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("BACK TO HOME"),
            )
          ],
        ),
      ),
    );
  }
}
