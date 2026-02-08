import '../data/models/index.dart';
import '../data/repositories/quiz_repository.dart';

class QuizService {
  QuizService({QuizRepository? quizRepository})
      : _quizRepository = quizRepository ?? QuizRepository();

  final QuizRepository _quizRepository;

  Future<List<QuizModel>> getQuizzesByDifficulty(String difficulty) async {
    return _quizRepository.fetchByDifficulty(difficulty);
  }

  Future<QuizModel?> getRandomQuiz({
    required List<QuizModel> availableQuizzes,
    required List<String> answeredQuizIds,
  }) async {
    final unanswered = availableQuizzes
        .where((quiz) => !answeredQuizIds.contains(quiz.id))
        .toList();
    if (unanswered.isEmpty) {
      final shuffled = List<QuizModel>.from(availableQuizzes)..shuffle();
      return shuffled.isNotEmpty ? shuffled.first : null;
    }
    final shuffled = List<QuizModel>.from(unanswered)..shuffle();
    return shuffled.first;
  }

  Future<Map<String, List<QuizModel>>> getQuizzesByCategory(
    List<QuizModel> quizzes,
  ) async {
    final map = <String, List<QuizModel>>{};
    for (final quiz in quizzes) {
      map.putIfAbsent(quiz.category, () => <QuizModel>[]);
      map[quiz.category]!.add(quiz);
    }
    return map;
  }
}
