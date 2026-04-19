import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/auth/login_screen.dart';
import '../screens/main_shell.dart';
import '../services/auth_state.dart';

GoRouter buildAppRouter(AuthState authState) {
  return GoRouter(
    initialLocation: '/app',
    refreshListenable: authState,
    redirect: (BuildContext context, GoRouterState state) {
      final bool isOnLogin = state.matchedLocation == '/login';

      if (!authState.isLoggedIn && !isOnLogin) {
        return '/login';
      }

      if (authState.isLoggedIn && isOnLogin) {
        return '/app';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) {
          return LoginScreen(onLogin: authState.signIn);
        },
      ),
      GoRoute(
        path: '/app',
        builder: (context, state) {
          return MainShell(onLogout: authState.signOut);
        },
      ),
    ],
  );
}
