import '../data/models/index.dart';
import '../data/repositories/ranking_repository.dart';

class RankingService {
  RankingService({RankingRepository? rankingRepository})
      : _rankingRepository = rankingRepository ?? RankingRepository();

  final RankingRepository _rankingRepository;

  Future<List<RankingEntryModel>> getGlobalRanking({
    int limit = 100,
    int offset = 0,
  }) async {
    final rankings = await _rankingRepository.fetchGlobalRanking();
    final sorted = [...rankings]
      ..sort((a, b) => b.totalScore.compareTo(a.totalScore));
    for (int i = 0; i < sorted.length; i++) {
      sorted[i] = sorted[i].copyWith(rank: i + 1);
    }
    return sorted.skip(offset).take(limit).toList();
  }

  Future<int?> getUserRank({
    required String deviceId,
  }) async {
    final rankings = await _rankingRepository.fetchGlobalRanking();
    final sorted = [...rankings]
      ..sort((a, b) => b.totalScore.compareTo(a.totalScore));
    for (int i = 0; i < sorted.length; i++) {
      if (sorted[i].deviceId == deviceId) {
        return i + 1;
      }
    }
    return null;
  }
}
