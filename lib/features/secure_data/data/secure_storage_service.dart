import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  // 4 campos sensibles mapeados al reporte C2-A1
  static const kPerfilClinico = 'perfil_clinico_dislexia'; // Dato de Salud
  static const kDatosAlumno   = 'datos_personales_alumno'; // Dato Personal
  static const kTokenJwt      = 'token_jwt';               // Credencial
  static const kTextosAlumno  = 'textos_muestras_alumno';  // Salud/Personal

  static const sensitiveKeys = [
    kPerfilClinico, kDatosAlumno, kTokenJwt, kTextosAlumno,
  ];

  /// Pobla los campos de forma automática (datos demo)
  Future<void> seedDummyData() async {
    // Evita reescribir si ya hay datos
    if (await _storage.read(key: kTokenJwt) != null) return;

    await _storage.write(key: kPerfilClinico,
        value: '{"subtipo":"fonologica","severidad":"moderada","riesgo":"alto"}');
    await _storage.write(key: kDatosAlumno,
        value: '{"nombre":"Mateo González","grado":"3","grupo":"A","id":"s4"}');
    await _storage.write(key: kTokenJwt,
        value: 'eyJhbGciOiJIUzI1NiJ9.SEED.demo');
    await _storage.write(key: kTextosAlumno,
        value: '["el barco nabega","kasa con k","dictado 03"]');
  }

  Future<Map<String, String?>> readAll() async {
    final result = <String, String?>{};
    for (final k in sensitiveKeys) {
      result[k] = await _storage.read(key: k);
    }
    return result;
  }

  /// Borrado remoto: elimina SOLO los campos sensibles
  Future<void> wipeSensitiveData() async {
    for (final k in sensitiveKeys) {
      await _storage.delete(key: k);
    }
  }
}