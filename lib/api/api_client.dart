import 'package:dio/dio.dart';
import 'package:flutter_application/api/interceptors/auth_interceptor.dart';
import 'package:flutter_application/api/interceptors/error_interceptor.dart';
import 'package:flutter_application/api/interceptors/logging_interceptor.dart';
import '../utils/store.dart';
import 'api_endpoints.dart';

class ApiClient {
  static final Dio _dio = Dio();

  static Dio get dio {
    _dio.options.baseUrl = ApiEndpoints.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    // Configuración específica para web
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.options.headers['Accept'] = 'application/json';
    _dio.options.headers['Access-Control-Allow-Origin'] = '*';

    // Agregar interceptores
    _dio.interceptors.addAll([
      LoggingInterceptor(),
      AuthInterceptor(),
      ErrorInterceptor(),
    ]);

    return _dio;
  }

  static Future<void> init() async {
    // Cargar token si existe
    final token = await SecureStorage.readToken();
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }
}
