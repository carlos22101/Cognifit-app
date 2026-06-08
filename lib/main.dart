import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:device_preview/device_preview.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/app_globals.dart';
import 'features/mock_location/presentation/viewmodels/mock_location_viewmodel.dart';
import 'features/mock_location/presentation/views/mock_location_blocked_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
