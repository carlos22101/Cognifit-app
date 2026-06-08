import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodels/session_viewmodel.dart';

/// Envuelve las pantallas autenticadas y detecta cualquier interacción del
/// usuario (toques, desplazamientos) para reiniciar el contador de inactividad.
///
/// Cuando deja de haber interacción durante el tiempo configurado, el
/// [SessionViewModel] cierra la sesión automáticamente.
class InactivityDetector extends ConsumerWidget {
  const InactivityDetector({super.key, required this.child});

  final Widget child;

  void _onActivity(WidgetRef ref) {
    ref.read(sessionViewModelProvider.notifier).registerActivity();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Listener(
      // translucent: no roba los eventos a los widgets hijos.
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _onActivity(ref),
      onPointerMove: (_) => _onActivity(ref),
      onPointerHover: (_) => _onActivity(ref),
      child: child,
    );
  }
}
