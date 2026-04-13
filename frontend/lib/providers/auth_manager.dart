import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Thêm thư viện

class AuthManager extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = false;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  // Khởi tạo: App vừa mở lên là gọi hàm kiểm tra Token ngay
  AuthManager() {
    _checkToken();
  }

  // Hàm quét bộ nhớ xem có Token không
  Future<void> _checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token');
    
    // Nếu token tồn tại -> cho phép đăng nhập luôn
    if (token != null && token.isNotEmpty) {
      _isLoggedIn = true;
      notifyListeners(); 
    }
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    // Giả lập gọi API mất 2 giây
    await Future.delayed(const Duration(seconds: 2));

    if (username == 'admin' && password == '123456') {
      // 1. Lưu Token giả lập vào bộ nhớ máy
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_token', 'day_la_token_cua_admin_123'); 

      // 2. Bật trạng thái
      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners(); 
      return true;
    } else {
      _isLoading = false;
      notifyListeners();
      return false; 
    }
  }

  Future<void> logout() async {
    // 1. Xóa sạch Token khỏi bộ nhớ máy
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token');

    // 2. Tắt trạng thái
    _isLoggedIn = false;
    notifyListeners(); 
  }
}