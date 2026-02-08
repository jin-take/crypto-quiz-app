import 'package:flutter/material.dart';
import '../data/models/index.dart';
import '../service/ranking_service.dart';
import 'user_state_provider.dart';

class RankingProvider extends ChangeNotifier {
  RankingProvider({
    RankingService? rankingService,
    required UserStateProvider userStateProvider,
  })  : _rankingService = rankingService ?? RankingService(),
        _userStateProvider = userStateProvider;

  final RankingService _rankingService;
  final UserStateProvider _userStateProvider;

  List<RankingEntryModel> _rankings = [];
  bool _loading = false;
  int? _userRank;

  List<RankingEntryModel> get rankings => _rankings;
  bool get loading => _loading;
  int? get userRank => _userRank;

  Future<void> loadRanking() async {
    _loading = true;
    notifyListeners();

    await _userStateProvider.initialize();

    _rankings = await _rankingService.getGlobalRanking(limit: 100, offset: 0);
    _userRank = await _rankingService.getUserRank(
      deviceId: _userStateProvider.deviceId,
    );

    _loading = false;
    notifyListeners();
  }
}
