import '../data/models/index.dart';

/// スコア計算ロジック
class ScoreService {
  // 難易度別のポイント付与
  static const int beginnerPoints = 1;
  static const int intermediatePoints = 2;
  static const int advancedPoints = 3;

  /// 難易度に応じたポイントを計算
  static int calculatePointsForDifficulty(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return beginnerPoints;
      case 'intermediate':
        return intermediatePoints;
      case 'advanced':
        return advancedPoints;
      default:
        throw ArgumentError('Invalid difficulty: $difficulty');
    }
  }

  /// スコアを更新（正誤判定）
  static ScoreUpdateResult updateScore({
    required UserStatusModel currentStatus,
    required String quizId,
    required String difficulty,
    required bool isCorrect,
  }) {
    if (!isCorrect) {
      // 不正解の場合はスコア加算なし
      return ScoreUpdateResult(
        pointsEarned: 0,
        newTotalScore: currentStatus.totalScore,
        quizzesSolved: currentStatus.quizzesSolved + 1,
        correctAnswers: currentStatus.correctAnswers,
        correctRate: _calculateCorrectRate(
          currentStatus.correctAnswers,
          currentStatus.quizzesSolved + 1,
        ),
      );
    }

    // 正解の場合
    final pointsEarned = calculatePointsForDifficulty(difficulty);
    final newTotalScore = currentStatus.totalScore + pointsEarned;
    final newQuizzesSolved = currentStatus.quizzesSolved + 1;
    final newCorrectAnswers = currentStatus.correctAnswers + 1;
    final correctRate = _calculateCorrectRate(newCorrectAnswers, newQuizzesSolved);

    return ScoreUpdateResult(
      pointsEarned: pointsEarned,
      newTotalScore: newTotalScore,
      quizzesSolved: newQuizzesSolved,
      correctAnswers: newCorrectAnswers,
      correctRate: correctRate,
    );
  }

  /// 正答率を計算
  static double _calculateCorrectRate(int correct, int total) {
    if (total == 0) return 0.0;
    return (correct / total * 10000).round() / 100; // 小数点以下2桁
  }

  /// ユーザー状態を更新
  static UserStatusModel applyScoreUpdate({
    required UserStatusModel currentStatus,
    required ScoreUpdateResult updateResult,
    required String difficulty,
    required bool isCorrect,
  }) {
    return currentStatus.copyWith(
      totalScore: updateResult.newTotalScore,
      quizzesSolved: updateResult.quizzesSolved,
      correctAnswers: updateResult.correctAnswers,
      correctRate: updateResult.correctRate,
    );
  }

  /// スコア情報を取得
  static Map<String, dynamic> getScoreInfo(UserStatusModel status) {
    return {
      'totalScore': status.totalScore,
      'quizzesSolved': status.quizzesSolved,
      'correctAnswers': status.correctAnswers,
      'wrongAnswers': status.wrongAnswers,
      'correctRate': '${status.correctRate}%',
      'averagePointsPerQuiz':
          status.quizzesSolved > 0
              ? (status.totalScore / status.quizzesSolved).toStringAsFixed(2)
              : 0,
    };
  }
}
