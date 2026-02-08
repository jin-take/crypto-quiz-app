import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

@immutable
class QuizModel {
  QuizModel({
    required this.id,
    required this.category,
    required this.difficulty,
    required this.question,
    required List<String> options,
    required this.correctAnswerIndex,
    required this.explanation,
    this.explanationImageUrl,
    required List<String> tags,
    required this.pointWeight,
    required this.createdAt,
    required this.updatedAt,
  })  : options = List.unmodifiable(options),
        tags = List.unmodifiable(tags);

  final String id;
  final String category;
  final String difficulty;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;
  final String? explanationImageUrl;
  final List<String> tags;
  final int pointWeight;
  final DateTime createdAt;
  final DateTime updatedAt;

  QuizModel copyWith({
    String? id,
    String? category,
    String? difficulty,
    String? question,
    List<String>? options,
    int? correctAnswerIndex,
    String? explanation,
    String? explanationImageUrl,
    List<String>? tags,
    int? pointWeight,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return QuizModel(
      id: id ?? this.id,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      question: question ?? this.question,
      options: options ?? this.options,
      correctAnswerIndex: correctAnswerIndex ?? this.correctAnswerIndex,
      explanation: explanation ?? this.explanation,
      explanationImageUrl: explanationImageUrl ?? this.explanationImageUrl,
      tags: tags ?? this.tags,
      pointWeight: pointWeight ?? this.pointWeight,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'] as String,
      category: json['category'] as String,
      difficulty: json['difficulty'] as String,
      question: json['question'] as String,
      options: (json['options'] as List<dynamic>).cast<String>(),
      correctAnswerIndex: json['correct_answer_index'] as int,
      explanation: json['explanation'] as String,
      explanationImageUrl: json['explanation_image_url'] as String?,
      tags: (json['tags'] as List<dynamic>).cast<String>(),
      pointWeight: json['point_weight'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'difficulty': difficulty,
      'question': question,
      'options': options,
      'correct_answer_index': correctAnswerIndex,
      'explanation': explanation,
      'explanation_image_url': explanationImageUrl,
      'tags': tags,
      'point_weight': pointWeight,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

@immutable
class QuizCacheModel {
  QuizCacheModel({
    required this.version,
    required List<QuizModel> quizzes,
    required this.cachedAt,
    required this.expiresAt,
  }) : quizzes = List.unmodifiable(quizzes);

  final String version;
  final List<QuizModel> quizzes;
  final DateTime cachedAt;
  final DateTime expiresAt;

  QuizCacheModel copyWith({
    String? version,
    List<QuizModel>? quizzes,
    DateTime? cachedAt,
    DateTime? expiresAt,
  }) {
    return QuizCacheModel(
      version: version ?? this.version,
      quizzes: quizzes ?? this.quizzes,
      cachedAt: cachedAt ?? this.cachedAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  factory QuizCacheModel.fromJson(Map<String, dynamic> json) {
    return QuizCacheModel(
      version: json['version'] as String,
      quizzes:
          (json['quizzes'] as List<dynamic>)
              .map((item) => QuizModel.fromJson(item as Map<String, dynamic>))
              .toList(),
      cachedAt: DateTime.parse(json['cached_at'] as String),
      expiresAt: DateTime.parse(json['expires_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'quizzes': quizzes.map((quiz) => quiz.toJson()).toList(),
      'cached_at': cachedAt.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
    };
  }
}

@immutable
class QuizManifestModel {
  const QuizManifestModel({
    required this.version,
    required this.schemaVersion,
    required this.lastUpdated,
    required this.totalQuizzes,
    required this.byDifficulty,
    required this.byCategory,
  });

  final String version;
  final String schemaVersion;
  final DateTime lastUpdated;
  final int totalQuizzes;
  final Map<String, int> byDifficulty;
  final Map<String, int> byCategory;

  factory QuizManifestModel.fromJson(Map<String, dynamic> json) {
    return QuizManifestModel(
      version: json['version'] as String,
      schemaVersion: json['schema_version'] as String,
      lastUpdated: DateTime.parse(json['last_updated'] as String),
      totalQuizzes: json['total_quizzes'] as int,
      byDifficulty:
          (json['by_difficulty'] as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, value as int)),
      byCategory:
          (json['by_category'] as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, value as int)),
    );
  }
}

class QuizModelAdapter extends TypeAdapter<QuizModel> {
  @override
  final int typeId = 0;

  @override
  QuizModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++)
        reader.readByte(): reader.read(),
    };
    return QuizModel(
      id: fields[0] as String,
      category: fields[1] as String,
      difficulty: fields[2] as String,
      question: fields[3] as String,
      options: (fields[4] as List).cast<String>(),
      correctAnswerIndex: fields[5] as int,
      explanation: fields[6] as String,
      explanationImageUrl: fields[7] as String?,
      tags: (fields[8] as List).cast<String>(),
      pointWeight: fields[9] as int,
      createdAt: fields[10] as DateTime,
      updatedAt: fields[11] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, QuizModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.difficulty)
      ..writeByte(3)
      ..write(obj.question)
      ..writeByte(4)
      ..write(obj.options)
      ..writeByte(5)
      ..write(obj.correctAnswerIndex)
      ..writeByte(6)
      ..write(obj.explanation)
      ..writeByte(7)
      ..write(obj.explanationImageUrl)
      ..writeByte(8)
      ..write(obj.tags)
      ..writeByte(9)
      ..write(obj.pointWeight)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt);
  }
}

class QuizCacheModelAdapter extends TypeAdapter<QuizCacheModel> {
  @override
  final int typeId = 1;

  @override
  QuizCacheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++)
        reader.readByte(): reader.read(),
    };
    return QuizCacheModel(
      version: fields[0] as String,
      quizzes: (fields[1] as List).cast<QuizModel>(),
      cachedAt: fields[2] as DateTime,
      expiresAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, QuizCacheModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.version)
      ..writeByte(1)
      ..write(obj.quizzes)
      ..writeByte(2)
      ..write(obj.cachedAt)
      ..writeByte(3)
      ..write(obj.expiresAt);
  }
}
