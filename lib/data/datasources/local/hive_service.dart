import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import '../../models/index.dart';

/// Hive ローカルストレージ管理サービス
class HiveService {
  static const String _encryptionKeyName = 'hive_encryption_key';
  static const _secureStorage = FlutterSecureStorage();

  /// Hive 初期化（アプリ起動時に呼び出し）
  static Future<void> initializeHive() async {
    try {
      // flutter_hive 初期化
      await Hive.initFlutter();

      // アダプタ登録
      _registerAdapters();

      // 暗号化キー取得または生成
      final encryptionKey = await _getOrCreateEncryptionKey();

      // ボックス初期化（暗号化）
      await _initializeBoxes(encryptionKey);

      print('✓ Hive 初期化完了');
    } catch (e) {
      print('✗ Hive 初期化エラー: $e');
      rethrow;
    }
  }

  /// アダプタ登録
  static void _registerAdapters() {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(QuizModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(QuizCacheModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(BadgeModelAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(AnswerRecordModelAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(UserStatusModelAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(RankingEntryModelAdapter());
    }
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(RankingCacheModelAdapter());
    }
    if (!Hive.isAdapterRegistered(7)) {
      Hive.registerAdapter(AppSettingsModelAdapter());
    }
  }

  /// 暗号化キーの取得または生成
  static Future<List<int>> _getOrCreateEncryptionKey() async {
    try {
      String? keyString = await _secureStorage.read(
        key: _encryptionKeyName,
      );

      if (keyString == null) {
        // キー未存在：新規生成
        final keyList = Hive.generateSecureKey();
        keyString = base64Encode(keyList);
        await _secureStorage.write(
          key: _encryptionKeyName,
          value: keyString,
        );
        print('✓ 新規暗号化キーを生成・保存');
      }

      return base64Decode(keyString);
    } catch (e) {
      print('✗ 暗号化キー取得エラー: $e');
      // 暗号化キーが利用不可の場合、非暗号化で初期化
      return Hive.generateSecureKey();
    }
  }

  /// ボックス初期化
  static Future<void> _initializeBoxes(List<int> encryptionKey) async {
    // Quizzes ボックス
    if (!Hive.isBoxOpen('quizzes')) {
      await Hive.openBox<QuizCacheModel>(
        'quizzes',
        encryptionCipher: HiveAesCipher(encryptionKey),
      );
    }

    // User Status ボックス
    if (!Hive.isBoxOpen('user_status')) {
      await Hive.openBox<UserStatusModel>(
        'user_status',
        encryptionCipher: HiveAesCipher(encryptionKey),
      );
    }

    // Answer Records ボックス
    if (!Hive.isBoxOpen('answer_records')) {
      await Hive.openBox<AnswerRecordModel>(
        'answer_records',
        encryptionCipher: HiveAesCipher(encryptionKey),
      );
    }

    // Rankings ボックス
    if (!Hive.isBoxOpen('rankings')) {
      await Hive.openBox<RankingCacheModel>(
        'rankings',
        encryptionCipher: HiveAesCipher(encryptionKey),
      );
    }

    // App Preferences ボックス
    if (!Hive.isBoxOpen('app_preferences')) {
      await Hive.openBox<AppSettingsModel>(
        'app_preferences',
        encryptionCipher: HiveAesCipher(encryptionKey),
      );
    }

    print('✓ 全ボックス初期化完了');
  }

  /// ボックスの取得
  static Box<T> getBox<T>(String boxName) {
    if (!Hive.isBoxOpen(boxName)) {
      throw HiveError('Box "$boxName" が開かれていません');
    }
    return Hive.box<T>(boxName);
  }

  /// Hive クリーンアップ（テスト時など）
  static Future<void> closeAll() async {
    await Hive.close();
  }

  /// Hive をリセット（デバッグ用）
  static Future<void> resetAll() async {
    await Hive.deleteFromDisk();
    print('✓ Hive データをクリア');
  }
}
