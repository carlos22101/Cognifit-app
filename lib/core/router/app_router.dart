import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';
import '../../features/auth/presentation/views/login_screen.dart';
import '../../features/teacher/presentation/views/group_screen.dart';

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
        child: GroupScreen(),
      ),
    ),
  ],
);
