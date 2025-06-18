import 'package:dio/dio.dart';
import 'package:flutter_application/api/api_client.dart' as api_client;
import 'package:flutter_application/api/api_endpoints.dart';
import 'package:flutter_application/models/auth/login_request.dart';
import 'package:flutter_application/models/auth/login_response.dart';
import 'package:flutter_application/models/auth/user_model.dart';
import '../../utils/store.dart';

class AuthService {
  final Dio _dio = api_client.ApiClient.dio;

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      print(
        '🔵 [AuthService] Enviando petición de login a: ${ApiEndpoints.login}',
      );
      print('📤 Datos enviados: ${request.toJson()}');

      final response = await _dio.post(
        ApiEndpoints.login,
        data: request.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json'},
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
        ),
      );

      print(
        '🟢 [AuthService] Respuesta recibida - Status: ${response.statusCode}',
      );
      print('📥 Datos recibidos: ${response.data}');

      final loginResponse = LoginResponse.fromJson(response.data);

      // Guardar token
      await SecureStorage.writeToken(loginResponse.token);
      print('🔐 Token almacenado correctamente');

      // Actualizar headers de Dio
      _dio.options.headers['Authorization'] = 'Bearer ${loginResponse.token}';
      print('🔄 Headers de Dio actualizados con el token');

      return loginResponse;
    } on DioException catch (e) {
      print('🔴 [AuthService] Error en login (DioException)');
      print('⛔ Tipo de error: ${e.type}');
      print('🛑 Status code: ${e.response?.statusCode}');
      print('📛 Mensaje de error: ${e.message}');
      print('📦 Datos de respuesta: ${e.response?.data}');

      String errorMessage = 'Error al iniciar sesión';

      if (e.response?.statusCode == 401) {
        errorMessage = 'Credenciales inválidas. Por favor verifica tus datos.';
      } else if (e.response?.statusCode == 400) {
        errorMessage =
            'Solicitud incorrecta: ${e.response?.data['message'] ?? 'Datos inválidos'}';
      } else if (e.response?.statusCode == 500) {
        errorMessage = 'Error en el servidor. Por favor intenta más tarde.';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage =
            'Tiempo de conexión agotado. Verifica tu conexión a internet.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage =
            'Tiempo de espera agotado. El servidor está tardando demasiado en responder.';
      }

      throw Exception(errorMessage);
    } catch (e) {
      print('🔴 [AuthService] Error inesperado en login: $e');
      throw Exception(
        'Ocurrió un error inesperado. Por favor intenta nuevamente.',
      );
    }
  }

  Future<void> logout() async {
    try {
      print('🔵 [AuthService] Enviando petición de logout');

      await _dio.get(
        ApiEndpoints.logout,
        options: Options(
          headers: {'Authorization': _dio.options.headers['Authorization']},
        ),
      );

      await SecureStorage.deleteToken();
      _dio.options.headers.remove('Authorization');

      print('🟢 [AuthService] Logout exitoso. Token eliminado.');
    } on DioException catch (e) {
      print('🔴 [AuthService] Error en logout (DioException)');
      print('⛔ Tipo de error: ${e.type}');
      print('🛑 Status code: ${e.response?.statusCode}');
      print('📛 Mensaje de error: ${e.message}');

      // Asegurarnos de limpiar el token incluso si el logout falla
      await SecureStorage.deleteToken();
      _dio.options.headers.remove('Authorization');

      throw Exception('Error al cerrar sesión: ${e.message}');
    } catch (e) {
      print('🔴 [AuthService] Error inesperado en logout: $e');
      throw Exception('Ocurrió un error al cerrar sesión');
    }
  }

  Future<UserModel> getProfile() async {
    try {
      print('🔵 [AuthService] Obteniendo perfil de usuario');

      final response = await _dio.get(
        ApiEndpoints.userProfile,
        options: Options(
          headers: {'Authorization': _dio.options.headers['Authorization']},
        ),
      );

      print('🟢 [AuthService] Perfil obtenido exitosamente');
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      print('🔴 [AuthService] Error al obtener perfil (DioException)');
      print('⛔ Tipo de error: ${e.type}');
      print('🛑 Status code: ${e.response?.statusCode}');

      if (e.response?.statusCode == 401) {
        // Token inválido o expirado
        await SecureStorage.deleteToken();
        _dio.options.headers.remove('Authorization');
        throw Exception(
          'Tu sesión ha expirado. Por favor inicia sesión nuevamente.',
        );
      }

      throw Exception(
        'Error al obtener el perfil: ${e.response?.data['message'] ?? e.message}',
      );
    } catch (e) {
      print('🔴 [AuthService] Error inesperado al obtener perfil: $e');
      throw Exception('Ocurrió un error al cargar tu perfil');
    }
  }
}
