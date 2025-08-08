import 'package:flutter/material.dart';

class ForgotPasswordController extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  bool _emailSent = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get emailSent => _emailSent;

  Future<bool> sendResetEmail(String email) async {
    _isLoading = true;
    _errorMessage = null;
    _emailSent = false;
    notifyListeners();

    try {
      // Simular envío de email
      await Future.delayed(const Duration(seconds: 2));
      
      // Aquí iría la lógica real de envío de email
      _emailSent = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Error al enviar el email de recuperación';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
} 