import 'package:flutter/material.dart';

class RegisterController extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  bool _registrationSuccess = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get registrationSuccess => _registrationSuccess;

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _registrationSuccess = false;
    notifyListeners();

    try {
      if (password != confirmPassword) {
        _errorMessage = 'Las contraseñas no coinciden';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Simular registro
      await Future.delayed(const Duration(seconds: 2));
      
      // Aquí iría la lógica real de registro
      _registrationSuccess = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Error al registrar el usuario';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
} 