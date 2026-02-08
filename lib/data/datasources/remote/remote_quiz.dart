import 'package:dio/dio.dart';
import '../../../config/app_config.dart';
import '../../models/index.dart';
import 'http_client.dart';

class QuizRemoteDataSource {
  QuizRemoteDataSource({HttpClient? client}) : _client = client ?? HttpClient.create();

  final HttpClient _client;

  Future<QuizManifestModel?> fetchManifest() async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        AppConfig.quizzesManifestPath,
      );
      if (response.data == null) {
        return null;
      }
      return QuizManifestModel.fromJson(response.data!);
    } on DioException {
      return null;
    }
  }

  Future<List<QuizModel>> fetchAllQuizzes() async {
    final response = await _client.get<Map<String, dynamic>>(
      AppConfig.quizzesAllPath,
    );
    final data = response.data ?? {};
    final quizzes = data['quizzes'] as List<dynamic>? ?? [];
    return quizzes
        .map((item) => QuizModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<QuizModel>> fetchQuizzesByDifficulty(String difficulty) async {
    final path = '${AppConfig.quizzesByDifficultyPath}/$difficulty.json';
    final response = await _client.get<Map<String, dynamic>>(path);
    final data = response.data ?? {};
    final quizzes = data['quizzes'] as List<dynamic>? ?? [];
    return quizzes
        .map((item) => QuizModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
