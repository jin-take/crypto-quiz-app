import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'config/router.dart';
import 'data/datasources/local/hive_service.dart';
import 'l10n/app_localizations.dart';
import 'presentation/theme/app_theme.dart';
import 'providers/quiz_session_provider.dart';
import 'providers/ranking_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/user_state_provider.dart';
import 'service/analytics_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.initializeHive();

  try {
    await Firebase.initializeApp();
  } catch (_) {
    // Firebase 未設定でも動作できるようにする
  }

  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    try {
      await MobileAds.instance.initialize();
    } catch (_) {
      // Ads 未設定でも動作できるようにする
    }
  }

  final analyticsService = await AnalyticsService.initialize();

  runApp(MyApp(analyticsService: analyticsService));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.analyticsService});

  final AnalyticsService analyticsService;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SettingsProvider()..load(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserStateProvider(analyticsService: analyticsService),
        ),
        ChangeNotifierProvider(
          create: (context) => QuizSessionProvider(
            userStateProvider: context.read<UserStateProvider>(),
            analyticsService: analyticsService,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => RankingProvider(
            userStateProvider: context.read<UserStateProvider>(),
          ),
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          final isHighContrast = settings.isHighContrast;
          return MaterialApp.router(
            title: 'CryptoQuiz',
            debugShowCheckedModeBanner: false,
            theme:
                isHighContrast ? AppTheme.highContrastTheme : AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode:
                isHighContrast ? ThemeMode.light : settings.themeMode,
            locale: settings.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            builder: (context, child) {
              final mediaQuery = MediaQuery.of(context);
              return MediaQuery(
                data: mediaQuery.copyWith(
                  textScaleFactor:
                      mediaQuery.textScaleFactor *
                      settings.fontSizeMultiplier,
                ),
                child: child ?? const SizedBox.shrink(),
              );
            },
            routerConfig: goRouter,
          );
        },
      ),
    );
  }
}
