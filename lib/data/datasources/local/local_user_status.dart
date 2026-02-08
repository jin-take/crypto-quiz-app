import '../../../config/app_config.dart';
import '../../models/index.dart';
import 'hive_service.dart';

class UserStatusLocalDataSource {
  static const String _statusKey = 'current_user';

  Future<UserStatusModel?> getUserStatus() async {
    try {
      final box = HiveService.getBox<UserStatusModel>(
        AppConfig.hiveUserStatusBox,
      );
      return box.get(_statusKey);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveUserStatus(UserStatusModel status) async {
    final box = HiveService.getBox<UserStatusModel>(
      AppConfig.hiveUserStatusBox,
    );
    await box.put(_statusKey, status);
  }

  Future<void> addAnswerRecord(AnswerRecordModel record) async {
    final box = HiveService.getBox<AnswerRecordModel>(
      AppConfig.hiveAnswerRecordsBox,
    );
    final key = '${record.quizId}_${record.answeredAt.millisecondsSinceEpoch}';
    await box.put(key, record);
  }

  Future<List<AnswerRecordModel>> getUnsyncedRecords() async {
    final box = HiveService.getBox<AnswerRecordModel>(
      AppConfig.hiveAnswerRecordsBox,
    );
    return box.values.where((record) => !record.syncedToCloud).toList();
  }

  Future<void> markRecordsAsSynced(List<String> quizIds) async {
    final box = HiveService.getBox<AnswerRecordModel>(
      AppConfig.hiveAnswerRecordsBox,
    );

    for (final key in box.keys) {
      final record = box.get(key);
      if (record != null && quizIds.contains(record.quizId)) {
        await box.put(key, record.copyWith(syncedToCloud: true));
      }
    }
  }

  Future<List<AnswerRecordModel>> getAllAnswerRecords() async {
    final box = HiveService.getBox<AnswerRecordModel>(
      AppConfig.hiveAnswerRecordsBox,
    );
    return box.values.toList();
  }

  Future<void> reset() async {
    final box = HiveService.getBox<UserStatusModel>(
      AppConfig.hiveUserStatusBox,
    );
    await box.clear();

    final answerBox = HiveService.getBox<AnswerRecordModel>(
      AppConfig.hiveAnswerRecordsBox,
    );
    await answerBox.clear();
  }
}
