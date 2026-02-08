import 'package:flutter/material.dart';
import '../data/models/index.dart';
import '../data/repositories/user_status_repository.dart';
import '../service/analytics_service.dart';
import '../service/badge_service.dart';
import '../service/character_service.dart';
import '../service/score_service.dart';
import '../utils/device_id.dart';

class AnswerOutcome {
  AnswerOutcome({
    required this.isCorrect,
    required this.pointsEarned,
    required this.newTotalScore,
    required this.newBadges,
    required this.characterStatus,
    required this.leveledUp,
  });

  final bool isCorrect;
  final int pointsEarned;
  final int newTotalScore;
  final List<BadgeModel> newBadges;
  final CharacterStatus characterStatus;
  final bool leveledUp;
}

class UserStateProvider extends ChangeNotifier {
  UserStateProvider({
    UserStatusRepository? repository,
    AnalyticsService? analyticsService,
    DeviceIdService? deviceIdService,
  })  : _repository = repository ?? UserStatusRepository(),
        _analyticsService = analyticsService,
        _deviceIdService = deviceIdService ?? DeviceIdService();

  final UserStatusRepository _repository;
  final AnalyticsService? _analyticsService;
  final DeviceIdService _deviceIdService;

  UserStatusModel? _status;
  bool _initialized = false;
  bool _loading = false;

  UserStatusModel? get status => _status;
  bool get initialized => _initialized;
  bool get loading => _loading;
  String get deviceId => _status?.deviceId ?? '';

  CharacterStatus get characterStatus {
    final score = _status?.totalScore ?? 0;
    return CharacterService.calculateCharacterStatus(score);
  }

  Future<void> initialize() async {
    if (_initialized) return;
    _loading = true;
    notifyListeners();

    final deviceId = await _deviceIdService.getOrCreateDeviceId();
    final savedStatus = await _repository.getUserStatus();
    _status = savedStatus ?? _repository.createInitialStatus(deviceId);
    await _repository.saveUserStatus(_status!);

    _initialized = true;
    _loading = false;
    notifyListeners();
  }

  Future<AnswerOutcome> applyAnswer({
    required QuizModel quiz,
    required bool isCorrect,
  }) async {
    if (_status == null) {
      await initialize();
    }
    final currentStatus = _status ?? _repository.createInitialStatus('');
    final updateResult = ScoreService.updateScore(
      currentStatus: currentStatus,
      quizId: quiz.id,
      difficulty: quiz.difficulty,
      isCorrect: isCorrect,
    );

    final newWrongAnswers =
        currentStatus.wrongAnswers + (isCorrect ? 0 : 1);
    final newRecord = AnswerRecordModel(
      deviceId: currentStatus.deviceId,
      quizId: quiz.id,
      difficulty: quiz.difficulty,
      isCorrect: isCorrect,
      pointsEarned: updateResult.pointsEarned,
      answeredAt: DateTime.now(),
    );

    var updatedStatus = currentStatus.copyWith(
      totalScore: updateResult.newTotalScore,
      quizzesSolved: updateResult.quizzesSolved,
      correctAnswers: updateResult.correctAnswers,
      wrongAnswers: newWrongAnswers,
      correctRate: updateResult.correctRate,
      scoreHistory: [...currentStatus.scoreHistory, newRecord],
      lastSynced: DateTime.now(),
    );

    final leveledUp = CharacterService.hasLeveledUp(
      currentStatus.totalScore,
      updatedStatus.totalScore,
    );

    updatedStatus = CharacterService.updateCharacterStatus(updatedStatus);

    final newBadges = BadgeService.checkNewBadges(
      currentStatus: updatedStatus,
      difficulty: quiz.difficulty,
      isCorrect: isCorrect,
    );

    if (newBadges.isNotEmpty) {
      updatedStatus = updatedStatus.copyWith(
        badgesAcquired: [...updatedStatus.badgesAcquired, ...newBadges],
      );
    }

    _status = updatedStatus;
    notifyListeners();

    await _repository.saveUserStatus(updatedStatus);
    await _repository.addAnswerRecord(newRecord);
    await _repository.syncIfNeeded(updatedStatus);

    await _analyticsService?.logEvent(
      name: 'quiz_completed',
      parameters: {
        'quiz_id': quiz.id,
        'difficulty': quiz.difficulty,
        'is_correct': isCorrect,
        'points_earned': updateResult.pointsEarned,
      },
    );

    if (newBadges.isNotEmpty) {
      await _analyticsService?.logEvent(
        name: 'badge_acquired',
        parameters: {
          'count': newBadges.length,
        },
      );
    }

    if (leveledUp) {
      await _analyticsService?.logEvent(
        name: 'character_evolved',
        parameters: {
          'new_level': updatedStatus.characterLevel,
        },
      );
    }

    return AnswerOutcome(
      isCorrect: isCorrect,
      pointsEarned: updateResult.pointsEarned,
      newTotalScore: updatedStatus.totalScore,
      newBadges: newBadges,
      characterStatus: CharacterService.calculateCharacterStatus(
        updatedStatus.totalScore,
      ),
      leveledUp: leveledUp,
    );
  }

  Future<void> reset() async {
    await _repository.reset();
    _status = null;
    _initialized = false;
    await initialize();
  }
}
