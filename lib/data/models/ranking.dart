import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

@immutable
class RankingEntryModel {
  const RankingEntryModel({
    required this.rank,
    required this.deviceId,
    required this.totalScore,
    required this.quizzesSolved,
    required this.correctRate,
    required this.lastUpdated,
  });

  final int rank;
  final String deviceId;
  final int totalScore;
  final int quizzesSolved;
  final double correctRate;
  final DateTime lastUpdated;

  RankingEntryModel copyWith({
    int? rank,
    String? deviceId,
    int? totalScore,
    int? quizzesSolved,
    double? correctRate,
    DateTime? lastUpdated,
  }) {
    return RankingEntryModel(
      rank: rank ?? this.rank,
      deviceId: deviceId ?? this.deviceId,
      totalScore: totalScore ?? this.totalScore,
      quizzesSolved: quizzesSolved ?? this.quizzesSolved,
      correctRate: correctRate ?? this.correctRate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  factory RankingEntryModel.fromJson(Map<String, dynamic> json) {
    return RankingEntryModel(
      rank: json['rank'] as int,
      deviceId: json['device_id'] as String,
      totalScore: json['total_score'] as int,
      quizzesSolved: json['quizzes_solved'] as int,
      correctRate: _normalizeRate(json['correct_rate'] as num),
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );
  }

  static double _normalizeRate(num value) {
    final rate = value.toDouble();
    return rate <= 1 ? rate * 100 : rate;
  }

  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'device_id': deviceId,
      'total_score': totalScore,
      'quizzes_solved': quizzesSolved,
      'correct_rate': correctRate,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }
}

@immutable
class RankingCacheModel {
  RankingCacheModel({
    required List<RankingEntryModel> rankings,
    required this.cachedAt,
    required this.expiresAt,
  }) : rankings = List.unmodifiable(rankings);

  final List<RankingEntryModel> rankings;
  final DateTime cachedAt;
  final DateTime expiresAt;

  RankingCacheModel copyWith({
    List<RankingEntryModel>? rankings,
    DateTime? cachedAt,
    DateTime? expiresAt,
  }) {
    return RankingCacheModel(
      rankings: rankings ?? this.rankings,
      cachedAt: cachedAt ?? this.cachedAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}

@immutable
class GlobalRankingResponse {
  const GlobalRankingResponse({
    required this.version,
    required this.lastUpdated,
    required this.updateFrequency,
    required this.totalUsers,
    required this.rankings,
  });

  final String version;
  final DateTime lastUpdated;
  final String updateFrequency;
  final int totalUsers;
  final List<RankingEntryModel> rankings;

  factory GlobalRankingResponse.fromJson(Map<String, dynamic> json) {
    return GlobalRankingResponse(
      version: json['version'] as String,
      lastUpdated: DateTime.parse(json['last_updated'] as String),
      updateFrequency: json['update_frequency'] as String,
      totalUsers: json['total_users'] as int,
      rankings:
          (json['rankings'] as List<dynamic>)
              .map(
                (item) =>
                    RankingEntryModel.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
    );
  }
}

class RankingEntryModelAdapter extends TypeAdapter<RankingEntryModel> {
  @override
  final int typeId = 5;

  @override
  RankingEntryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++)
        reader.readByte(): reader.read(),
    };
    return RankingEntryModel(
      rank: fields[0] as int,
      deviceId: fields[1] as String,
      totalScore: fields[2] as int,
      quizzesSolved: fields[3] as int,
      correctRate: fields[4] as double,
      lastUpdated: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, RankingEntryModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.rank)
      ..writeByte(1)
      ..write(obj.deviceId)
      ..writeByte(2)
      ..write(obj.totalScore)
      ..writeByte(3)
      ..write(obj.quizzesSolved)
      ..writeByte(4)
      ..write(obj.correctRate)
      ..writeByte(5)
      ..write(obj.lastUpdated);
  }
}

class RankingCacheModelAdapter extends TypeAdapter<RankingCacheModel> {
  @override
  final int typeId = 6;

  @override
  RankingCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++)
        reader.readByte(): reader.read(),
    };
    return RankingCacheModel(
      rankings: (fields[0] as List).cast<RankingEntryModel>(),
      cachedAt: fields[1] as DateTime,
      expiresAt: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, RankingCacheModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.rankings)
      ..writeByte(1)
      ..write(obj.cachedAt)
      ..writeByte(2)
      ..write(obj.expiresAt);
  }
}
