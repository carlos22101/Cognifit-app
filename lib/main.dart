import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _setSecureFlag();
  runApp(const ProviderScope(child: CogniFitApp()));
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
      debugShowCheckedModeBanner: false,
    );
  }
}