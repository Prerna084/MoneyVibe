import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../assessment/presentation/quiz_provider.dart';
import '../../assessment/domain/trait.dart';

final historyProvider = FutureProvider<List<QuizResult>>((ref) async {
  final repository = ref.read(assessmentRepositoryProvider);
  return await repository.fetchHistory();
});
