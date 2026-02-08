import 'package:flutter/foundation.dart';
import 'character_status.dart';
import 'quiz.dart';
import 'user_status.dart';

@immutable
class QuizResultData {
  const QuizResultData({
    required this.quiz,
    required this.isCorrect,
    required this.selectedIndex,
    required this.pointsEarned,
    required this.totalScore,
    required this.newBadges,
    required this.characterStatus,
    required this.leveledUp,
  });

  final QuizModel quiz;
  final bool isCorrect;
  final int selectedIndex;
  final int pointsEarned;
  final int totalScore;
  final List<BadgeModel> newBadges;
  final CharacterStatus characterStatus;
  final bool leveledUp;
}
