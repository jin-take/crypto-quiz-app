import '../../../config/app_config.dart';
import '../../models/index.dart';
import 'hive_service.dart';

class QuizLocalDataSource {
  static const String _boxName = AppConfig.hiveQuizzesBox;

  Future<QuizCacheModel?> getQuizzesFromCache(String key) async {
    try {
      final box = HiveService.getBox<QuizCacheModel>(_boxName);
      final cacheModel = box.get(key);
      if (cacheModel == null) return null;
      if (DateTime.now().isAfter(cacheModel.expiresAt)) {
        await box.delete(key);
        return null;
      }
      return cacheModel;
    } catch (e) {
      return null;
    }
  }

  Future<QuizCacheModel?> getQuizzesByDifficulty(String difficulty) async {
    return getQuizzesFromCache('by_difficulty_$difficulty');
  }

  Future<void> cacheAllQuizzes(List<QuizModel> quizzes, String version) async {
    final box = HiveService.getBox<QuizCacheModel>(_boxName);
    final cacheModel = QuizCacheModel(
      version: version,
      quizzes: quizzes,
      cachedAt: DateTime.now(),
      expiresAt:
          DateTime.now().add(AppConfig.quizCacheDurationUntilVersionChange),
    );
    await box.put('all', cacheModel);
  }

  Future<void> cacheQuizzesByDifficulty(
    String difficulty,
    List<QuizModel> quizzes,
    String version,
  ) async {
    final box = HiveService.getBox<QuizCacheModel>(_boxName);
    final cacheModel = QuizCacheModel(
      version: version,
      quizzes: quizzes,
      cachedAt: DateTime.now(),
      expiresAt:
          DateTime.now().add(AppConfig.quizCacheDurationUntilVersionChange),
    );
    await box.put('by_difficulty_$difficulty', cacheModel);
  }

  Future<String?> getCacheVersion() async {
    final cacheModel = await getQuizzesFromCache('all');
    return cacheModel?.version;
  }

  Future<void> clearCache() async {
    final box = HiveService.getBox<QuizCacheModel>(_boxName);
    await box.clear();
  }
}
