import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../domain/entities/session_data.dart';

/// Almacén encriptado para la sesión.
///
/// Usa [FlutterSecureStorage], que en Android respalda los datos con
/// EncryptedSharedPreferences (cifrado AES vía Android Keystore) y en iOS
/// con el Keychain. Aquí se guardan el token y la variable de tiempo de
/// inactividad, tal como pide la práctica.
class SessionStorage {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const _tokenKey = 'session_token';
  static const _timeoutKey = 'session_timeout_ms';
  static const _lastActivityKey = 'session_last_activity_ms';

  /// Guarda (o actualiza) los datos de la sesión en el almacén encriptado.
  Future<void> save(SessionData data) async {
    await _storage.write(key: _tokenKey, value: data.token);
    await _storage.write(
      key: _timeoutKey,
      value: data.inactivityTimeout.inMilliseconds.toString(),
    );
    await _storage.write(
      key: _lastActivityKey,
      value: data.lastActivity.millisecondsSinceEpoch.toString(),
    );
  }

  /// Actualiza únicamente la marca de la última interacción del usuario.
  Future<void> updateLastActivity(DateTime when) async {
    await _storage.write(
      key: _lastActivityKey,
      value: when.millisecondsSinceEpoch.toString(),
    );
  }

  /// Lee la sesión persistida, o `null` si no hay token guardado.
  Future<SessionData?> read() async {
    final token = await _storage.read(key: _tokenKey);
    if (token == null || token.isEmpty) return null;

    final timeoutRaw = await _storage.read(key: _timeoutKey);
    final lastActivityRaw = await _storage.read(key: _lastActivityKey);

    return SessionData(
      token: token,
      inactivityTimeout: Duration(
        milliseconds: int.tryParse(timeoutRaw ?? '') ?? 0,
      ),
      lastActivity: DateTime.fromMillisecondsSinceEpoch(
        int.tryParse(lastActivityRaw ?? '') ?? 0,
      ),
    );
  }

  /// Borra por completo la sesión del almacén encriptado (logout).
  Future<void> clear() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _timeoutKey);
    await _storage.delete(key: _lastActivityKey);
  }
}
