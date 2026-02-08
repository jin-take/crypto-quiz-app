import 'package:dio/dio.dart';
import '../../../config/app_config.dart';
import '../../models/index.dart';
import 'http_client.dart';

class UserStatusRemoteDataSource {
  UserStatusRemoteDataSource({HttpClient? client})
      : _client = client ?? HttpClient.create();

  final HttpClient _client;

  Future<bool> uploadUserStatus(UserStatusModel status) async {
    final path = '${AppConfig.userScoresPath}/${status.deviceId}/status.json';
    try {
      await _client.put<Map<String, dynamic>>(path, data: status.toJson());
      return true;
    } on DioException {
      return false;
    }
  }
}
