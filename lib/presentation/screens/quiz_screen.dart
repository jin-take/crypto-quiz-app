import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/models/index.dart';
import '../../providers/quiz_session_provider.dart';
import '../../utils/extensions.dart';
import '../theme/dimensions.dart';
import '../widgets/loading_indicator.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.difficulty});

  final String difficulty;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final provider = context.read<QuizSessionProvider>();
      if (provider.totalQuestions == 0 ||
          provider.difficulty != widget.difficulty) {
        provider.startSession(widget.difficulty, questionCount: 10);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final quizSession = context.watch<QuizSessionProvider>();

    if (quizSession.loading) {
      return const Scaffold(body: LoadingIndicator());
    }

    final quiz = quizSession.currentQuiz;
    if (quiz == null) {
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.appTitle)),
        body: Center(child: Text(context.l10n.errorLoading)),
      );
    }

    final progress = (quizSession.currentIndex + 1) /
        (quizSession.totalQuestions == 0 ? 1 : quizSession.totalQuestions);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.quizProgress(
          quizSession.currentIndex + 1,
          quizSession.totalQuestions,
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: context.isTablet
            ? Row(
                children: [
                  Expanded(
                    child: _QuestionPane(
                      quiz: quiz,
                      progress: progress,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _OptionsPane(
                      quiz: quiz,
                      onSelect: (index) => _handleAnswer(index, quizSession),
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(value: progress),
                  const SizedBox(height: 16),
                  Text(
                    quiz.question,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _OptionsPane(
                      quiz: quiz,
                      onSelect: (index) => _handleAnswer(index, quizSession),
                    ),
                  ),
                  Text(
                    context.l10n.tapToAnswer,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _handleAnswer(
    int index,
    QuizSessionProvider quizSession,
  ) async {
    final result = await quizSession.submitAnswer(index);
    if (!mounted || result == null) return;
    context.go('/quiz/${widget.difficulty}/result', extra: result);
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Card(
        child: ListTile(
          title: Text(label),
          onTap: onTap,
        ),
      ),
    );
  }
}

class _QuestionPane extends StatelessWidget {
  const _QuestionPane({
    required this.quiz,
    required this.progress,
  });

  final QuizModel quiz;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(value: progress),
        const SizedBox(height: 16),
        Text(
          quiz.question,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Text(
          context.l10n.tapToAnswer,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _OptionsPane extends StatelessWidget {
  const _OptionsPane({
    required this.quiz,
    required this.onSelect,
  });

  final QuizModel quiz;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: quiz.options.length,
      itemBuilder: (context, index) {
        final option = quiz.options[index];
        return _OptionTile(
          label: option,
          onTap: () => onSelect(index),
        );
      },
    );
  }
}
