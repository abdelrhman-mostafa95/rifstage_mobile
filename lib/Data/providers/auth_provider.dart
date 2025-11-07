import 'package:flutter/material.dart';
import 'package:rifstage_mobile/data/repositories/auth_repo.dart';
import 'package:rifstage_mobile/data/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthUserProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository(AuthService());

  User? _user;
  bool _isLoading = false;
  bool _isInitialized = false; // ✅ تم إضافته

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  bool get isInitialized => _isInitialized; // ✅ Getter جديد

  AuthUserProvider() {
    _initializeUser();
    _authRepository.authStateChanges.listen((event) {
      _user = event.session?.user;
      if (_user != null) {
        _saveUserLocally(_user!);
      } else {
        _clearLocalUser();
      }
      notifyListeners();
    });
  }

  /// تحميل المستخدم المحفوظ محلياً عند بداية التطبيق
  Future<void> _initializeUser() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUserId = prefs.getString('user_id');
    debugPrint('📦 Loaded user_id: $savedUserId');

    if (savedUserId != null) {
      _user = _authRepository.currentUser;
    }

    _isInitialized = true; // ✅ بعد الانتهاء من التحميل
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _authRepository.login(email, password);
      _user = _authRepository.currentUser;

      if (_user != null) {
        await _saveUserLocally(_user!);
      }
    } catch (e) {
      debugPrint('Login error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String email, String password, {String? name}) async {
    try {
      _isLoading = true;
      notifyListeners();

      final user = await _authRepository.register(email, password);
      _user = user;
      await _saveUserLocally(user!);
    } catch (e) {
      debugPrint('Register error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository.logout();
      _user = null;
      await _clearLocalUser();
      notifyListeners();
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }

  /// حفظ بيانات المستخدم محلياً
  Future<void> _saveUserLocally(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', user.id);
    await prefs.setString('user_email', user.email ?? '');
    debugPrint('✅ User saved locally: ${user.email}');
  }

  /// حذف بيانات المستخدم من الذاكرة المحلية
  Future<void> _clearLocalUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('user_email');
  }
}
