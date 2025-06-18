class ApiEndpoints {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // Autenticación
  static const String login = '$baseUrl/autenticacion/iniciar-sesion';
  static const String register = '$baseUrl/autenticacion/registrarse';
  static const String logout = '$baseUrl/autenticacion/cerrar-sesion';
  static const String userProfile = '$baseUrl/autenticacion/usuario';

  // Admin
  static const String adminUsers = '$baseUrl/administrador/usuarios';
  static String adminUserById(int id) => '$baseUrl/administrador/usuario/$id';

  // Cliente
  static const String createClient = '$baseUrl/cliente/crear-cliente';
  static String clientById(int id) => '$baseUrl/cliente/$id';

  // Restaurante
  static const String restaurantes = '$baseUrl/publico/restaurantes';
  static const String createRestaurant = '$restaurantes/crear-usuario';
  static String restauranteById(int id) => '$baseUrl/publico/restaurante/$id';

  // Para filtrar por tipo
  static const String filtrarRestaurantesPorTipo =
      '$baseUrl/publico/restaurantes/tipo';

  // Para buscar por nombre (como en tu ejemplo)
  static const String buscarRestaurantesPorNombre =
      '$baseUrl/publico/buscar/restaurantes';
  static String tiposMenu = '$baseUrl/publico/tipos-menu';

  // Reservas
  static const String reservas = '$baseUrl/reserva';
  static String reservasPorCliente(int clienteId) =>
      '$reservas/cliente/$clienteId';
  static String reservasPorRestaurante(int restauranteId) =>
      '$reservas/restaurante/$restauranteId';

  // Calificaciones
  static const String calificaciones = '$baseUrl/calificacion';
  static String calificacionesPorRestaurante(int restauranteId) =>
      '$calificaciones/restaurante/$restauranteId';
  static String calificacionesPorCliente(int clienteId) =>
      '$calificaciones/cliente/$clienteId';

  // Recomendaciones
  static const String recomendaciones = '$baseUrl/recomendacion';
  static String recomendacionesPorCliente(int clienteId) =>
      '$recomendaciones/cliente/$clienteId';

  // Menús y Platos
  static const String menus = '$baseUrl/menu';
  static String menusPorRestaurante(int restauranteId) =>
      '$menus/restaurante/$restauranteId';
  static const String platos = '$baseUrl/plato';
  static String platosPorMenu(int menuId) => '$platos/menu/$menuId';

  // Mesas
  static const String mesas = '$baseUrl/mesa';
  static String mesasPorRestaurante(int restauranteId) =>
      '$mesas/restaurante/$restauranteId';
}
