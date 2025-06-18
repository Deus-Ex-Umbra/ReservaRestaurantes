import 'package:dio/dio.dart';
import 'package:flutter_application/api/interceptors/auth_interceptor.dart';
import 'package:flutter_application/api/interceptors/error_interceptor.dart';
import 'package:flutter_application/api/interceptors/logging_interceptor.dart';
import '../utils/store.dart';

// Define ApiEndpoints if not already defined elsewhere
class ApiEndpoints {
  static const String baseUrl =
      'https://http://127.0.0.1:8000/api'; // Replace with your actual base URL
}

class ApiClient {
  static final Dio _dio = Dio();

  static Dio get dio {
    _dio.options.baseUrl = ApiEndpoints.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

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
