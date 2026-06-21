import 'package:flutter/services.dart';

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
