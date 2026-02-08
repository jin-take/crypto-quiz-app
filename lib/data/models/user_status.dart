import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

@immutable
class BadgeModel {
  const BadgeModel({
    required this.id,
    required this.name,
    this.icon,
    required this.acquiredAt,
  });

  final String id;
  final String name;
  final String? icon;
  final DateTime acquiredAt;

  BadgeModel copyWith({
    String? id,
    String? name,
    String? icon,
    DateTime? acquiredAt,
  }) {
    return BadgeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      acquiredAt: acquiredAt ?? this.acquiredAt,
    );
  }

  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String?,
      acquiredAt: DateTime.parse(json['acquired_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'acquired_at': acquiredAt.toIso8601String(),
    };
  }
}

@immutable
class AnswerRecordModel {
  const AnswerRecordModel({
    required this.deviceId,
    required this.quizId,
    required this.difficulty,
    required this.isCorrect,
    required this.pointsEarned,
    required this.answeredAt,
    this.syncedToCloud = false,
  });

  final String deviceId;
  final String quizId;
  final String difficulty;
  final bool isCorrect;
  final int pointsEarned;
  final DateTime answeredAt;
  final bool syncedToCloud;

  AnswerRecordModel copyWith({
    String? deviceId,
    String? quizId,
    String? difficulty,
    bool? isCorrect,
    int? pointsEarned,
    DateTime? answeredAt,
    bool? syncedToCloud,
  }) {
    return AnswerRecordModel(
      deviceId: deviceId ?? this.deviceId,
      quizId: quizId ?? this.quizId,
      difficulty: difficulty ?? this.difficulty,
      isCorrect: isCorrect ?? this.isCorrect,
      pointsEarned: pointsEarned ?? this.pointsEarned,
      answeredAt: answeredAt ?? this.answeredAt,
      syncedToCloud: syncedToCloud ?? this.syncedToCloud,
    );
  }

  factory AnswerRecordModel.fromJson(Map<String, dynamic> json) {
    return AnswerRecordModel(
      deviceId: json['device_id'] as String? ?? '',
      quizId: json['quiz_id'] as String,
      difficulty: json['difficulty'] as String,
      isCorrect: json['is_correct'] as bool,
      pointsEarned: json['points_earned'] as int,
      answeredAt: DateTime.parse(json['answered_at'] as String),
      syncedToCloud: json['synced_to_cloud'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'device_id': deviceId,
      'quiz_id': quizId,
      'difficulty': difficulty,
      'is_correct': isCorrect,
      'points_earned': pointsEarned,
      'answered_at': answeredAt.toIso8601String(),
      'synced_to_cloud': syncedToCloud,
    };
  }
}

@immutable
class UserStatusModel {
  UserStatusModel({
    required this.deviceId,
    required this.totalScore,
    required this.quizzesSolved,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.correctRate,
    required this.characterLevel,
    required this.characterEvolutionProgress,
    required List<BadgeModel> badgesAcquired,
    required List<AnswerRecordModel> scoreHistory,
    required this.lastSynced,
  })  : badgesAcquired = List.unmodifiable(badgesAcquired),
        scoreHistory = List.unmodifiable(scoreHistory);

  final String deviceId;
  final int totalScore;
  final int quizzesSolved;
  final int correctAnswers;
  final int wrongAnswers;
  final double correctRate;
  final int characterLevel;
  final double characterEvolutionProgress;
  final List<BadgeModel> badgesAcquired;
  final List<AnswerRecordModel> scoreHistory;
  final DateTime lastSynced;

  UserStatusModel copyWith({
    String? deviceId,
    int? totalScore,
    int? quizzesSolved,
    int? correctAnswers,
    int? wrongAnswers,
    double? correctRate,
    int? characterLevel,
    double? characterEvolutionProgress,
    List<BadgeModel>? badgesAcquired,
    List<AnswerRecordModel>? scoreHistory,
    DateTime? lastSynced,
  }) {
    return UserStatusModel(
      deviceId: deviceId ?? this.deviceId,
      totalScore: totalScore ?? this.totalScore,
      quizzesSolved: quizzesSolved ?? this.quizzesSolved,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      wrongAnswers: wrongAnswers ?? this.wrongAnswers,
      correctRate: correctRate ?? this.correctRate,
      characterLevel: characterLevel ?? this.characterLevel,
      characterEvolutionProgress:
          characterEvolutionProgress ?? this.characterEvolutionProgress,
      badgesAcquired: badgesAcquired ?? this.badgesAcquired,
      scoreHistory: scoreHistory ?? this.scoreHistory,
      lastSynced: lastSynced ?? this.lastSynced,
    );
  }

  factory UserStatusModel.fromJson(Map<String, dynamic> json) {
    return UserStatusModel(
      deviceId: json['device_id'] as String,
      totalScore: json['total_score'] as int,
      quizzesSolved: json['quizzes_solved'] as int,
      correctAnswers: json['correct_answers'] as int,
      wrongAnswers: json['wrong_answers'] as int,
      correctRate: _normalizeRate(json['correct_rate'] as num),
      characterLevel: json['character_level'] as int,
      characterEvolutionProgress:
          (json['character_evolution_progress'] as num).toDouble(),
      badgesAcquired:
          (json['badges_acquired'] as List<dynamic>? ?? [])
              .map((item) => BadgeModel.fromJson(item as Map<String, dynamic>))
              .toList(),
      scoreHistory:
          (json['score_history'] as List<dynamic>? ?? [])
              .map(
                (item) => AnswerRecordModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList(),
      lastSynced: DateTime.parse(json['last_synced'] as String),
    );
  }

  static double _normalizeRate(num value) {
    final rate = value.toDouble();
    return rate <= 1 ? rate * 100 : rate;
  }

  Map<String, dynamic> toJson() {
    return {
      'device_id': deviceId,
      'total_score': totalScore,
      'quizzes_solved': quizzesSolved,
      'correct_answers': correctAnswers,
      'wrong_answers': wrongAnswers,
      'correct_rate': correctRate,
      'character_level': characterLevel,
      'character_evolution_progress': characterEvolutionProgress,
      'badges_acquired': badgesAcquired.map((badge) => badge.toJson()).toList(),
      'score_history':
          scoreHistory.map((record) => record.toJson()).toList(),
      'last_synced': lastSynced.toIso8601String(),
    };
  }
}

@immutable
class ScoreUpdateResult {
  const ScoreUpdateResult({
    required this.pointsEarned,
    required this.newTotalScore,
    required this.quizzesSolved,
    required this.correctAnswers,
    required this.correctRate,
  });

  final int pointsEarned;
  final int newTotalScore;
  final int quizzesSolved;
  final int correctAnswers;
  final double correctRate;
}

class BadgeModelAdapter extends TypeAdapter<BadgeModel> {
  @override
  final int typeId = 2;

  @override
  BadgeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++)
        reader.readByte(): reader.read(),
    };
    return BadgeModel(
      id: fields[0] as String,
      name: fields[1] as String,
      icon: fields[2] as String?,
      acquiredAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, BadgeModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.icon)
      ..writeByte(3)
      ..write(obj.acquiredAt);
  }
}

class AnswerRecordModelAdapter extends TypeAdapter<AnswerRecordModel> {
  @override
  final int typeId = 3;

  @override
  AnswerRecordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++)
        reader.readByte(): reader.read(),
    };
    return AnswerRecordModel(
      deviceId: fields[0] as String,
      quizId: fields[1] as String,
      difficulty: fields[2] as String,
      isCorrect: fields[3] as bool,
      pointsEarned: fields[4] as int,
      answeredAt: fields[5] as DateTime,
      syncedToCloud: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AnswerRecordModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.deviceId)
      ..writeByte(1)
      ..write(obj.quizId)
      ..writeByte(2)
      ..write(obj.difficulty)
      ..writeByte(3)
      ..write(obj.isCorrect)
      ..writeByte(4)
      ..write(obj.pointsEarned)
      ..writeByte(5)
      ..write(obj.answeredAt)
      ..writeByte(6)
      ..write(obj.syncedToCloud);
  }
}

class UserStatusModelAdapter extends TypeAdapter<UserStatusModel> {
  @override
  final int typeId = 4;

  @override
  UserStatusModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++)
        reader.readByte(): reader.read(),
    };
    return UserStatusModel(
      deviceId: fields[0] as String,
      totalScore: fields[1] as int,
      quizzesSolved: fields[2] as int,
      correctAnswers: fields[3] as int,
      wrongAnswers: fields[4] as int,
      correctRate: fields[5] as double,
      characterLevel: fields[6] as int,
      characterEvolutionProgress: fields[7] as double,
      badgesAcquired: (fields[8] as List).cast<BadgeModel>(),
      scoreHistory: (fields[9] as List).cast<AnswerRecordModel>(),
      lastSynced: fields[10] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserStatusModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.deviceId)
      ..writeByte(1)
      ..write(obj.totalScore)
      ..writeByte(2)
      ..write(obj.quizzesSolved)
      ..writeByte(3)
      ..write(obj.correctAnswers)
      ..writeByte(4)
      ..write(obj.wrongAnswers)
      ..writeByte(5)
      ..write(obj.correctRate)
      ..writeByte(6)
      ..write(obj.characterLevel)
      ..writeByte(7)
      ..write(obj.characterEvolutionProgress)
      ..writeByte(8)
      ..write(obj.badgesAcquired)
      ..writeByte(9)
      ..write(obj.scoreHistory)
      ..writeByte(10)
      ..write(obj.lastSynced);
  }
}
