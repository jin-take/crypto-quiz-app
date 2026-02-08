import 'dart:convert';
import 'package:flutter/services.dart';
import '../datasources/local/local_ranking.dart';
import '../datasources/remote/remote_ranking.dart';
import '../models/index.dart';

class RankingRepository {
  RankingRepository({
    RankingLocalDataSource? local,
    RankingRemoteDataSource? remote,
  })  : _local = local ?? RankingLocalDataSource(),
        _remote = remote ?? RankingRemoteDataSource();

  final RankingLocalDataSource _local;
  final RankingRemoteDataSource _remote;

  Future<List<RankingEntryModel>> fetchGlobalRanking() async {
    final cached = await _local.getCache();
    if (cached != null) {
      return cached.rankings;
    }

    final remote = await _remote.fetchGlobalRanking();
    if (remote != null) {
      await _local.saveCache(remote.rankings);
      return remote.rankings;
    }

    return _loadSampleRanking();
  }

  Future<List<RankingEntryModel>> _loadSampleRanking() async {
    final data =
        await rootBundle.loadString('assets/sample/global_ranking.json');
    final decoded = jsonDecode(data) as Map<String, dynamic>;
    final rankings = (decoded['rankings'] as List<dynamic>)
        .map((item) => RankingEntryModel.fromJson(item as Map<String, dynamic>))
        .toList();
    return rankings;
  }
}
