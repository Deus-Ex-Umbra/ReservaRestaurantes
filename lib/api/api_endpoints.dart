class ApiEndpoints {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // Autenticación
  static const String login = '/autenticacion/iniciar-sesion';
  static const String register = '/autenticacion/registrarse';
  static const String logout = '/autenticacion/cerrar-sesion';
  static const String userProfile = '/autenticacion/usuario';

  // Admin
  static const String adminUsers = '/administrador/usuarios';
  static String adminUserById(int id) => '/administrador/usuario/$id';
  // ... agregar más endpoints para admin según necesites

  // Cliente
  static const String createClient = '/cliente/crear-cliente';
  static String clientById(int id) => '/cliente/$id';
  // ... agregar más endpoints para cliente

  // Restaurante
  static const String createRestaurant = '/restaurante/crear-usuario';
  static String restaurantById(int id) => '/restaurante/$id';
  // ... agregar más endpoints para restaurante
}
