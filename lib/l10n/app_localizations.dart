import 'package:flutter/widgets.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [
    Locale('ja'),
    Locale('en'),
  ];

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'ja': {
      'app_title': 'CryptoQuiz',
      'home': 'ホーム',
      'greeting': 'こんにちは！',
      'start_quiz': 'クイズ開始',
      'difficulty_beginner': '初級',
      'difficulty_intermediate': '中級',
      'difficulty_advanced': '上級',
      'difficulty_beginner_hint': '初心者向け',
      'difficulty_intermediate_hint': '経験者向け',
      'difficulty_advanced_hint': 'マスター向け',
      'points_per_question': '{points}pt/問',
      'total_score': '累計スコア',
      'correct_rate': '正答率',
      'quizzes_solved': '解答数',
      'character_level': 'レベル',
      'next_level': '次のレベルまで',
      'quiz_progress': '問題 {current}/{total}',
      'tap_to_answer': 'タップして回答してください',
      'result_title': '結果',
      'correct': '正解！',
      'incorrect': '不正解',
      'points_gained': '獲得ポイント',
      'total_score_after': '累計スコア',
      'new_badge': '新しいバッジ獲得！',
      'level_up': 'レベルアップ！',
      'next_question': '次の問題',
      'finish': '終了',
      'back_home': 'ホーム画面へ',
      'ranking_title': 'ランキング',
      'your_rank': 'あなたの順位',
      'score': 'スコア',
      'profile_title': 'プロフィール',
      'device_id': 'デバイスID',
      'badges': '獲得バッジ',
      'reset_data': 'データをリセット',
      'export': 'エクスポート',
      'settings_title': '設定',
      'language': '言語',
      'theme': 'テーマ',
      'theme_light': 'ライト',
      'theme_dark': 'ダーク',
      'theme_system': 'システム',
      'theme_high_contrast': '高コントラスト',
      'font_size': 'フォントサイズ',
      'notifications': '通知',
      'analytics': 'アナリティクス',
      'loading': '読み込み中...',
      'error_loading': '読み込みに失敗しました',
      'retry': '再試行',
    },
    'en': {
      'app_title': 'CryptoQuiz',
      'home': 'Home',
      'greeting': 'Hello!',
      'start_quiz': 'Start Quiz',
      'difficulty_beginner': 'Beginner',
      'difficulty_intermediate': 'Intermediate',
      'difficulty_advanced': 'Advanced',
      'difficulty_beginner_hint': 'For starters',
      'difficulty_intermediate_hint': 'For experienced',
      'difficulty_advanced_hint': 'For masters',
      'points_per_question': '{points}pt/question',
      'total_score': 'Total Score',
      'correct_rate': 'Correct Rate',
      'quizzes_solved': 'Solved',
      'character_level': 'Level',
      'next_level': 'Next Level',
      'quiz_progress': 'Question {current}/{total}',
      'tap_to_answer': 'Tap to answer',
      'result_title': 'Result',
      'correct': 'Correct!',
      'incorrect': 'Incorrect',
      'points_gained': 'Points',
      'total_score_after': 'Total Score',
      'new_badge': 'New Badge!',
      'level_up': 'Level Up!',
      'next_question': 'Next',
      'finish': 'Finish',
      'back_home': 'Back Home',
      'ranking_title': 'Ranking',
      'your_rank': 'Your Rank',
      'score': 'Score',
      'profile_title': 'Profile',
      'device_id': 'Device ID',
      'badges': 'Badges',
      'reset_data': 'Reset Data',
      'export': 'Export',
      'settings_title': 'Settings',
      'language': 'Language',
      'theme': 'Theme',
      'theme_light': 'Light',
      'theme_dark': 'Dark',
      'theme_system': 'System',
      'theme_high_contrast': 'High Contrast',
      'font_size': 'Font Size',
      'notifications': 'Notifications',
      'analytics': 'Analytics',
      'loading': 'Loading...',
      'error_loading': 'Failed to load',
      'retry': 'Retry',
    },
  };

  String _value(String key) =>
      _localizedValues[locale.languageCode]?[key] ??
      _localizedValues['en']![key]!;

  String get appTitle => _value('app_title');
  String get home => _value('home');
  String get greeting => _value('greeting');
  String get startQuiz => _value('start_quiz');
  String get difficultyBeginner => _value('difficulty_beginner');
  String get difficultyIntermediate => _value('difficulty_intermediate');
  String get difficultyAdvanced => _value('difficulty_advanced');
  String get difficultyBeginnerHint => _value('difficulty_beginner_hint');
  String get difficultyIntermediateHint =>
      _value('difficulty_intermediate_hint');
  String get difficultyAdvancedHint => _value('difficulty_advanced_hint');
  String get totalScore => _value('total_score');
  String get correctRate => _value('correct_rate');
  String get quizzesSolved => _value('quizzes_solved');
  String get characterLevel => _value('character_level');
  String get nextLevel => _value('next_level');
  String get tapToAnswer => _value('tap_to_answer');
  String get resultTitle => _value('result_title');
  String get correct => _value('correct');
  String get incorrect => _value('incorrect');
  String get pointsGained => _value('points_gained');
  String get totalScoreAfter => _value('total_score_after');
  String get newBadge => _value('new_badge');
  String get levelUp => _value('level_up');
  String get nextQuestion => _value('next_question');
  String get finish => _value('finish');
  String get backHome => _value('back_home');
  String get rankingTitle => _value('ranking_title');
  String get yourRank => _value('your_rank');
  String get score => _value('score');
  String get profileTitle => _value('profile_title');
  String get deviceId => _value('device_id');
  String get badges => _value('badges');
  String get resetData => _value('reset_data');
  String get export => _value('export');
  String get settingsTitle => _value('settings_title');
  String get language => _value('language');
  String get theme => _value('theme');
  String get themeLight => _value('theme_light');
  String get themeDark => _value('theme_dark');
  String get themeSystem => _value('theme_system');
  String get themeHighContrast => _value('theme_high_contrast');
  String get fontSize => _value('font_size');
  String get notifications => _value('notifications');
  String get analytics => _value('analytics');
  String get loading => _value('loading');
  String get errorLoading => _value('error_loading');
  String get retry => _value('retry');

  String pointsPerQuestion(int points) =>
      _value('points_per_question').replaceAll('{points}', '$points');

  String quizProgress(int current, int total) =>
      _value('quiz_progress')
          .replaceAll('{current}', '$current')
          .replaceAll('{total}', '$total');
}

class AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales
        .any((supported) => supported.languageCode == locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
