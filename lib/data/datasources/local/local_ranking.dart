import '../../../config/app_config.dart';
import '../../models/index.dart';
import 'hive_service.dart';

class RankingLocalDataSource {
  static const String _cacheKey = 'global_ranking';

  Future<RankingCacheModel?> getCache() async {
    final box = HiveService.getBox<RankingCacheModel>(
      AppConfig.hiveRankingsBox,
    );
    final cache = box.get(_cacheKey);
    if (cache == null) return null;
    if (DateTime.now().isAfter(cache.expiresAt)) {
      await box.delete(_cacheKey);
      return null;
    }
    return cache;
  }

  Future<void> saveCache(List<RankingEntryModel> rankings) async {
    final box = HiveService.getBox<RankingCacheModel>(
      AppConfig.hiveRankingsBox,
    );
    final cache = RankingCacheModel(
      rankings: rankings,
      cachedAt: DateTime.now(),
      expiresAt: DateTime.now().add(AppConfig.rankingCacheTTL),
    );
    await box.put(_cacheKey, cache);
  }

  Future<void> clear() async {
    final box = HiveService.getBox<RankingCacheModel>(
      AppConfig.hiveRankingsBox,
    );
    await box.clear();
  }
}
