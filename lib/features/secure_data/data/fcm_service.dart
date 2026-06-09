import 'package:firebase_messaging/firebase_messaging.dart';
import 'secure_storage_service.dart';

const String kWipeCommand = 'WIPE_USER_DATA';

@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  print('========================================');
  print('MENSAJE RECIBIDO EN BACKGROUND');
  print('Data: ${message.data}');
  print('========================================');

  await _handleWipeIfMatch(message);
}

Future<void> _handleWipeIfMatch(RemoteMessage message) async {
  print('========================================');
  print('FCM RECIBIDO');
  print('Data: ${message.data}');
  print('Notification: ${message.notification?.title}');
  print('========================================');

  if (message.data['command'] == kWipeCommand) {
    print('===== INICIANDO WIPE =====');

    await SecureStorageService().wipeSensitiveData();

    print('===== WIPE COMPLETADO =====');
  } else {
    print('===== COMANDO NO RECONOCIDO =====');
    print('Comando recibido: ${message.data['command']}');
  }
}

class FcmService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<String?> init() async {
    // Solicitar permisos
    final settings = await _messaging.requestPermission();

    print('========================================');
    print('PERMISOS FCM');
    print('AuthorizationStatus: ${settings.authorizationStatus}');
    print('========================================');

    // Obtener token del dispositivo
    final token = await _messaging.getToken();

    print('========================================');
    print('FCM TOKEN DE ESTE USUARIO');
    print(token);
    print('========================================');

    // App abierta (foreground)
    FirebaseMessaging.onMessage.listen((message) {
      print('===== MENSAJE EN FOREGROUND =====');
      _handleWipeIfMatch(message);
    });

    // Usuario abre la app desde la notificación
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('===== APP ABIERTA DESDE NOTIFICACION =====');
      _handleWipeIfMatch(message);
    });

    return token;
  }
}