import 'package:go_router/go_router.dart';
import 'route_names.dart';
import '../../features/auth/presentation/views/login_screen.dart';
import '../../features/teacher/presentation/views/group_screen.dart';

import '../../features/session/presentation/views/inactivity_detector.dart';


import '../../features/secure_data/presentation/secure_data_screen.dart';

final appRouter = GoRouter(
  initialLocation: RouteNames.login,
  routes: [
    GoRoute(
      path: RouteNames.login,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: LoginScreen(),
      ),
    ),
    GoRoute(
      path: RouteNames.teacherGroup,
      pageBuilder: (context, state) => const NoTransitionPage(
        // Detecta la interacción del usuario para reiniciar el contador de
        // inactividad mientras navega por las pantallas autenticadas.
        child: InactivityDetector(child: GroupScreen()),
      ),
    ),
    GoRoute(
      path: RouteNames.secureData,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: SecureDataScreen(),
      ),
    ),
  ],
);
