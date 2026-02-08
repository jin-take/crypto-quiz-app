import 'package:dio/dio.dart';
import '../../../config/app_config.dart';
import '../../models/index.dart';
import 'http_client.dart';

class RankingRemoteDataSource {
  RankingRemoteDataSource({HttpClient? client})
      : _client = client ?? HttpClient.create();

  final HttpClient _client;

  Future<GlobalRankingResponse?> fetchGlobalRanking() async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        AppConfig.globalRankingPath,
      );
      final data = response.data;
      if (data == null) return null;
      return GlobalRankingResponse.fromJson(data);
    } on DioException {
      return null;
    }
  }
}
