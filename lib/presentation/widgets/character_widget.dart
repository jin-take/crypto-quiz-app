import 'package:flutter/material.dart';
import '../../data/models/index.dart';
import '../../utils/extensions.dart';

class CharacterWidget extends StatelessWidget {
  const CharacterWidget({
    super.key,
    required this.status,
    required this.totalScore,
  });

  final CharacterStatus status;
  final int totalScore;

  @override
  Widget build(BuildContext context) {
    final nextLevelScore = status.nextLevelRequiredScore;
    final pointsNeeded =
        nextLevelScore == null ? 0 : nextLevelScore - totalScore;

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              status.emoji,
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 8),
            Text(
              '${context.l10n.characterLevel}: ${status.level}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: status.evolutionProgress),
            const SizedBox(height: 8),
            if (nextLevelScore != null)
              Text('${context.l10n.nextLevel}: $pointsNeeded pt'),
          ],
        ),
      ),
    );
  }
}
