import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/twigg_theme.dart';
import 'features/assessment/presentation/welcome_screen.dart';
import 'features/assessment/presentation/quiz_screen.dart';
import 'features/assessment/presentation/analyzing_screen.dart';
import 'features/assessment/presentation/results_screen.dart';
import 'features/history/presentation/history_screen.dart';
import 'features/auth/presentation/auth_screen.dart';
import 'features/auth/presentation/auth_provider.dart';

void main() {
  runApp(const ProviderScope(child: MoneyVibeApp()));
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/quiz',
      builder: (context, state) => const QuizScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/results',
      builder: (context, state) => const ResultsScreen(),
    ),
    GoRoute(
      path: '/analyzing',
      builder: (context, state) => const AnalyzingScreen(),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryScreen(),
    ),
  ],
);

class MoneyVibeApp extends StatelessWidget {
  const MoneyVibeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MoneyVibe Clone',
      theme: twiggTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
