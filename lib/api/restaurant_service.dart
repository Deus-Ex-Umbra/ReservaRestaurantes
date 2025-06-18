import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/auth/user_model.dart';
import 'api_client.dart';
import 'api_endpoints.dart';

class RestaurantService {
  final Dio dio;

  RestaurantService() : dio = ApiClient.dio {
    // Configuración de interceptores para logging
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (kDebugMode) {
            print('🚀 [API Request] ${options.method} ${options.uri}');
            print('📤 Headers: ${options.headers}');
            if (options.data != null) {
              print('📦 Request Body: ${options.data}');
            }
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print(
              '✅ [API Response] ${response.statusCode} ${response.requestOptions.uri}',
            );
            print('📥 Response Data: ${response.data}');
          }
          return handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            print('🔴 [API Error] ${error.type}');
            print('⛔ URL: ${error.requestOptions.uri}');
            print('🛑 Status Code: ${error.response?.statusCode}');
            print('📛 Message: ${error.message}');
            print('📦 Error Response: ${error.response?.data}');
          }
          return handler.next(error);
        },
      ),
    );
  }

  // Obtener tipos de menú
  Future<Map<String, String>> getTiposMenu() async {
    try {
      if (kDebugMode) {
        print('🔵 [RestaurantService] Obteniendo tipos de menú');
      }

      final response = await dio.get(ApiEndpoints.tiposMenu);

      if (response.statusCode == 200 && response.data['tipos_menu'] != null) {
        if (kDebugMode) {
          print('🟢 [RestaurantService] Tipos de menú obtenidos exitosamente');
        }
        return Map<String, String>.from(response.data['tipos_menu']);
      } else {
        throw Exception('Formato de respuesta inesperado');
      }
    } on DioException catch (e) {
      _handleDioError(e, 'fetching menu types');
      throw _parseError(e, 'Error al obtener los tipos de menú');
    } catch (e) {
      if (kDebugMode) {
        print('🔴 [RestaurantService] Error inesperado: $e');
      }
      throw Exception('An unexpected error occurred');
    }
  }

  // Obtener todos los restaurantes
  Future<List<dynamic>> getRestaurantes() async {
    try {
      if (kDebugMode) {
        print('🔵 [RestaurantService] Obteniendo lista de restaurantes');
      }

      final response = await dio.get(
        ApiEndpoints.restaurantes,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('🟢 [RestaurantService] Restaurantes obtenidos exitosamente');
          print('📊 Datos completos recibidos: ${response.data}');
          print(
            '📊 Total restaurantes: ${response.data['usuarios_restaurantes']?.length ?? 0}',
          );
        }

        return response.data['usuarios_restaurantes'] ?? [];
      } else {
        throw Exception('Failed to load restaurants: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e, 'fetching restaurants');
      throw _parseError(e, 'Error al obtener restaurantes');
    } catch (e) {
      if (kDebugMode) {
        print('🔴 [RestaurantService] Error inesperado: $e');
      }
      throw Exception('An unexpected error occurred');
    }
  }

  // Filtrar restaurantes por tipo
  Future<List<dynamic>> filtrarRestaurantesPorTipo(String tipo) async {
    try {
      if (kDebugMode) {
        print('🔵 [RestaurantService] Filtrando restaurantes por tipo: $tipo');
      }

      final response = await dio.get(
        ApiEndpoints.filtrarRestaurantesPorTipo,
        queryParameters: {'tipo': tipo},
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('🟢 [RestaurantService] Filtrado por tipo exitoso');
          print(
            '📊 Restaurantes encontrados: ${response.data['data']?.length ?? 0}',
          );
        }
        return response.data['data'] ?? [];
      } else {
        throw Exception(
          'Failed to filter restaurants by type: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      _handleDioError(e, 'filtering restaurants by type');
      throw _parseError(e, 'Error al filtrar restaurantes por tipo');
    }
  }

  // Buscar restaurantes por nombre (como en tu ejemplo)
  Future<List<dynamic>> buscarRestaurantesPorNombre(String nombre) async {
    try {
      if (kDebugMode) {
        print(
          '🔵 [RestaurantService] Buscando restaurantes por nombre: $nombre',
        );
      }

      final response = await dio.get(
        ApiEndpoints.buscarRestaurantesPorNombre,
        queryParameters: {'nombre': nombre},
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('🟢 [RestaurantService] Búsqueda por nombre exitosa');
          print(
            '📊 Restaurantes encontrados: ${response.data['data']?.length ?? 0}',
          );
        }
        return response.data['data'] ?? [];
      } else {
        throw Exception(
          'Failed to search restaurants by name: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      _handleDioError(e, 'searching restaurants by name');
      throw _parseError(e, 'Error al buscar restaurantes por nombre');
    }
  }

  Future<Map<String, dynamic>> getRestauranteById(int id) async {
    try {
      if (kDebugMode) {
        print('🔵 [RestaurantService] Obteniendo restaurante con ID: $id');
      }

      final response = await dio.get(ApiEndpoints.restauranteById(id));

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('🟢 [RestaurantService] Restaurante obtenido exitosamente');
          print('📊 Datos recibidos: ${response.data}');
        }

        // Asegúrate de que la respuesta tenga la estructura esperada
        if (response.data is! Map<String, dynamic>) {
          throw Exception('Formato de respuesta inesperado');
        }

        // Devuelve un mapa vacío si no hay datos
        return response.data['data'] ?? {};
      } else {
        throw Exception('Failed to load restaurant: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e, 'fetching restaurant by id');
      throw _parseError(e, 'Error al obtener el restaurante');
    } catch (e) {
      if (kDebugMode) {
        print('🔴 [RestaurantService] Error inesperado: $e');
      }
      throw Exception('An unexpected error occurred');
    }
  }

  // Crear una reserva
  Future<Map<String, dynamic>> crearReserva({
    required String fechaReserva,
    required String horaReserva,
    required int cantidadPersonas,
    required int clienteId,
    required int restauranteId,
    required List<int> platos,
    required List<int> mesas,
  }) async {
    try {
      if (kDebugMode) {
        print('🔵 [RestaurantService] Creando reserva');
        print('📅 Fecha: $fechaReserva, Hora: $horaReserva');
        print('👥 Personas: $cantidadPersonas');
      }

      final response = await dio.post(
        ApiEndpoints.reservas,
        data: {
          'fecha_reserva': fechaReserva,
          'hora_reserva': horaReserva,
          'cantidad_personas': cantidadPersonas,
          'id_cliente': clienteId,
          'id_restaurante': restauranteId,
          'platos': platos,
          'mesas': mesas,
        },
      );

      if (response.statusCode == 201) {
        if (kDebugMode) {
          print('🟢 [RestaurantService] Reserva creada exitosamente');
          print('📝 ID Reserva: ${response.data['data']?['id']}');
        }
        return response.data['data'] ?? {};
      } else {
        throw Exception('Failed to create reservation: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e, 'creating reservation');
      throw _parseError(e, 'Error al crear la reserva');
    }
  }

  // Obtener reservas por cliente
  Future<List<dynamic>> getReservasPorCliente(int clienteId) async {
    try {
      if (kDebugMode) {
        print(
          '🔵 [RestaurantService] Obteniendo reservas para cliente ID: $clienteId',
        );
      }

      final response = await dio.get(
        ApiEndpoints.reservasPorCliente(clienteId),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('🟢 [RestaurantService] Reservas obtenidas exitosamente');
          print('📊 Total reservas: ${response.data['data']?.length ?? 0}');
        }
        return response.data['data'] ?? [];
      } else {
        throw Exception('Failed to load reservations: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e, 'fetching client reservations');
      throw _parseError(e, 'Error al obtener las reservas');
    }
  }

  // Crear calificación
  Future<Map<String, dynamic>> crearCalificacion({
    required int puntuacion,
    required String comentario,
    required int clienteId,
    required int restauranteId,
  }) async {
    try {
      if (kDebugMode) {
        print('🔵 [RestaurantService] Creando calificación');
        print('⭐ Puntuación: $puntuacion');
      }

      final response = await dio.post(
        ApiEndpoints.calificaciones,
        data: {
          'puntuacion': puntuacion,
          'comentario': comentario,
          'id_cliente': clienteId,
          'id_restaurante': restauranteId,
        },
      );

      if (response.statusCode == 201) {
        if (kDebugMode) {
          print('🟢 [RestaurantService] Calificación creada exitosamente');
        }
        return response.data['data'] ?? {};
      } else {
        throw Exception('Failed to create rating: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e, 'creating rating');
      throw _parseError(e, 'Error al crear la calificación');
    }
  }

  // Obtener recomendaciones para un cliente
  Future<List<dynamic>> getRecomendaciones(int clienteId) async {
    try {
      if (kDebugMode) {
        print(
          '🔵 [RestaurantService] Obteniendo recomendaciones para cliente ID: $clienteId',
        );
      }

      final response = await dio.get(
        ApiEndpoints.recomendacionesPorCliente(clienteId),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(
            '🟢 [RestaurantService] Recomendaciones obtenidas exitosamente',
          );
          print(
            '📊 Total recomendaciones: ${response.data['data']?.length ?? 0}',
          );
        }
        return response.data['data'] ?? [];
      } else {
        throw Exception(
          'Failed to load recommendations: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      _handleDioError(e, 'fetching recommendations');
      throw _parseError(e, 'Error al obtener recomendaciones');
    }
  }

  // Método para manejar errores de Dio
  void _handleDioError(DioException e, String operation) {
    if (kDebugMode) {
      print('🔴 [RestaurantService] Error en $operation');
      print('⛔ Tipo de error: ${e.type}');
      print('🛑 Status code: ${e.response?.statusCode}');
      print('📛 Mensaje de error: ${e.message}');
      print('📦 Datos de respuesta: ${e.response?.data}');
      print('🔗 URL: ${e.requestOptions.uri}');
    }
  }

  // Método para parsear errores y devolver mensajes más amigables
  Exception _parseError(DioException e, String defaultMessage) {
    if (e.response?.statusCode == 401) {
      return Exception(
        'Tu sesión ha expirado. Por favor inicia sesión nuevamente.',
      );
    } else if (e.response?.statusCode == 403) {
      return Exception('No tienes permisos para realizar esta acción.');
    } else if (e.response?.statusCode == 404) {
      return Exception('Recurso no encontrado.');
    } else if (e.response?.statusCode == 500) {
      return Exception('Error en el servidor. Por favor intenta más tarde.');
    } else if (e.type == DioExceptionType.connectionTimeout) {
      return Exception(
        'Tiempo de conexión agotado. Verifica tu conexión a internet.',
      );
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return Exception('El servidor está tardando demasiado en responder.');
    } else if (e.response?.data != null &&
        e.response?.data['message'] != null) {
      return Exception(e.response?.data['message']);
    } else {
      return Exception('$defaultMessage: ${e.message}');
    }
  }
}
