import 'package:test/test.dart';
import 'package:crypto_quiz_app/data/models/index.dart';
import 'package:crypto_quiz_app/service/score_service.dart';

void main() {
  test('ScoreService calculates points by difficulty', () {
    expect(ScoreService.calculatePointsForDifficulty('beginner'), 1);
    expect(ScoreService.calculatePointsForDifficulty('intermediate'), 2);
    expect(ScoreService.calculatePointsForDifficulty('advanced'), 3);
  });

  test('ScoreService updates score for correct answer', () {
    final status = UserStatusModel(
      deviceId: 'test',
      totalScore: 0,
      quizzesSolved: 0,
      correctAnswers: 0,
      wrongAnswers: 0,
      correctRate: 0.0,
      characterLevel: 1,
      characterEvolutionProgress: 0.0,
      badgesAcquired: const [],
      scoreHistory: const [],
      lastSynced: DateTime.now(),
    );

    final result = ScoreService.updateScore(
      currentStatus: status,
      quizId: 'quiz_1',
      difficulty: 'beginner',
      isCorrect: true,
    );

    expect(result.pointsEarned, 1);
    expect(result.newTotalScore, 1);
    expect(result.quizzesSolved, 1);
    expect(result.correctAnswers, 1);
  });
}
