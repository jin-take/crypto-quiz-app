import '../data/models/index.dart';

/// キャラクター進化システム
class CharacterService {
  /// キャラクターレベル定義
  static const List<CharacterLevel> levels = [
    CharacterLevel(
      level: 1,
      requiredScore: 0,
      name: 'Egg',
      emoji: '🥚',
    ),
    CharacterLevel(
      level: 2,
      requiredScore: 50,
      name: 'Hatching',
      emoji: '🐣',
    ),
    CharacterLevel(
      level: 3,
      requiredScore: 150,
      name: 'Chick',
      emoji: '🐤',
    ),
    CharacterLevel(
      level: 4,
      requiredScore: 300,
      name: 'Young Eagle',
      emoji: '🦅',
    ),
    CharacterLevel(
      level: 5,
      requiredScore: 500,
      name: 'Master Eagle',
      emoji: '🦅✨',
    ),
  ];

  /// 現在のキャラクターステータスを計算
  static CharacterStatus calculateCharacterStatus(int totalScore) {
    int currentLevel = 1;
    CharacterLevel? currentLevelDef;
    CharacterLevel? nextLevelDef;

    // 現在のレベルを決定
    for (final level in levels.reversed) {
      if (totalScore >= level.requiredScore) {
        currentLevel = level.level;
        currentLevelDef = level;
        break;
      }
    }

    // 次のレベルを決定
    for (final level in levels) {
      if (level.level > currentLevel) {
        nextLevelDef = level;
        break;
      }
    }

    // 進化度合いを計算
    double evolutionProgress = 0.0;
    if (nextLevelDef != null) {
      final progressStart = currentLevelDef!.requiredScore;
      final progressEnd = nextLevelDef.requiredScore;
      final totalProgress = progressEnd - progressStart;
      final currentProgress = totalScore - progressStart;
      evolutionProgress = (currentProgress / totalProgress).clamp(0.0, 1.0);
    } else {
      evolutionProgress = 1.0; // 最高レベルの場合
    }

    return CharacterStatus(
      level: currentLevel,
      emoji: currentLevelDef!.emoji,
      name: currentLevelDef.name,
      requiredScoreForCurrentLevel: currentLevelDef.requiredScore,
      nextLevelRequiredScore: nextLevelDef?.requiredScore,
      evolutionProgress: evolutionProgress,
    );
  }

  /// レベルアップ判定
  static bool hasLeveledUp(
    int oldTotalScore,
    int newTotalScore,
  ) {
    final oldCharacter = calculateCharacterStatus(oldTotalScore);
    final newCharacter = calculateCharacterStatus(newTotalScore);
    return newCharacter.level > oldCharacter.level;
  }

  /// 次のレベルまでに必要なスコア
  static int getPointsNeededForNextLevel(int totalScore) {
    final character = calculateCharacterStatus(totalScore);
    if (character.nextLevelRequiredScore == null) {
      return 0; // 最高レベルに達している
    }
    return character.nextLevelRequiredScore! - totalScore;
  }

  /// レベル情報を取得
  static CharacterLevel? getLevelInfo(int level) {
    try {
      return levels.firstWhere((l) => l.level == level);
    } catch (e) {
      return null;
    }
  }

  /// すべてのレベル情報を取得
  static List<CharacterLevel> getAllLevels() {
    return levels;
  }

  /// 最大レベルを取得
  static int getMaxLevel() {
    return levels.isEmpty ? 1 : levels.last.level;
  }

  /// キャラクターストレージ情報を更新
  static UserStatusModel updateCharacterStatus(UserStatusModel status) {
    final character = calculateCharacterStatus(status.totalScore);
    return status.copyWith(
      characterLevel: character.level,
      characterEvolutionProgress: character.evolutionProgress,
    );
  }

  /// キャラクター情報を取得
  static Map<String, dynamic> getCharacterInfo(UserStatusModel status) {
    final character = calculateCharacterStatus(status.totalScore);
    return {
      'level': character.level,
      'emoji': character.emoji,
      'name': character.name,
      'score': status.totalScore,
      'requiredScoreForCurrentLevel':
          character.requiredScoreForCurrentLevel,
      'nextLevelRequiredScore': character.nextLevelRequiredScore,
      'pointsNeededForNextLevel': character.nextLevelRequiredScore == null
          ? 0
          : character.nextLevelRequiredScore! - status.totalScore,
      'evolutionProgress':
          '${(character.evolutionProgress * 100).toStringAsFixed(1)}%',
      'maxLevel': getMaxLevel(),
    };
  }
}
