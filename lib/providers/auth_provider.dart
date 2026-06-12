import 'package:flutter/foundation.dart';
import '../data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;
  String _currentPhone = '';

  AuthProvider({required AuthRepository authRepository})
      : _authRepository = authRepository;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get currentPhone => _currentPhone;

  Future<bool> sendCode(String phone) async {
    if (phone.isEmpty) {
      _errorMessage = 'Phone number cannot be empty';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _authRepository.sendCode(phone);
      if (success) {
        _currentPhone = phone;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Failed to send code';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Network error';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyOtp(String code) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _authRepository.verifyOtp(_currentPhone, code);
      if (success) {
        _isAuthenticated = true;
      } else {
        _errorMessage = 'Invalid code. Try 0000.';
      }
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = 'Network error';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _authRepository.logout();

    _isAuthenticated = false;
    _currentPhone = '';
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
