import 'package:firebase_messaging/firebase_messaging.dart';
import 'secure_storage_service.dart';

const String kWipeCommand = 'WIPE_USER_DATA';

@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  print('===== FCM BACKGROUND: ${message.data} =====');
  await _handleWipeIfMatch(message);
}

Future<void> _handleWipeIfMatch(RemoteMessage message) async {
  print('===== FCM RECIBIDO: ${message.data} =====');

  if (message.data['command'] != kWipeCommand) {
    print('===== COMANDO NO RECONOCIDO: ${message.data['command']} =====');
    return;
  }

  // El wipe debe ser ESPECÍFICO para este usuario, no general:
  // se exige que el targetUserId del mensaje coincida con el usuario local.
  final target = message.data['targetUserId'];
  final currentUser = await SecureStorageService().userId();

  if (target == null || target != currentUser) {
    print('===== WIPE IGNORADO: destinado a "$target", este usuario es "$currentUser" =====');
    return;
  }

  print('===== INICIANDO WIPE para usuario $currentUser =====');
  await SecureStorageService().wipeSensitiveData();
  print('===== WIPE COMPLETADO =====');
}

class FcmService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<String?> init() async {
    final settings = await _messaging.requestPermission();
    print('===== PERMISOS FCM: ${settings.authorizationStatus} =====');

    final token = await _messaging.getToken();
    print('===== FCM TOKEN DE ESTE USUARIO =====');
    print(token);
    print('=====================================');

    // App abierta (foreground)
    FirebaseMessaging.onMessage.listen(_handleWipeIfMatch);

    // Usuario abre la app desde la notificación
    FirebaseMessaging.onMessageOpenedApp.listen(_handleWipeIfMatch);

    return token;
  }
}
