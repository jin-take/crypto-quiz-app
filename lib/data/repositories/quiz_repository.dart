import 'dart:convert';
import 'package:flutter/services.dart';
import '../datasources/local/local_quiz.dart';
import '../datasources/remote/remote_quiz.dart';
import '../models/index.dart';

class QuizRepository {
  QuizRepository({
    QuizLocalDataSource? local,
    QuizRemoteDataSource? remote,
  })  : _local = local ?? QuizLocalDataSource(),
        _remote = remote ?? QuizRemoteDataSource();

  final QuizLocalDataSource _local;
  final QuizRemoteDataSource _remote;

  Future<List<QuizModel>> fetchByDifficulty(String difficulty) async {
    final normalized = difficulty.toLowerCase();
    final cached = await _local.getQuizzesByDifficulty(normalized);
    final localVersion = cached?.version ?? await _local.getCacheVersion();

    try {
      final manifest = await _remote.fetchManifest();
      if (manifest != null &&
          (localVersion == null ||
              manifest.version != localVersion ||
              cached == null)) {
        final remoteQuizzes =
            await _remote.fetchQuizzesByDifficulty(normalized);
        await _local.cacheQuizzesByDifficulty(
          normalized,
          remoteQuizzes,
          manifest.version,
        );
        return remoteQuizzes;
      }
    } catch (_) {
      // ignore and fallback to cache/sample
    }

    if (cached != null) {
      return cached.quizzes;
    }

    return _loadSampleQuizzes(normalized);
  }

  Future<List<QuizModel>> fetchAll() async {
    final cached = await _local.getQuizzesFromCache('all');
    final localVersion = cached?.version;

    try {
      final manifest = await _remote.fetchManifest();
      if (manifest != null &&
          (localVersion == null || manifest.version != localVersion)) {
        final remoteQuizzes = await _remote.fetchAllQuizzes();
        await _local.cacheAllQuizzes(remoteQuizzes, manifest.version);
        return remoteQuizzes;
      }
    } catch (_) {
      // ignore
    }

    if (cached != null) {
      return cached.quizzes;
    }

    return _loadSampleQuizzes();
  }

  Future<List<QuizModel>> _loadSampleQuizzes([String? difficulty]) async {
    final data = await rootBundle.loadString('assets/sample/quizzes_all.json');
    final decoded = jsonDecode(data) as Map<String, dynamic>;
    final quizzes = (decoded['quizzes'] as List<dynamic>)
        .map((item) => QuizModel.fromJson(item as Map<String, dynamic>))
        .toList();

    if (difficulty == null) return quizzes;
    return quizzes
        .where((quiz) => quiz.difficulty.toLowerCase() == difficulty)
        .toList();
  }
}
