import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

@immutable
class AppSettingsModel {
  const AppSettingsModel({
    required this.languageCode,
    required this.themeMode,
    required this.fontSizeMultiplier,
    this.enableNotifications = true,
    this.enableAnalytics = true,
    required this.lastUpdatedAt,
  });

  final String languageCode;
  final String themeMode;
  final double fontSizeMultiplier;
  final bool enableNotifications;
  final bool enableAnalytics;
  final DateTime lastUpdatedAt;

  AppSettingsModel copyWith({
    String? languageCode,
    String? themeMode,
    double? fontSizeMultiplier,
    bool? enableNotifications,
    bool? enableAnalytics,
    DateTime? lastUpdatedAt,
  }) {
    return AppSettingsModel(
      languageCode: languageCode ?? this.languageCode,
      themeMode: themeMode ?? this.themeMode,
      fontSizeMultiplier: fontSizeMultiplier ?? this.fontSizeMultiplier,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      enableAnalytics: enableAnalytics ?? this.enableAnalytics,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      languageCode: json['language_code'] as String,
      themeMode: json['theme_mode'] as String,
      fontSizeMultiplier: (json['font_size_multiplier'] as num).toDouble(),
      enableNotifications: json['enable_notifications'] as bool? ?? true,
      enableAnalytics: json['enable_analytics'] as bool? ?? true,
      lastUpdatedAt: DateTime.parse(json['last_updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language_code': languageCode,
      'theme_mode': themeMode,
      'font_size_multiplier': fontSizeMultiplier,
      'enable_notifications': enableNotifications,
      'enable_analytics': enableAnalytics,
      'last_updated_at': lastUpdatedAt.toIso8601String(),
    };
  }
}

class AppSettingsModelAdapter extends TypeAdapter<AppSettingsModel> {
  @override
  final int typeId = 7;

  @override
  AppSettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++)
        reader.readByte(): reader.read(),
    };
    return AppSettingsModel(
      languageCode: fields[0] as String,
      themeMode: fields[1] as String,
      fontSizeMultiplier: fields[2] as double,
      enableNotifications: fields[3] as bool,
      enableAnalytics: fields[4] as bool,
      lastUpdatedAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettingsModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.languageCode)
      ..writeByte(1)
      ..write(obj.themeMode)
      ..writeByte(2)
      ..write(obj.fontSizeMultiplier)
      ..writeByte(3)
      ..write(obj.enableNotifications)
      ..writeByte(4)
      ..write(obj.enableAnalytics)
      ..writeByte(5)
      ..write(obj.lastUpdatedAt);
  }
}
