import 'package:flutter/material.dart';

class LoginController extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Simular llamada a API
      await Future.delayed(const Duration(seconds: 2));

      // Validaciones básicas
      if (email.isEmpty || password.isEmpty) {
        _errorMessage = 'Por favor, complete todos los campos';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (!email.contains('@')) {
        _errorMessage = 'Por favor, ingrese un email válido';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (password.length < 6) {
        _errorMessage = 'La contraseña debe tener al menos 6 caracteres';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Simular autenticación exitosa
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
} 