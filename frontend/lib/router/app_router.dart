import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/otp_screen.dart';
import '../screens/auth/qr_login_screen.dart';
import '../screens/main_shell.dart';
import '../screens/profile_screens.dart';
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
      GoRoute(
        path: '/app/profile',
        builder: (context, state) {
          return const ProfileScreen();
        },
      ),
      GoRoute(
        path: '/app/profile/edit',
        builder: (context, state) {
          return const EditProfileScreen();
        },
      ),
      GoRoute(
        path: '/app/profile/transfer',
        builder: (context, state) {
          return const TransferActivityScreen();
        },
      ),
      GoRoute(
        path: '/app/profile/transfer-history',
        builder: (context, state) {
          return const TransferHistoryScreen();
        },
      ),
      GoRoute(
        path: '/app/profile/transfer-history/detail',
        builder: (context, state) {
          return const TransferHistoryDetailScreen();
        },
      ),
      GoRoute(
        path: '/app/qr',
        builder: (context, state) {
          return const AppBottomNavScaffold(
            currentIndex: 2,
            child: Center(child: Text('Mã QR - nội dung sẽ được thay sau')),
          );
        },
      ),
    ],
  );
}
