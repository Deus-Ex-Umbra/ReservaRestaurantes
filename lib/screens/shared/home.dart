import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import '../../widgets/search_bar.dart';
import '../../widgets/category_chips.dart';
import '../../widgets/greeting_header.dart';
import 'restaurante.dart';
import '../../api/restaurant_service.dart';
import '../../models/auth/user_model.dart';
import '../../utils/store.dart';
import '../../widgets/burritos.dart';

class RecipeHomePage extends StatefulWidget {
  @override
  _RecipeHomePageState createState() => _RecipeHomePageState();
}

class _RecipeHomePageState extends State<RecipeHomePage> {
  String _selectedCategory = 'comida-tradicional';
  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Tradicional',
      'icon': Icons.restaurant_rounded,
      'color': Color(0xFFFF6B35),
      'apiValue': 'comida-tradicional',
    },
    {
      'name': 'Rápida',
      'icon': Icons.fastfood_rounded,
      'color': Color(0xFF6C5CE7),
      'apiValue': 'comida-rapida',
    },
    {
      'name': 'Parrilla',
      'icon': Icons.outdoor_grill_rounded,
      'color': Color(0xFFE17055),
      'apiValue': 'parrilla',
    },
    {
      'name': 'Italiana',
      'icon': Icons.local_pizza_rounded,
      'color': Color(0xFF00B894),
      'apiValue': 'italiana',
    },
    {
      'name': 'Postres',
      'icon': Icons.cake_rounded,
      'color': Color(0xFFFD79A8),
      'apiValue': 'postres',
    },
    {
      'name': 'Bebidas',
      'icon': Icons.local_bar_rounded,
      'color': Color(0xFF0984E3),
      'apiValue': 'bebidas',
    },
  ];

  List<dynamic> _restaurantes = [];
  late RestaurantService _restaurantService;
  UserModel? _currentUser;
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  dynamic _lastError;

  @override
  void initState() {
    super.initState();
    _restaurantService = RestaurantService();
    _loadCurrentUser();
    _loadRestaurantes();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final user = await SecureStorage.getUser();
      setState(() {
        _currentUser = user;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user: $e');
      }
    }
  }

  Future<void> _loadRestaurantes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _lastError = null;
    });

    try {
      if (kDebugMode) {
        print('Iniciando carga de restaurantes...');
        final token = await SecureStorage.readToken();
        print('Token de autenticación: $token');
      }

      final restaurantes = await _restaurantService.getRestaurantes();

      if (kDebugMode) {
        print('Datos recibidos de la API: ${jsonEncode(restaurantes)}');
        print('Número de restaurantes recibidos: ${restaurantes.length}');
      }

      setState(() {
        _restaurantes = restaurantes;
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error completo: $e');
        print('Stack trace: $stackTrace');
      }

      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al cargar restaurantes';
        _lastError = {
          'error': e.toString(),
          'stackTrace': stackTrace.toString(),
          'timestamp': DateTime.now(),
        };
      });
    }
  }

  Future<void> _searchRestaurants(String query) async {
    if (query.isEmpty) {
      await _loadRestaurantes();
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _lastError = null;
    });

    try {
      final restaurantes = await _restaurantService.buscarRestaurantesPorNombre(
        query,
      );

      if (kDebugMode) {
        print('Resultados de búsqueda: ${jsonEncode(restaurantes)}');
      }

      setState(() {
        _restaurantes = restaurantes;
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al buscar restaurantes';
        _lastError = {
          'error': e.toString(),
          'stackTrace': stackTrace.toString(),
          'timestamp': DateTime.now(),
        };
      });
    }
  }

  Future<void> _filterByCategory(String apiValue) async {
    setState(() {
      _selectedCategory = apiValue;
      _isLoading = true;
      _errorMessage = null;
      _lastError = null;
    });

    try {
      //final restaurantes = await _restaurantService.filtrarRestaurantesPorTipo(apiValue);
      //setState(() {
      //  _restaurantes = restaurantes;
      //  _isLoading = false;
      //});
    } catch (e, stackTrace) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al filtrar restaurantes';
        _lastError = {
          'error': e.toString(),
          'stackTrace': stackTrace.toString(),
          'timestamp': DateTime.now(),
        };
      });
    }
  }

  Future<void> _navigateToRestaurantDetail(int restaurantId) async {
    final restaurante = _restaurantes.firstWhere(
      (r) => r['id'] == restaurantId,
      orElse: () => null,
    );
    if (restaurante != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => RestaurantDetailScreen(restaurantId: restaurantId),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FoodieBackground(
        foodOpacity: 0.1,
        child: SafeArea(
          child: Column(
            children: [
              GreetingHeader(
                userName: _currentUser?.email ?? 'Usuario',
                profileImagePath: 'assets/profile.jpg',
                onNotificationPressed: () {},
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Text(
                      'Descubre los mejores\nrestaurantes cerca de ti',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 25),

              RecipeSearchBar(onSearchChanged: _searchRestaurants),

              SizedBox(height: 30),

              CategoryChips(
                categories: _categories,
                selectedCategory: _selectedCategory,
                onCategorySelected: (category) {
                  final selected = _categories.firstWhere(
                    (c) => c['name'] == category,
                    orElse: () => _categories[0],
                  );
                  _filterByCategory(selected['apiValue']);
                },
              ),

              SizedBox(height: 15),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Restaurantes Populares',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: _loadRestaurantes,
                      child: Text(
                        'Ver todos',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFFF8C00),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: _buildContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return _buildLoadingWidget();
    }

    if (_errorMessage != null) {
      return _buildErrorWidget();
    }

    if (_restaurantes.isEmpty) {
      return _buildEmptyStateWidget();
    }

    return _buildRestaurantList();
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF8C00)),
            strokeWidth: 3,
          ),
          SizedBox(height: 20),
          Text(
            'Cargando restaurantes...',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          if (kDebugMode && _lastError != null) ...[
            SizedBox(height: 20),
            Text(
              'Último error: ${_lastError['error']}',
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: Colors.red),
            SizedBox(height: 20),
            Text(
              'Error al cargar datos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(_errorMessage!, textAlign: TextAlign.center),
            ),
            SizedBox(height: 20),
            if (_lastError != null) ...[
              ExpansionTile(
                title: Text(
                  'Detalles técnicos',
                  style: TextStyle(color: Colors.orange),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Error:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SelectableText(_lastError['error']),
                        SizedBox(height: 10),
                        Text(
                          'Hora:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(_lastError['timestamp'].toString()),
                        SizedBox(height: 10),
                        Text(
                          'Stack trace:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SelectableText(
                          _lastError['stackTrace'],
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _loadRestaurantes,
              icon: Icon(Icons.refresh),
              label: Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyStateWidget() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 60, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              'No se encontraron restaurantes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'La API no devolvió ningún restaurante',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            if (_lastError != null) ...[
              ExpansionTile(
                title: Text(
                  'Detalles técnicos',
                  style: TextStyle(color: Colors.blue),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Respuesta API:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SelectableText(
                          _restaurantes.toString(),
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _loadRestaurantes,
              icon: Icon(Icons.refresh),
              label: Text('Recargar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantList() {
    return CustomScrollView(
      slivers: [
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 0,
            crossAxisSpacing: 15,
            childAspectRatio: 0.60,
          ),
          delegate: SliverChildBuilderDelegate((context, index) {
            final restaurant = _restaurantes[index];
            bool isRightCard = index % 2 == 1;
            bool isReduced = index % 2 == 0;

            return GestureDetector(
              onTap: () => _navigateToRestaurantDetail(restaurant['id']),
              child: Container(
                margin: EdgeInsets.only(
                  top: isReduced && index != 0 ? 40 : 0,
                  bottom: isRightCard ? 40 : 0,
                ),
                child: FractionallySizedBox(
                  heightFactor: 1.0,
                  child: RestaurantCard(
                    name:
                        restaurant['nombre_restaurante'] ??
                        'Nombre no disponible',
                    category: _mapTipoRestaurante(
                      restaurant['tipo_restaurante'],
                    ),
                    rating:
                        double.tryParse(
                          restaurant['calificacion']?.toString() ?? '0',
                        ) ??
                        0.0,
                    imagePath:
                        restaurant['imagen_base64'] != null
                            ? 'data:image/jpeg;base64,${restaurant['imagen_base64']}'
                            : 'assets/default_restaurant.jpg',
                    price:
                        '\$${restaurant['precio_promedio']?.toStringAsFixed(2) ?? '0.00'}',
                  ),
                ),
              ),
            );
          }, childCount: _restaurantes.length),
        ),
      ],
    );
  }

  String _mapTipoRestaurante(String? tipo) {
    switch (tipo?.toLowerCase()) {
      case 'comida-tradicional':
        return 'Tradicional';
      case 'parrilla':
        return 'Parrilla';
      case 'comida-rapida':
        return 'Comida Rápida';
      case 'italiana':
        return 'Italiana';
      case 'internacional':
        return 'Internacional';
      case 'postres':
        return 'Postres';
      case 'bebidas':
        return 'Bebidas';
      default:
        return 'Restaurante';
    }
  }
}

class RestaurantCard extends StatefulWidget {
  final String name;
  final String category;
  final double rating;
  final String imagePath;
  final String price;

  const RestaurantCard({
    Key? key,
    required this.name,
    required this.category,
    required this.rating,
    required this.imagePath,
    required this.price,
  }) : super(key: key);

  @override
  _RestaurantCardState createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _glowController;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _backgroundAnimation;
  late Animation<Color?> _textAnimation;
  late Animation<double> _glowAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _glowController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _slideAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: -8.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
    _backgroundAnimation = ColorTween(
      begin: Color(0xFF373737),
      end: Color(0xFFABD373),
    ).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
    _textAnimation = ColorTween(
      begin: Color(0xFFE5E5E5),
      end: Color(0xFF2D2D2D),
    ).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter:
          (_) => setState(() {
            _isHovered = true;
            _hoverController.forward();
          }),
      onExit:
          (_) => setState(() {
            _isHovered = false;
            _hoverController.reverse();
          }),
      child: AnimatedBuilder(
        animation: Listenable.merge([_hoverController, _glowController]),
        builder: (context, child) {
          return Container(
            margin: EdgeInsets.all(8),
            child: Stack(
              children: [
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _glowAnimation,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Color(
                                0xFFFF9F0D,
                              ).withOpacity(_glowAnimation.value * 0),
                              blurRadius: 150,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF373737).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _slideAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(
                              0,
                              MediaQuery.of(context).size.height *
                                  _slideAnimation.value,
                            ),
                            child: Container(
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: _backgroundAnimation.value,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          );
                        },
                      ),
                      Transform.translate(
                        offset: Offset(0, _scaleAnimation.value),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      _isHovered
                                          ? Color(0xFF2D2D2D)
                                          : Color(0xFFABD373),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child:
                                      widget.imagePath.startsWith('data:image')
                                          ? Image.memory(
                                            Uri.parse(
                                                  widget.imagePath,
                                                ).data?.contentAsBytes() ??
                                                Uint8List(0),
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) => Icon(
                                                  Icons.restaurant,
                                                  size: 50,
                                                  color:
                                                      _isHovered
                                                          ? Color(0xFFABD373)
                                                          : Color(0xFF2D2D2D),
                                                ),
                                          )
                                          : Image.asset(
                                            widget.imagePath,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) => Icon(
                                                  Icons.restaurant,
                                                  size: 50,
                                                  color:
                                                      _isHovered
                                                          ? Color(0xFFABD373)
                                                          : Color(0xFF2D2D2D),
                                                ),
                                          ),
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                widget.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: _textAnimation.value,
                                  letterSpacing: 0.5,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.category,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _textAnimation.value?.withOpacity(
                                        0.7,
                                      ),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.star,
                                    color: Color(0xFFFFD700),
                                    size: 14,
                                  ),
                                  SizedBox(width: 2),
                                  Text(
                                    widget.rating.toStringAsFixed(1),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: _textAnimation.value,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.price,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          _isHovered
                                              ? Color(0xFF2D2D2D)
                                              : Color(0xFFABD373),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          _isHovered
                                              ? Colors.white.withOpacity(0.1)
                                              : Color(0xFFABD373),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(
                                            0xFFFF9F0D,
                                          ).withOpacity(0.5),
                                          blurRadius: 45,
                                          spreadRadius: 30,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      'Order Now',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            _isHovered
                                                ? Color(0xFFE5E5E5)
                                                : Color(0xFF2D2D2D),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
