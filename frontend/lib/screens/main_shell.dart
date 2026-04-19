// lib/screens/main_shell.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  // Thêm Key cho mỗi màn hình để AnimatedSwitcher hoạt động chính xác
  final List<Widget> _screens = const [
    Center(key: Key('home'), child: Text('Trang chủ - nội dung sẽ được thay sau')),
    Center(key: Key('profile'), child: Text('Hồ sơ - nội dung sẽ được thay sau')),
    Center(key: Key('notifications'), child: Text('Thông báo - nội dung sẽ được thay sau')),
  ];

  void _onTabTapped(int index) {
    // Chỉ rung nếu index thực sự thay đổi
    if (_currentIndex != index) {
      HapticFeedback.lightImpact();
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Tối ưu: chỉ animation cho body thay vì toàn bộ Scaffold
    return Scaffold(
      appBar: AppBar(
        title: const Text('App CAND'),
        actions: [
          IconButton(
            onPressed: widget.onLogout,
            tooltip: 'Dang xuat',
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: _buildAnimatedBody(),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: InkRipple.splashFactory,
          highlightColor: Colors.transparent,
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: _onTabTapped,
          backgroundColor: colorScheme.surface,
          surfaceTintColor: colorScheme.primary.withValues(alpha: 0.1),
          indicatorColor: colorScheme.primaryContainer,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Hồ sơ',
            ),
            NavigationDestination(
              icon: Icon(Icons.notifications_outlined),
              selectedIcon: Icon(Icons.notifications),
              label: 'Thông báo',
            ),
          ],
        ),
      ),
    );
  }

  // body tách riêng có animation để code rõ ràng và dễ bảo trì
  Widget _buildAnimatedBody() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      builder: (context, opacity, child) {
        return Opacity(opacity: opacity, child: child);
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        // Đảm bảo AnimatedSwitcher nhận diện sự thay đổi nhờ key
        child: _screens[_currentIndex],
      ),
    );
  }
}