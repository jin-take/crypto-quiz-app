import '../data/models/index.dart';

/// バッジシステム
class BadgeService {
  /// バッジ定義
  static const Map<String, Map<String, dynamic>> badgeDefinitions = {
    'badge_first_quiz': {
      'name': 'クイズ初挑戦',
      'icon': '🌟',
      'description': '初めてクイズを解く',
    },
    'badge_beginner_10': {
      'name': '初心者①',
      'icon': '💎',
      'description': '初級クイズを10問正解',
    },
    'badge_beginner_50': {
      'name': '初心者②',
      'icon': '💎💎',
      'description': '初級クイズを50問正解',
    },
    'badge_intermediate_10': {
      'name': '挑戦者①',
      'icon': '⭐',
      'description': '中級クイズを10問正解',
    },
    'badge_intermediate_50': {
      'name': '挑戦者②',
      'icon': '⭐⭐',
      'description': '中級クイズを50問正解',
    },
    'badge_advanced_10': {
      'name': 'マスター①',
      'icon': '👑',
      'description': '上級クイズを10問正解',
    },
    'badge_advanced_50': {
      'name': 'マスター②',
      'icon': '👑👑',
      'description': '上級クイズを50問正解',
    },
    'badge_score_100': {
      'name': 'スコア 100 達成',
      'icon': '🔥',
      'description': '累計スコア 100pt 以上',
    },
    'badge_score_500': {
      'name': 'スコア 500 達成',
      'icon': '🔥🔥',
      'description': '累計スコア 500pt 以上',
    },
    'badge_correct_rate_90': {
      'name': '正答率 90% 達成',
      'icon': '🎯',
      'description': '正答率 90% 以上を達成',
    },
    'badge_daily_login': {
      'name': 'デイリー',
      'icon': '📅',
      'description': '7日連続ログイン',
    },
  };

  /// 新しく獲得すべきバッジをチェック
  static List<BadgeModel> checkNewBadges({
    required UserStatusModel currentStatus,
    required String difficulty,
    required bool isCorrect,
  }) {
    final newBadges = <BadgeModel>[];
    final acquiredBadgeIds = currentStatus.badgesAcquired
        .map((badge) => badge.id)
        .toSet();

    // 各バッジの条件チェック
    if (!acquiredBadgeIds.contains('badge_first_quiz') &&
        currentStatus.quizzesSolved >= 1) {
      newBadges.add(_createBadge('badge_first_quiz'));
    }

    if (!acquiredBadgeIds.contains('badge_beginner_10') &&
        _countCorrectByDifficulty(currentStatus, 'beginner') >= 10) {
      newBadges.add(_createBadge('badge_beginner_10'));
    }

    if (!acquiredBadgeIds.contains('badge_beginner_50') &&
        _countCorrectByDifficulty(currentStatus, 'beginner') >= 50) {
      newBadges.add(_createBadge('badge_beginner_50'));
    }

    if (!acquiredBadgeIds.contains('badge_intermediate_10') &&
        _countCorrectByDifficulty(currentStatus, 'intermediate') >= 10) {
      newBadges.add(_createBadge('badge_intermediate_10'));
    }

    if (!acquiredBadgeIds.contains('badge_intermediate_50') &&
        _countCorrectByDifficulty(currentStatus, 'intermediate') >= 50) {
      newBadges.add(_createBadge('badge_intermediate_50'));
    }

    if (!acquiredBadgeIds.contains('badge_advanced_10') &&
        _countCorrectByDifficulty(currentStatus, 'advanced') >= 10) {
      newBadges.add(_createBadge('badge_advanced_10'));
    }

    if (!acquiredBadgeIds.contains('badge_advanced_50') &&
        _countCorrectByDifficulty(currentStatus, 'advanced') >= 50) {
      newBadges.add(_createBadge('badge_advanced_50'));
    }

    if (!acquiredBadgeIds.contains('badge_score_100') &&
        currentStatus.totalScore >= 100) {
      newBadges.add(_createBadge('badge_score_100'));
    }

    if (!acquiredBadgeIds.contains('badge_score_500') &&
        currentStatus.totalScore >= 500) {
      newBadges.add(_createBadge('badge_score_500'));
    }

    if (!acquiredBadgeIds.contains('badge_correct_rate_90') &&
        currentStatus.correctRate >= 90.0) {
      newBadges.add(_createBadge('badge_correct_rate_90'));
    }

    return newBadges;
  }

  /// バッジを作成
  static BadgeModel _createBadge(String badgeId) {
    final definition = badgeDefinitions[badgeId];
    if (definition == null) {
      throw ArgumentError('Unknown badge: $badgeId');
    }

    return BadgeModel(
      id: badgeId,
      name: definition['name'] as String,
      icon: definition['icon'] as String?,
      acquiredAt: DateTime.now(),
    );
  }

  /// 難易度別の正解数をカウント
  static int _countCorrectByDifficulty(
    UserStatusModel status,
    String difficulty,
  ) {
    return status.scoreHistory
        .where((record) =>
            record.difficulty.toLowerCase() == difficulty.toLowerCase() &&
            record.isCorrect)
        .length;
  }

  /// バッジ情報を取得
  static Map<String, dynamic> getBadgeInfo(String badgeId) {
    return badgeDefinitions[badgeId] ??
        {'error': 'Unknown badge: $badgeId'};
  }

  /// 全バッジ定義を取得
  static Map<String, Map<String, dynamic>> getAllBadgeDefinitions() {
    return badgeDefinitions;
  }

  /// 獲得済みバッジ数
  static int getAcquiredBadgeCount(UserStatusModel status) {
    return status.badgesAcquired.length;
  }

  /// 全バッジ数
  static int getTotalBadgeCount() {
    return badgeDefinitions.length;
  }
}
