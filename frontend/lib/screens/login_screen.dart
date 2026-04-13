import 'package:flutter/material.dart';
import '../routes/app_router.dart'; // Để gọi authManager

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng nhập')),
      body: Center(
        child: ElevatedButton(
          onPressed: authManager.isLoading
              ? null
              : () async {
                  final success = await authManager.login('admin', '123456');
                  if (!success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sai tài khoản hoặc mật khẩu!')),
                    );
                  }
                },
          child: authManager.isLoading
              ? const CircularProgressIndicator()
              : const Text('Đăng nhập (admin / 123456)'),
        ),
      ),
    );
  }
}