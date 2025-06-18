import 'package:dio/dio.dart';
import '../../utils/store.dart';

class ErrorInterceptor extends Interceptor {
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Token expirado o inválido
      await SecureStorage.deleteToken();
      // Aquí podrías redirigir al login
    }

    return handler.next(err);
  }
}
