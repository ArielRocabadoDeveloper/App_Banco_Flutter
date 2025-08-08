import 'package:flutter/material.dart';

class ProfileController extends ChangeNotifier {
  String _name = 'Ariel Rocabado';
  String _email = 'rocabadoariel16@gmail.com';
  String _phone = '+51 111 222 333';
  String _location = 'La Paz, Bolivia';
  String _id = '123456789';
  bool _notificationsEnabled = true;
  bool _fingerprintEnabled = true;
  bool _darkModeEnabled = false;

  // Getters
  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get location => _location;
  String get id => _id;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get fingerprintEnabled => _fingerprintEnabled;
  bool get darkModeEnabled => _darkModeEnabled;

  // Métodos para actualizar configuraciones
  void toggleNotifications() {
    _notificationsEnabled = !_notificationsEnabled;
    notifyListeners();
  }

  void toggleFingerprint() {
    _fingerprintEnabled = !_fingerprintEnabled;
    notifyListeners();
  }

  void toggleDarkMode() {
    _darkModeEnabled = !_darkModeEnabled;
    notifyListeners();
  }

  // Método para actualizar información del perfil
  Future<bool> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? location,
  }) async {
    try {
      // Simular una llamada a API
      await Future.delayed(const Duration(seconds: 1));

      if (name != null) _name = name;
      if (email != null) _email = email;
      if (phone != null) _phone = phone;
      if (location != null) _location = location;

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Método para cambiar contraseña
  Future<bool> changePassword(String currentPassword, String newPassword) async {
    try {
      // Simular una llamada a API
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      return false;
    }
  }

  // Método para cerrar sesión
  Future<void> logout() async {
    try {
      // Simular una llamada a API
      await Future.delayed(const Duration(milliseconds: 500));
      // Aquí se limpiarían las credenciales y datos del usuario
    } catch (e) {
      // Manejar error
    }
  }
} 