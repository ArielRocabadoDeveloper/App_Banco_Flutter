import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _error;
  bool _isLoading = false;

  bool get isAuthenticated => _isAuthenticated;
  String? get error => _error;
  bool get isLoading => _isLoading;

  // Iniciar sesión
  Future<void> login(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Simular llamada a API
      await Future.delayed(const Duration(seconds: 2));

      // Validaciones básicas
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Por favor, complete todos los campos');
      }

      if (!email.contains('@')) {
        throw Exception('Por favor, ingrese un email válido');
      }

      if (password.length < 6) {
        throw Exception('La contraseña debe tener al menos 6 caracteres');
      }

      // Simular autenticación exitosa
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cerrar sesión
  Future<void> logout() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simular llamada a API
      await Future.delayed(const Duration(milliseconds: 500));

      _isAuthenticated = false;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Registrar usuario
  Future<void> register(String email, String password, String confirmPassword) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Simular llamada a API
      await Future.delayed(const Duration(seconds: 2));

      // Validaciones básicas
      if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
        throw Exception('Por favor, complete todos los campos');
      }

      if (!email.contains('@')) {
        throw Exception('Por favor, ingrese un email válido');
      }

      if (password.length < 6) {
        throw Exception('La contraseña debe tener al menos 6 caracteres');
      }

      if (password != confirmPassword) {
        throw Exception('Las contraseñas no coinciden');
      }

      // Simular registro exitoso
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Recuperar contraseña
  Future<void> resetPassword(String email) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Simular llamada a API
      await Future.delayed(const Duration(seconds: 2));

      // Validaciones básicas
      if (email.isEmpty) {
        throw Exception('Por favor, ingrese su email');
      }

      if (!email.contains('@')) {
        throw Exception('Por favor, ingrese un email válido');
      }

      // Simular envío exitoso
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
} 