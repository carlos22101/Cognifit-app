import 'package:flutter/material.dart';

/// Clave global del ScaffoldMessenger para poder mostrar avisos (SnackBars)
/// desde capas que no tienen un BuildContext, como el SessionViewModel cuando
/// cierra la sesión por inactividad.
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
