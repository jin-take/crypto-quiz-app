/// アプリケーション設定と定数を管理するクラス
class AppConfig {
  // アプリケーション情報
  static const String appName = 'CryptoQuiz';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // API/CDN 設定
  static const String cdnBaseUrl =
      'https://d1234567890.cloudfront.net'; // TODO: 実際の CloudFront URL に置き換え
  static const String s3BucketName = 'crypto-quiz-app'; // TODO: 実際のバケット名に置き換え

  // API エンドポイント
  static const String quizzesManifestPath = '/v1/quizzes/manifest.json';
  static const String quizzesAllPath = '/v1/quizzes/quizzes_all.json';
  static const String quizzesByDifficultyPath = '/v1/quizzes/by_difficulty';
  static const String globalRankingPath = '/v1/rankings/global_ranking.json';
  static const String userScoresPath = '/v1/user_scores';

  // タイムアウト設定
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);

  // キャッシュ設定
  static const Duration rankingCacheTTL = Duration(hours: 1);
  static const Duration quizCacheDurationUntilVersionChange =
      Duration(days: 365); // バージョン更新まで

  // スコア計算
  static const int beginnerPoints = 1;
  static const int intermediatePoints = 2;
  static const int advancedPoints = 3;

  // キャラクター進化レベル必要スコア
  static const Map<int, int> characterEvolutionThresholds = {
    1: 0,
    2: 50,
    3: 150,
    4: 300,
    5: 500,
  };

  // ローカル ストレージボックス名
  static const String hiveQuizzesBox = 'quizzes';
  static const String hiveUserStatusBox = 'user_status';
  static const String hiveAnswerRecordsBox = 'answer_records';
  static const String hiveRankingsBox = 'rankings';
  static const String hivePreferencesBox = 'app_preferences';

  // Firebase 設定
  static const String firebaseProjectId = 'crypto-quiz-app'; // TODO: 実際のプロジェクト ID に置き換え

  // Google Mobile Ads 設定
  static const String googleMobileAdsAppId =
      'ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy'; // TODO: 実際のアプリ ID に置き換え

  // デバッグ設定
  static const bool enableLogging = true;
  static const bool enableAnalytics = true;
  static const bool enableCrashlytics = true;
}
