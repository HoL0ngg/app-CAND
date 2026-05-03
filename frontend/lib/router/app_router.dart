import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/otp_screen.dart';
import '../screens/auth/qr_login_screen.dart';
import '../screens/main_shell.dart';
import '../services/auth_state.dart';

GoRouter buildAppRouter(AuthState authState) {
  return GoRouter(
    initialLocation: '/app',
    refreshListenable: authState,
    redirect: (BuildContext context, GoRouterState state) {
      final bool isOnAuth = state.matchedLocation.startsWith('/login');

      if (!authState.isLoggedIn && !isOnAuth) {
        return '/login';
      }

      if (authState.isLoggedIn && isOnAuth) {
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
        path: '/login/qr',
        builder: (context, state) {
          return const QrLoginScreen();
        },
      ),
      GoRoute(
        path: '/login/otp',
        builder: (context, state) {
          return const OtpScreen();
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
