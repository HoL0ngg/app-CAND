import '../../../core/network/api_client.dart';

class AuthApi {
  const AuthApi(this._apiClient);

  final ApiClient _apiClient;

  Future<void> signIn({
    required String username,
    required String password,
  }) async {
    await _apiClient.post<Map<String, dynamic>>(
      '/auth/login',
      data: <String, String>{'username': username, 'password': password},
    );
  }
}
