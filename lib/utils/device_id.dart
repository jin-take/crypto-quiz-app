import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class DeviceIdService {
  static const String _deviceIdKey = 'device_id';
  final FlutterSecureStorage _storage;
  final Uuid _uuid;

  DeviceIdService({
    FlutterSecureStorage? storage,
    Uuid? uuid,
  })  : _storage = storage ?? const FlutterSecureStorage(),
        _uuid = uuid ?? const Uuid();

  Future<String> getOrCreateDeviceId() async {
    try {
      final existing = await _storage.read(key: _deviceIdKey);
      if (existing != null && existing.isNotEmpty) {
        return existing;
      }
      final newId = _uuid.v4();
      await _storage.write(key: _deviceIdKey, value: newId);
      return newId;
    } catch (_) {
      return _uuid.v4();
    }
  }
}
