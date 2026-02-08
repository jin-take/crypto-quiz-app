import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/models/index.dart';
import '../../presentation/theme/app_theme.dart';
import '../../providers/quiz_session_provider.dart';
import '../../providers/user_state_provider.dart';
import '../../utils/extensions.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/ad_banner.dart';
import '../widgets/character_widget.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/quiz_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<UserStateProvider>().initialize();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<UserStateProvider>();
    if (!userState.initialized || userState.loading) {
      return const Scaffold(
        body: LoadingIndicator(),
      );
    }

    final status = userState.status!;
    final characterStatus = userState.characterStatus;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appTitle),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.greeting,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            CharacterWidget(
              status: characterStatus,
              totalScore: status.totalScore,
            ),
            const SizedBox(height: 16),
            _buildStats(context, status),
            const SizedBox(height: 16),
            Text(
              context.l10n.startQuiz,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            QuizCard(
              title: context.l10n.difficultyBeginner,
              subtitle: context.l10n.difficultyBeginnerHint,
              pointsText: context.l10n.pointsPerQuestion(1),
              color: AppTheme.beginnerColor,
              onTap: () => _startQuiz('beginner'),
            ),
            QuizCard(
              title: context.l10n.difficultyIntermediate,
              subtitle: context.l10n.difficultyIntermediateHint,
              pointsText: context.l10n.pointsPerQuestion(2),
              color: AppTheme.intermediateColor,
              onTap: () => _startQuiz('intermediate'),
            ),
            QuizCard(
              title: context.l10n.difficultyAdvanced,
              subtitle: context.l10n.difficultyAdvancedHint,
              pointsText: context.l10n.pointsPerQuestion(3),
              color: AppTheme.advancedColor,
              onTap: () => _startQuiz('advanced'),
            ),
            const SizedBox(height: 12),
            const AdBannerPlaceholder(),
          ],
        ),
      ),
    );
  }

  Widget _buildStats(BuildContext context, UserStatusModel status) {
    final items = [
      _StatItem(context.l10n.totalScore, '${status.totalScore}pt'),
      _StatItem(
        context.l10n.correctRate,
        '${status.correctRate.toStringAsFixed(1)}%',
      ),
      _StatItem(context.l10n.quizzesSolved, '${status.quizzesSolved}'),
    ];

    return Row(
      children: items
          .map(
            (item) => Expanded(
              child: Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Text(
                        item.label,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.value,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Future<void> _startQuiz(String difficulty) async {
    await context
        .read<QuizSessionProvider>()
        .startSession(difficulty, questionCount: 10);
    if (!mounted) return;
    context.go('/quiz/$difficulty');
  }
}

class _StatItem {
  _StatItem(this.label, this.value);
  final String label;
  final String value;
}
