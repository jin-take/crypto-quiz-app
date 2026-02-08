import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/models/index.dart';
import '../../providers/quiz_session_provider.dart';
import '../../utils/extensions.dart';
import '../widgets/badge_widget.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.data});

  final QuizResultData data;

  @override
  Widget build(BuildContext context) {
    final quizSession = context.watch<QuizSessionProvider>();
    final isCorrect = data.isCorrect;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.resultTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                isCorrect ? context.l10n.correct : context.l10n.incorrect,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(
                      color: isCorrect
                          ? Colors.green
                          : Theme.of(context).colorScheme.error,
                    ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              data.quiz.explanation,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (data.quiz.explanationImageUrl != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  data.quiz.explanationImageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ],
            const SizedBox(height: 16),
            _buildScoreInfo(context),
            const SizedBox(height: 12),
            if (data.newBadges.isNotEmpty) ...[
              Text(
                context.l10n.newBadge,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children:
                    data.newBadges.map((badge) => BadgeWidget(badge: badge)).toList(),
              ),
              const SizedBox(height: 12),
            ],
            if (data.leveledUp) ...[
              Text(
                context.l10n.levelUp,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '${data.characterStatus.emoji} Lv.${data.characterStatus.level}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: quizSession.hasNext
                        ? () {
                            quizSession.moveToNextQuestion();
                            context.pop();
                          }
                        : null,
                    child: Text(context.l10n.nextQuestion),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      quizSession.resetSession();
                      context.go('/');
                    },
                    child: Text(context.l10n.finish),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () {
                  quizSession.resetSession();
                  context.go('/');
                },
                child: Text(context.l10n.backHome),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${context.l10n.pointsGained}: +${data.pointsEarned}pt',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(
          '${context.l10n.totalScoreAfter}: ${data.totalScore}pt',
        ),
      ],
    );
  }
}
