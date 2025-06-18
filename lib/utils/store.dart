import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/auth/user_model.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();
  static const _prefs = SharedPreferences;

  // Keys
  static const _keyToken = 'auth_token';
  static const _keyUser = 'auth_user';
  static const _keyUserDetails = 'user_details';

  // Token Management
  static Future<void> writeToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  static Future<String?> readToken() async {
    return await _storage.read(key: _keyToken);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }

  // User Management
  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUser, user.toJson().toString());
  }

  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_keyUser);
    if (userString != null) {
      return UserModel.fromJson(jsonDecode(userString));
    }
    return null;
  }

  static Future<void> deleteUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUser);
  }

  // User Details Management
  static Future<Map<String, dynamic>> getCurrentUserDetails() async {
    final user = await getUser();
    if (user == null) return {};

    final role = user.role;
    final userId = user.id;

    // Obtener detalles adicionales del almacenamiento seguro
    final details = await _storage.read(key: '$_keyUserDetails-$userId');
    if (details != null) {
      return jsonDecode(details);
    }

    // Si no hay detalles guardados, devolver estructura básica
    return {
      'id': userId,
      'role': role,
      'name': await _getUserName(role, userId),
      'image': await _getUserImage(role, userId),
      // Agrega más campos según necesites
    };
  }

  static Future<void> saveUserDetails(Map<String, dynamic> details) async {
    final user = await getUser();
    if (user != null) {
      await _storage.write(
        key: '$_keyUserDetails-${user.id}',
        value: jsonEncode(details),
      );
    }
  }

  // Helper Methods
  static Future<String> _getUserName(String role, int userId) async {
    // Implementa lógica para obtener el nombre según el rol
    // Puedes obtenerlo del almacenamiento seguro o de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name_$userId') ?? 'Nombre del usuario';
  }

  static Future<String> _getUserImage(String role, int userId) async {
    // Implementa lógica para obtener la imagen según el rol
    // Puedes obtenerlo del almacenamiento seguro o de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_image_$userId') ??
        'assets/default_profile.jpg';
  }

  // Clear all auth data
  static Future<void> clearAll() async {
    await deleteToken();
    await deleteUser();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
