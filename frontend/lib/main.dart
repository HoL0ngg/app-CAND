import 'package:flutter/material.dart';
import 'router/app_router.dart';
import 'services/auth_state.dart';
import 'theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = AuthState();
    final router = buildAppRouter(authState);

    return MaterialApp.router(
      title: 'App CAND',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      routerConfig: router,
    );
  }
}
