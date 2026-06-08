import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/app_globals.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/router/route_names.dart';
import '../../data/session_storage.dart';
import '../../domain/entities/session_data.dart';
import '../../domain/session_config.dart';

enum SessionStatus { none, active, expired }

class SessionState {
  final SessionStatus status;

  /// Tiempo restante de inactividad antes del cierre automático.
  final Duration remaining;

  const SessionState({
    this.status = SessionStatus.none,
    this.remaining = Duration.zero,
  });

  bool get isActive => status == SessionStatus.active;

  /// Verdadero cuando queda poco tiempo y conviene avisar al usuario.
  bool get isWarning =>
      status == SessionStatus.active &&
      remaining <= SessionConfig.warningThreshold;

  SessionState copyWith({SessionStatus? status, Duration? remaining}) {
    return SessionState(
      status: status ?? this.status,
      remaining: remaining ?? this.remaining,
    );
  }
}

/// Controla el "timer de uso": si el usuario no interactúa con la app durante
/// [SessionConfig.inactivityTimeout], se considera inactivo, se cierra la
/// sesión y se borra el almacén encriptado.
class SessionViewModel extends StateNotifier<SessionState> {
  SessionViewModel(this._storage) : super(const SessionState());

  final SessionStorage _storage;
  Timer? _ticker;
  SessionData? _data;

  /// Inicia la sesión tras un login exitoso: genera el token, lo guarda junto
  /// con la variable de tiempo en el almacén encriptado y arranca el contador.
  Future<void> startSession() async {
    final now = DateTime.now();
    _data = SessionData(
      token: _generateToken(),
      inactivityTimeout: SessionConfig.inactivityTimeout,
      lastActivity: now,
    );
    await _storage.save(_data!);

    state = SessionState(
      status: SessionStatus.active,
      remaining: SessionConfig.inactivityTimeout,
    );
    _startTicker();
  }

  /// Registra una interacción del usuario y reinicia el tiempo de inactividad.
  void registerActivity() {
    final data = _data;
    if (data == null || state.status != SessionStatus.active) return;

    final now = DateTime.now();
    _data = data.copyWith(lastActivity: now);
    // Persistimos la nueva marca sin bloquear la interacción (fire-and-forget).
    unawaited(_storage.updateLastActivity(now));
    state = state.copyWith(remaining: data.inactivityTimeout);
  }

  /// Cierre de sesión manual (botón de salir).
  Future<void> logout() async {
    await _teardown();
    state = const SessionState(status: SessionStatus.none);
    appRouter.go(RouteNames.login);
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final data = _data;
    if (data == null) return;

    final remaining = data.remaining(DateTime.now());
    if (remaining == Duration.zero) {
      _expireByInactivity();
    } else {
      state = state.copyWith(remaining: remaining);
    }
  }

  /// Cierre automático por inactividad: limpia el almacén encriptado, regresa
  /// al login y avisa al usuario.
  Future<void> _expireByInactivity() async {
    await _teardown();
    state = const SessionState(status: SessionStatus.expired);

    appRouter.go(RouteNames.login);
    scaffoldMessengerKey.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'Tu sesión se cerró por inactividad. Vuelve a iniciar sesión.',
          ),
          backgroundColor: Color(0xFFFFA726),
        ),
      );
  }

  Future<void> _teardown() async {
    _ticker?.cancel();
    _ticker = null;
    _data = null;
    await _storage.clear();
  }

  /// Genera un token opaco aleatorio (criptográficamente seguro).
  String _generateToken() {
    final rnd = Random.secure();
    final bytes = List<int>.generate(32, (_) => rnd.nextInt(256));
    return base64Url.encode(bytes);
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}

final sessionViewModelProvider =
    StateNotifierProvider<SessionViewModel, SessionState>(
  (ref) => SessionViewModel(SessionStorage()),
);
