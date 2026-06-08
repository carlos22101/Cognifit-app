/// Datos de la sesión activa que se persisten en el almacén encriptado.
///
/// - [token]: token de autenticación generado al iniciar sesión.
/// - [inactivityTimeout]: "variable de tiempo" de inactividad permitida.
/// - [lastActivity]: marca de tiempo de la última interacción del usuario.
class SessionData {
  final String token;
  final Duration inactivityTimeout;
  final DateTime lastActivity;

  const SessionData({
    required this.token,
    required this.inactivityTimeout,
    required this.lastActivity,
  });

  /// Tiempo restante antes de que la sesión se considere inactiva,
  /// calculado a partir de la última actividad registrada.
  Duration remaining(DateTime now) {
    final elapsed = now.difference(lastActivity);
    final left = inactivityTimeout - elapsed;
    return left.isNegative ? Duration.zero : left;
  }

  /// Indica si la sesión ya superó el tiempo de inactividad permitido.
  bool isExpired(DateTime now) => remaining(now) == Duration.zero;

  SessionData copyWith({
    String? token,
    Duration? inactivityTimeout,
    DateTime? lastActivity,
  }) {
    return SessionData(
      token: token ?? this.token,
      inactivityTimeout: inactivityTimeout ?? this.inactivityTimeout,
      lastActivity: lastActivity ?? this.lastActivity,
    );
  }
}
