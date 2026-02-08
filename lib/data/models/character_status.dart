import 'package:flutter/foundation.dart';

@immutable
class CharacterLevel {
  const CharacterLevel({
    required this.level,
    required this.requiredScore,
    required this.name,
    required this.emoji,
  });

  final int level;
  final int requiredScore;
  final String name;
  final String emoji;
}

@immutable
class CharacterStatus {
  const CharacterStatus({
    required this.level,
    required this.emoji,
    required this.name,
    required this.requiredScoreForCurrentLevel,
    this.nextLevelRequiredScore,
    required this.evolutionProgress,
  });

  final int level;
  final String emoji;
  final String name;
  final int requiredScoreForCurrentLevel;
  final int? nextLevelRequiredScore;
  final double evolutionProgress;
}
