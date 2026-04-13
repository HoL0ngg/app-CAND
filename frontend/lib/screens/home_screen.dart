import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../routes/app_router.dart'; // Để gọi authManager

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Màn hình chính'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authManager.logout(); 
            },
          )
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.go('/detail/42'); 
          },
          child: const Text('Xem chi tiết bài viết 42'),
        ),
      ),
    );
  }
}