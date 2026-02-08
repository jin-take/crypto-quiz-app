import 'package:flutter/material.dart';
import '../data/models/index.dart';
import '../service/analytics_service.dart';
import '../service/quiz_service.dart';
import 'user_state_provider.dart';

class QuizSessionProvider extends ChangeNotifier {
  QuizSessionProvider({
    QuizService? quizService,
    AnalyticsService? analyticsService,
    required UserStateProvider userStateProvider,
  })  : _quizService = quizService ?? QuizService(),
        _analyticsService = analyticsService,
        _userStateProvider = userStateProvider;

  final QuizService _quizService;
  final AnalyticsService? _analyticsService;
  final UserStateProvider _userStateProvider;

  List<QuizModel> _quizzes = [];
  int _currentIndex = 0;
  bool _loading = false;
  String _difficulty = 'beginner';
  int? _selectedIndex;
  bool _answered = false;

  bool get loading => _loading;
  String get difficulty => _difficulty;
  int get currentIndex => _currentIndex;
  int get totalQuestions => _quizzes.length;
  QuizModel? get currentQuiz =>
      _quizzes.isNotEmpty ? _quizzes[_currentIndex] : null;
  bool get answered => _answered;
  int? get selectedIndex => _selectedIndex;
  bool get hasNext => _currentIndex + 1 < _quizzes.length;

  Future<void> startSession(String difficulty, {int questionCount = 10}) async {
    _loading = true;
    _difficulty = difficulty;
    _currentIndex = 0;
    _selectedIndex = null;
    _answered = false;
    notifyListeners();

    final quizzes =
        List<QuizModel>.from(await _quizService.getQuizzesByDifficulty(difficulty));
    if (quizzes.length > questionCount) {
      quizzes.shuffle();
      _quizzes = quizzes.take(questionCount).toList();
    } else {
      _quizzes = quizzes;
    }

    _loading = false;
    notifyListeners();

    await _analyticsService?.logEvent(
      name: 'quiz_started',
      parameters: {'difficulty': difficulty},
    );
  }

  Future<QuizResultData?> submitAnswer(int index) async {
    if (_answered) return null;
    final quiz = currentQuiz;
    if (quiz == null) return null;

    _selectedIndex = index;
    _answered = true;
    notifyListeners();

    final isCorrect = index == quiz.correctAnswerIndex;
    final outcome = await _userStateProvider.applyAnswer(
      quiz: quiz,
      isCorrect: isCorrect,
    );

    return QuizResultData(
      quiz: quiz,
      isCorrect: isCorrect,
      selectedIndex: index,
      pointsEarned: outcome.pointsEarned,
      totalScore: outcome.newTotalScore,
      newBadges: outcome.newBadges,
      characterStatus: outcome.characterStatus,
      leveledUp: outcome.leveledUp,
    );
  }

  void moveToNextQuestion() {
    if (!hasNext) return;
    _currentIndex += 1;
    _selectedIndex = null;
    _answered = false;
    notifyListeners();
  }

  void resetSession() {
    _quizzes = [];
    _currentIndex = 0;
    _selectedIndex = null;
    _answered = false;
    _loading = false;
    notifyListeners();
  }
}
