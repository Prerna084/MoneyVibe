import 'package:dio/dio.dart';
import '../../../core/network/network_client.dart';
import '../domain/trait.dart';

class AssessmentRepository {
  final NetworkClient _client;

  AssessmentRepository(this._client);

  Future<QuizResult> submitQuiz(Map<String, int> answers, {String? token}) async {
    try {
      final response = await _client.dio.post(
        'submit-quiz',
        data: {
          'answers': answers,
        },
        options: token != null
            ? Options(headers: {'Authorization': 'Bearer $token'})
            : null,
      );

      final data = response.data;
      
      if (data is! Map) {
         throw Exception('Expected Map response but got ${data.runtimeType}');
      }
      
      // Parse response
      Map<TraitCategory, double> scores = {};
      if (data['scores'] != null) {
        (data['scores'] as Map<String, dynamic>).forEach((key, value) {
            TraitCategory? category;
            switch(key) {
               case 'planning': category = TraitCategory.planning; break;
               case 'impulse': category = TraitCategory.impulse; break;
               case 'risk': category = TraitCategory.risk; break;
               case 'calmness': category = TraitCategory.calmness; break;
            }
            if (category != null) {
              scores[category] = (value as num).toDouble();
            }
        });
      }

      return QuizResult(
        persona: data['persona'] ?? 'Unknown',
        scores: scores,
        insights: List<String>.from(data['insights'] ?? ['No insight available.']),
        timestamp: DateTime.parse(data['timestamp']),
        powerColor: data['powerColor'] ?? '#D4AF37',
        secondaryColor: data['secondaryColor'] ?? '#FFFFFF',
        serialNumber: data['serialNumber'] ?? 'MV-UNKNOWN',
      );
    } catch (e) {
      print("Error in submitQuiz: $e");
      throw Exception(e.toString());
    }
  }

  Future<List<QuizResult>> fetchHistory() async {
     try {
      final response = await _client.dio.get('/history');
      final List<dynamic> list = response.data;
      
      return list.map((item) {
          Map<TraitCategory, double> scores = {};
            if (item['scores'] != null) {
              (item['scores'] as Map<String, dynamic>).forEach((key, value) {
                  TraitCategory? category;
                  switch(key) {
                    case 'planning': category = TraitCategory.planning; break;
                    case 'impulse': category = TraitCategory.impulse; break;
                    case 'risk': category = TraitCategory.risk; break;
                    case 'calmness': category = TraitCategory.calmness; break;
                  }
                  if (category != null) {
                    scores[category] = (value as num).toDouble();
                  }
              });
            }

            return QuizResult(
              persona: item['persona'] ?? 'Unknown',
              scores: scores,
              insights: List<String>.from(item['insights'] ?? ['No insight available.']),
              timestamp: DateTime.parse(item['timestamp']),
              powerColor: item['powerColor'] ?? '#D4AF37',
              secondaryColor: item['secondaryColor'] ?? '#FFFFFF',
              serialNumber: item['serialNumber'] ?? 'MV-UNKNOWN',
            );
      }).toList();

    } catch (e) {
      throw Exception('Failed to load history: $e');
    }
  }
}
