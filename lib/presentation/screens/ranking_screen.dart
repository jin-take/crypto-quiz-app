import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/ranking_provider.dart';
import '../../providers/user_state_provider.dart';
import '../../utils/extensions.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/ad_banner.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/ranking_item.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<UserStateProvider>().initialize();
        context.read<RankingProvider>().loadRanking();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final rankingProvider = context.watch<RankingProvider>();
    final userState = context.watch<UserStateProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.rankingTitle)),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      body: rankingProvider.loading
          ? const LoadingIndicator()
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${context.l10n.yourRank}: ${rankingProvider.userRank ?? '-'}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${context.l10n.score}: ${userState.status?.totalScore ?? 0}pt',
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: rankingProvider.rankings.length,
                      itemBuilder: (context, index) {
                        final entry = rankingProvider.rankings[index];
                        final highlight =
                            entry.deviceId == userState.deviceId;
                        return RankingItem(entry: entry, highlight: highlight);
                      },
                    ),
                  ),
                  const AdBannerPlaceholder(),
                ],
              ),
            ),
    );
  }
}
