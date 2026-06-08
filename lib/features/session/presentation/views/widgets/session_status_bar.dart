import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../viewmodels/session_viewmodel.dart';

/// Indicador del estado de la sesión: muestra el tiempo restante de
/// inactividad y permite cerrar sesión manualmente.
class SessionStatusBar extends ConsumerWidget {
  const SessionStatusBar({super.key});

  String _format(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionViewModelProvider);
    if (!session.isActive) return const SizedBox.shrink();

    final warning = session.isWarning;
    final accent = warning ? AppColors.riskRed : AppColors.primary;
    final bg = warning ? AppColors.riskRedBg : AppColors.primaryLight;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            warning ? Icons.timer_outlined : Icons.lock_clock_rounded,
            color: accent,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              warning
                  ? 'Tu sesión se cerrará en ${_format(session.remaining)}'
                  : 'Sesión activa · cierre por inactividad en ${_format(session.remaining)}',
              style: TextStyle(
                color: accent,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => ref.read(sessionViewModelProvider.notifier).logout(),
            child: Row(
              children: [
                Icon(Icons.logout_rounded, color: accent, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Salir',
                  style: TextStyle(
                    color: accent,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
