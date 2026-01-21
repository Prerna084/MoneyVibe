import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; 
import '../../../core/widgets/glass_widgets.dart';
import '../../../core/widgets/twigg_logo.dart';
import 'history_provider.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const TwiggLogo(),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              const Color(0xFFD4AF37).withOpacity(0.1),
              Colors.black,
            ],
            center: const Alignment(0, -0.2),
            radius: 1.2,
          ),
        ),
        child: historyAsync.when(
          data: (history) {
            if (history.isEmpty) {
              return const Center(
                child: Text("No history yet. Take the quiz!", style: TextStyle(color: Colors.white70)),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final result = history[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GlassContainer(
                    height: 120,
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              result.persona.toUpperCase(),
                              style: const TextStyle(
                                color: Color(0xFFD4AF37),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              DateFormat.yMMMd().format(result.timestamp),
                              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          result.insights.first,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37))),
          error: (err, stack) => Center(child: Text("Error: $err", style: const TextStyle(color: Colors.red))),
        ),
      ),
    );
  }
}
