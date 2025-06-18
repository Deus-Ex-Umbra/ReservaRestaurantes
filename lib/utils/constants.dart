class ApiConstants {
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  static const String loginEndpoint = '/autenticacion/iniciar-sesion';
  static const String registerEndpoint = '/autenticacion/registro';
  // Agrega otros endpoints según necesites
}

class StorageKeys {
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userData = 'user_data';
}
