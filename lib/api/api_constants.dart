class ApiConstants {
  static const String baseUrl = 'http://tu-dominio-laravel.com/api';
  static const String loginUrl = '$baseUrl/auth/login';
  static const String registerUrl = '$baseUrl/auth/register';
  static const String logoutUrl = '$baseUrl/auth/logout';
  static const String refreshUrl = '$baseUrl/auth/refresh';

  // Headers
  static const Map<String, String> headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  static Map<String, String> authHeaders(String token) {
    return {...headers, 'Authorization': 'Bearer $token'};
  }
}
