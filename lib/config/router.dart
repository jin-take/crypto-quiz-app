import 'package:go_router/go_router.dart';
import '../data/models/index.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/profile_screen.dart';
import '../presentation/screens/quiz_screen.dart';
import '../presentation/screens/ranking_screen.dart';
import '../presentation/screens/result_screen.dart';
import '../presentation/screens/settings_screen.dart';

/// アプリケーション全体のルーティングを管理する GoRouter 設定
final goRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'quiz/:difficulty',
          name: 'quiz',
          builder: (context, state) {
            final difficulty = state.pathParameters['difficulty']!;
            return QuizScreen(difficulty: difficulty);
          },
          routes: [
            GoRoute(
              path: 'result',
              name: 'result',
              builder: (context, state) {
                final data = state.extra as QuizResultData;
                return ResultScreen(data: data);
              },
            ),
          ],
        ),
        GoRoute(
          path: 'ranking',
          name: 'ranking',
          builder: (context, state) => const RankingScreen(),
        ),
        GoRoute(
          path: 'profile',
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: 'settings',
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => const HomeScreen(),
);
