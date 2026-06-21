import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/app_globals.dart';
import 'features/mock_location/presentation/viewmodels/mock_location_viewmodel.dart';
import 'features/mock_location/presentation/views/mock_location_blocked_screen.dart';
import 'features/secure_data/data/fcm_service.dart';
import 'features/secure_data/data/secure_storage_service.dart';
import 'features/usb_debug/data/usb_debug_service.dart';
import 'features/usb_debug/presentation/usb_debug_blocked_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ===== RASP: Detección de Depuración USB  =====
  if (!kDebugMode) {
    final usbDebugging = await UsbDebugService.isUsbDebuggingEnabled();
    if (usbDebugging) {
      runApp(const UsbDebugBlockedApp());
      return; 
    }
  }
  
  WidgetsBinding.instance.addObserver(AppLifecycleSecurityObserver());
  

  // 1. Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // 2. Registrar handler de background (antes de runApp)
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

  // 3. Poblar datos sensibles automáticamente
  await SecureStorageService().seedDummyData();

  // 4. Iniciar FCM y obtener token del usuario
  final token = await FcmService().init();
  debugPrint('=== FCM TOKEN DE ESTE USUARIO ===');
  debugPrint(token);
  debugPrint('=================================');

  // 5. Lógica existente
  await _setSecureFlag();
  final status = await MockLocationViewModel.checkMockLocation();

  if (status.isMocked) {
    runApp(
      DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => const MockLocationBlockedScreen(),
      ),
    );
  } else {
    runApp(
      DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => const ProviderScope(child: CogniFitApp()),
      ),
    );
  }
}

Future<void> _setSecureFlag() async {
  const channel = MethodChannel('flutter/platform');
  try {
    await channel.invokeMethod('SystemNavigator.setSecureFlag', true);
  } catch (_) {}
}

class CogniFitApp extends StatelessWidget {
  const CogniFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CogniFit',
      theme: AppTheme.light,
      routerConfig: appRouter,
      scaffoldMessengerKey: scaffoldMessengerKey,
      // Integración con Device Preview: aplica idioma, tamaño y marco del
      // dispositivo simulado al árbol de la app.
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
    );
  }
}

// ===== RASP: Observador de Ciclo de Vida =====
class AppLifecycleSecurityObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // Si la app regresa al primer plano (resumed) y no estamos en modo debug
    if (state == AppLifecycleState.resumed && !kDebugMode) {
      final usbDebugging = await UsbDebugService.isUsbDebuggingEnabled();
      if (usbDebugging) {
        // Reemplaza toda la app con la pantalla de bloqueo en tiempo real
        runApp(const UsbDebugBlockedApp());
      }
    }
  }
}