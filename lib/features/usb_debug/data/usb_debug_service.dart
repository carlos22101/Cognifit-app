import 'package:flutter/services.dart';

/// Servicio RASP: consulta al sistema Android (vía MethodChannel) si la
/// Depuración USB (Settings.Global.ADB_ENABLED) está activa.
class UsbDebugService {
  static const _channel = MethodChannel('cognifit/security');

  /// Devuelve true si la Depuración USB está habilitada en el dispositivo.
  /// Ante cualquier error de canal, devuelve false (no bloquea por fallo técnico).
  static Future<bool> isUsbDebuggingEnabled() async {
    try {
      final result = await _channel.invokeMethod<bool>('isUsbDebuggingEnabled');
      return result ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }
}
