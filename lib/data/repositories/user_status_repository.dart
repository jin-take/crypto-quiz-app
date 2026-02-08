import '../../config/app_config.dart';
import '../datasources/local/local_user_status.dart';
import '../datasources/remote/remote_user_status.dart';
import '../models/index.dart';

class UserStatusRepository {
  UserStatusRepository({
    UserStatusLocalDataSource? local,
    UserStatusRemoteDataSource? remote,
  })  : _local = local ?? UserStatusLocalDataSource(),
        _remote = remote ?? UserStatusRemoteDataSource();

  final UserStatusLocalDataSource _local;
  final UserStatusRemoteDataSource _remote;

  Future<UserStatusModel?> getUserStatus() => _local.getUserStatus();

  Future<void> saveUserStatus(UserStatusModel status) =>
      _local.saveUserStatus(status);

  Future<void> addAnswerRecord(AnswerRecordModel record) =>
      _local.addAnswerRecord(record);

  Future<List<AnswerRecordModel>> getUnsyncedRecords() =>
      _local.getUnsyncedRecords();

  Future<void> markRecordsAsSynced(List<String> quizIds) =>
      _local.markRecordsAsSynced(quizIds);

  Future<List<AnswerRecordModel>> getAllAnswerRecords() =>
      _local.getAllAnswerRecords();

  Future<void> reset() => _local.reset();

  Future<bool> uploadUserStatus(UserStatusModel status) =>
      _remote.uploadUserStatus(status);

  UserStatusModel createInitialStatus(String deviceId) {
    return UserStatusModel(
      deviceId: deviceId,
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
  }

  Future<void> syncIfNeeded(UserStatusModel status) async {
    if (!AppConfig.enableAnalytics) {
      return;
    }
    final unsynced = await _local.getUnsyncedRecords();
    if (unsynced.isEmpty) return;
    final success = await _remote.uploadUserStatus(status);
    if (success) {
      await _local.markRecordsAsSynced(
        unsynced.map((record) => record.quizId).toList(),
      );
    }
  }
}
