import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_manager.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/detail_screen.dart';

final authManager = AuthManager();

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  refreshListenable: authManager, 
  
  redirect: (context, state) {
    final isLoggedIn = authManager.isLoggedIn;
    final isGoingToLogin = state.matchedLocation == '/login';

    if (!isLoggedIn && !isGoingToLogin) return '/login';
    if (isLoggedIn && isGoingToLogin) return '/';
    return null;
  },

  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'detail/:id', 
          builder: (context, state) {
            final itemId = state.pathParameters['id']!; 
            return DetailScreen(id: itemId);
          },
        ),
      ],
    ),
    // THÊM MỚI: Màn hình Profile đang làm dở theo yêu cầu Task
    GoRoute(
      path: '/profile',
      builder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(
          child: Text('Đang làm', style: TextStyle(fontSize: 24)),
        ),
      ),
    ),
  ],
);