import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_state_provider.dart';
import '../../utils/extensions.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/badge_widget.dart';
import '../widgets/character_widget.dart';
import '../widgets/loading_indicator.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
      return const Scaffold(body: LoadingIndicator());
    }

    final status = userState.status!;
    final characterStatus = userState.characterStatus;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.profileTitle)),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${context.l10n.deviceId}: ${status.deviceId}'),
            const SizedBox(height: 12),
            CharacterWidget(
              status: characterStatus,
              totalScore: status.totalScore,
            ),
            const SizedBox(height: 16),
            _buildStats(context, status),
            const SizedBox(height: 16),
            Text(
              '${context.l10n.badges} (${status.badgesAcquired.length})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: status.badgesAcquired
                  .map((badge) => BadgeWidget(badge: badge))
                  .toList(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => userState.reset(),
              child: Text(context.l10n.resetData),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {
                // TODO: エクスポート処理
              },
              child: Text(context.l10n.export),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStats(BuildContext context, status) {
    return Row(
      children: [
        _StatCard(
          label: context.l10n.totalScore,
          value: '${status.totalScore}pt',
        ),
        _StatCard(
          label: context.l10n.quizzesSolved,
          value: '${status.quizzesSolved}',
        ),
        _StatCard(
          label: context.l10n.correctRate,
          value: '${status.correctRate.toStringAsFixed(1)}%',
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(label, style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: 4),
              Text(value, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}
