import 'package:flutter/material.dart';

import 'router/app_router.dart';
import 'services/auth_state.dart';
import 'theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthState _authState;
  late final RouterConfig<Object> _router;

  @override
  void initState() {
    super.initState();
    _authState = AuthState();
    _router = buildAppRouter(_authState);
  }

  @override
  void dispose() {
    _authState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'App CAND',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      routerConfig: _router,
    );
  }
}
