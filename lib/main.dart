import 'package:flutter/material.dart';
import 'screens/main_shell.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App CAND',
      debugShowCheckedModeBanner: false,
      home: const MainShell(), //không cần truyền child
    );
  }
}