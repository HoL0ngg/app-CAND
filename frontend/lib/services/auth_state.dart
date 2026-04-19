import 'package:flutter/foundation.dart';

class AuthState extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void signIn() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void signOut() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
