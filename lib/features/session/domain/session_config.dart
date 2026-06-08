/// Configuración del cierre de sesión por inactividad.
class SessionConfig {
  /// Tiempo de inactividad permitido ("X minutos") antes de cerrar la sesión.
  ///
  /// Si el usuario no interactúa con la app durante este lapso se considera
  /// inactivo y la sesión se cierra automáticamente.
  static const Duration inactivityTimeout = Duration(seconds: 5);

  /// Umbral a partir del cual se muestra el aviso de "la sesión está por
  /// cerrarse" en la barra de estado de la pantalla.
  static const Duration warningThreshold = Duration(seconds: 2);
}
