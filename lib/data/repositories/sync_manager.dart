import '../models/index.dart';
import 'user_status_repository.dart';

class SyncManager {
  SyncManager({UserStatusRepository? userStatusRepository})
      : _userStatusRepository =
            userStatusRepository ?? UserStatusRepository();

  final UserStatusRepository _userStatusRepository;

  Future<bool> syncUserStatus(UserStatusModel status) async {
    try {
      final unsynced = await _userStatusRepository.getUnsyncedRecords();
      if (unsynced.isEmpty) return true;
      final success = await _userStatusRepository.uploadUserStatus(status);
      if (success) {
        await _userStatusRepository.markRecordsAsSynced(
          unsynced.map((record) => record.quizId).toList(),
        );
      }
      return success;
    } catch (_) {
      return false;
    }
  }
}
