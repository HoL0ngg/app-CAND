// lib/screens/main_shell.dart
import 'package:flutter/material.dart';

import 'profile_screens.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return AppBottomNavScaffold(
      currentIndex: 1,
      onLogout: onLogout,
      child: const Center(child: Text('Trang chủ - nội dung sẽ được thay sau')),
    );
  }
}
