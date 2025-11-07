import 'package:rifstage_mobile/data/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  Future<User?> login(String email, String password) async {
    try {
      final response = await _authService.signIn(email, password);
      return response.user;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<User?> register(String email, String password, {String? name}) async {
    try {
      final response = await _authService.signUp(email, password);
      final user = response.user;

      if (user != null && name != null && name.isNotEmpty) {
        await Supabase.instance.client.from('profiles').insert({
          'id': user.id,
          'name': name,
          'email': email,
        });
      }

      return user; 
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _authService.signOut();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  User? get currentUser => _authService.currentUser;

  Stream<AuthState> get authStateChanges => _authService.authStateChanges;
}
