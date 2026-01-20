import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/trait.dart';
import '../data/assessment_repository.dart';
import '../../../core/network/network_client.dart';

final assessmentRepositoryProvider = Provider((ref) {
  return AssessmentRepository(NetworkClient());
});

final quizProvider = StateNotifierProvider<QuizNotifier, QuizState>((ref) {
  return QuizNotifier(ref.read(assessmentRepositoryProvider));
});

class QuizState {
  final int currentIndex;
  final Map<String, int> answers;
  final bool isComplete;
  final bool isLoading;
  final bool isAnalyzing; // NEW: Track analyzing screen
  final QuizResult? result;

  QuizState({
    this.currentIndex = 0,
    this.answers = const {},
    this.isComplete = false,
    this.isLoading = false,
    this.isAnalyzing = false,
    this.result,
  });

  QuizState copyWith({
    int? currentIndex,
    Map<String, int>? answers,
    bool? isComplete,
    bool? isLoading,
    bool? isAnalyzing,
    QuizResult? result,
  }) {
    return QuizState(
      currentIndex: currentIndex ?? this.currentIndex,
      answers: answers ?? this.answers,
      isComplete: isComplete ?? this.isComplete,
      isLoading: isLoading ?? this.isLoading,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      result: result ?? this.result,
    );
  }
}

class QuizNotifier extends StateNotifier<QuizState> {
  final AssessmentRepository _repository;
  
  QuizNotifier(this._repository) : super(QuizState());

  final List<Question> questions = [
    Question(id: '1', category: TraitCategory.planning, text: "I save a portion of my income every month, no matter what."),
    Question(id: '2', category: TraitCategory.planning, text: "I think a lot about how today's money decisions affect my future."),
    Question(id: '3', category: TraitCategory.impulse, text: "I often buy things I don't need when I'm feeling down."),
    Question(id: '4', category: TraitCategory.impulse, text: "I celebrate good news by spending money."),
    Question(id: '5', category: TraitCategory.risk, text: "I feel confident investing in stocks or mutual funds."),
    Question(id: '6', category: TraitCategory.risk, text: "I can tolerate temporary losses if it means higher long-term returns."),
    Question(id: '7', category: TraitCategory.calmness, text: "I stay calm even when markets fluctuate sharply."),
  ];

  Future<void> answerQuestion(String questionId, int value, {String? token}) async {
    final newAnswers = Map<String, int>.from(state.answers);
    if (questionId.isNotEmpty) {
      newAnswers[questionId] = value;
    }

    if (state.currentIndex < questions.length - 1 && questionId.isNotEmpty) {
      state = state.copyWith(
        answers: newAnswers,
        currentIndex: state.currentIndex + 1,
      );
    } else {
      // Last question or re-triggering from Auth
      state = state.copyWith(answers: newAnswers);
      
      if (token == null) {
        // Stop here and let the UI navigate to /auth
        state = state.copyWith(isComplete: true); // This signals we're done with questions
        return;
      }

      state = state.copyWith(isLoading: true, isAnalyzing: true);
      try {
        final result = await _repository.submitQuiz(newAnswers, token: token);
        state = state.copyWith(
          isComplete: true,
          isLoading: false,
          isAnalyzing: false,
          result: result,
        );
      } catch (e) {
        print("Error submitting quiz: $e");
        state = state.copyWith(
          isComplete: true,
          isLoading: false,
          isAnalyzing: false,
        );
      }
    }
  }

  Future<void> submitWithToken(String token) async {
    await answerQuestion('', 0, token: token);
  }

  void previousQuestion() {
    if (state.currentIndex > 0) {
      state = state.copyWith(
        currentIndex: state.currentIndex - 1,
      );
    }
  }

  void reset() {
    state = QuizState();
  }
}
