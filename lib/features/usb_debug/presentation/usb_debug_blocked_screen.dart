import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UsbDebugBlockedApp extends StatelessWidget {
  const UsbDebugBlockedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _BlockedScaffold(),
    );
  }
}

class _BlockedScaffold extends StatefulWidget {
  const _BlockedScaffold();

  @override
  State<_BlockedScaffold> createState() => _BlockedScaffoldState();
}

class _BlockedScaffoldState extends State<_BlockedScaffold> {
  @override
  void initState() {
    super.initState();
    // Muestra el diálogo persistente apenas se monta la pantalla.
    WidgetsBinding.instance.addPostFrameCallback((_) => _showBlockingDialog());
  }

  Future<void> _showBlockingDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false, // no se cierra al tocar fuera
      builder: (_) => PopScope(
        canPop: false, // no se cierra con el botón "atrás"
        child: AlertDialog(
          icon: const Icon(Icons.gpp_bad_rounded,
              color: Color(0xFFEF5350), size: 48),
          title: const Text('Acceso bloqueado por seguridad'),
          content: const Text(
            'Se detectó que la Depuración USB (USB Debugging) está activa en '
            'tu dispositivo.\n\n'
            'Por políticas de seguridad, CogniFit no puede ejecutarse en un '
            'entorno que permite depuración, ya que expone la aplicación a '
            'análisis dinámico e ingeniería inversa.\n\n'
            'Para continuar:\n'
            '1. Ve a Ajustes → Opciones de desarrollador.\n'
            '2. Desactiva la "Depuración por USB".\n'
            '3. Vuelve a abrir la aplicación.',
          ),
          actions: [
            FilledButton(
              onPressed: _closeApp,
              child: const Text('Cerrar aplicación'),
            ),
          ],
        ),
      ),
    );
  }

  void _closeApp() {
    SystemNavigator.pop(); 
    exit(0); 
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF5F7FF),
      body: Center(
        child: Icon(Icons.lock_outline_rounded,
            size: 64, color: Color(0xFF8A8AA8)),
      ),
    );
  }
}