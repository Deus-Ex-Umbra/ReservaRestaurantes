import 'package:flutter/material.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/category_chips.dart';
import '../../widgets/greeting_header.dart';
import '../../widgets/burritos.dart'; // Importa el fondo reutilizable
import 'restaurante.dart';

class RecipeHomePage extends StatefulWidget {
  @override
  _RecipeHomePageState createState() => _RecipeHomePageState();
}

class _RecipeHomePageState extends State<RecipeHomePage> {
  String _selectedCategory = 'Internacional';
  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Mundo',
      'icon': Icons.restaurant_rounded,
      'color': Color(0xFFFF6B35),
    },
    {
      'name': 'Rápida',
      'icon': Icons.fastfood_rounded,
      'color': Color(0xFF6C5CE7),
    },
    {
      'name': 'Saludable',
      'icon': Icons.eco_rounded,
      'color': Color(0xFF00B894),
    },
    {
      'name': 'Bebidas',
      'icon': Icons.local_bar_rounded,
      'color': Color(0xFF0984E3),
    },
    {'name': 'Postres', 'icon': Icons.cake_rounded, 'color': Color(0xFFFD79A8)},
    {
      'name': 'Parrilladas',
      'icon': Icons.outdoor_grill_rounded,
      'color': Color(0xFFE17055),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FoodieBackground(
        foodOpacity: 0.1,
        child: SafeArea(
          child: Column(
            children: [
              // Header reutilizable
              GreetingHeader(
                userName: 'Teresa',
                profileImagePath: 'assets/profile.jpg',
                onNotificationPressed: () {
                  // Lógica para manejar las notificaciones
                },
              ),

              // Título principal
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

              // Buscador reutilizable
              RecipeSearchBar(
                onSearchChanged: (query) {
                  print('Buscando: $query');
                },
              ),

              SizedBox(height: 30),

              // Categorías reutilizables
              CategoryChips(
                categories: _categories,
                selectedCategory: _selectedCategory,
                onCategorySelected: (category) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
              ),

              SizedBox(height: 15),

              // Título de restaurantes populares
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
                    Text(
                      'Ver todos',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFFF8C00),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 15),

              // Lista de restaurantes
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: CustomScrollView(
                    slivers: [
                      SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 0,
                          crossAxisSpacing: 15,
                          childAspectRatio: 0.60,
                        ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          bool isRightCard = index % 2 == 1;
                          bool isReduced = index % 2 == 0;

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => RestaurantDetailScreen(),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                top: isReduced && index != 0 ? 40 : 0,
                                bottom: isRightCard ? 40 : 0,
                              ),
                              child: FractionallySizedBox(
                                heightFactor: 1.0,
                                child: _buildEnhancedRestaurantCard(
                                  _getRestaurantName(index),
                                  _getRestaurantCategory(index),
                                  _getRestaurantRating(index),
                                  'assets/restaurant${index % 3 + 1}.jpg',
                                  _getRestaurantPrice(index),
                                ),
                              ),
                            ),
                          );
                        }, childCount: 6),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRestaurantName(int index) {
    final names = [
      'La Trattoria',
      'Burger House',
      'Sushi Palace',
      'Asado Argentino',
      'Green Bowl',
      'Sweet Heaven',
    ];
    return names[index % names.length];
  }

  String _getRestaurantCategory(int index) {
    final categories = [
      'Italiana',
      'Comida Rápida',
      'Japonesa',
      'Parrillada',
      'Saludable',
      'Repostería',
    ];
    return categories[index % categories.length];
  }

  double _getRestaurantRating(int index) {
    return 4.0 + (index % 5) * 0.1;
  }

  String _getRestaurantPrice(int index) {
    final prices = [
      '\$25.00',
      '\$18.50',
      '\$32.00',
      '\$28.75',
      '\$22.00',
      '\$15.99',
    ];
    return prices[index % prices.length];
  }

  Widget _buildEnhancedRestaurantCard(
    String name,
    String category,
    double rating,
    String imagePath,
    String price,
  ) {
    return RestaurantCard(
      name: name,
      category: category,
      rating: rating,
      imagePath: imagePath,
      price: price,
    );
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
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
        _hoverController.forward();
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
        _hoverController.reverse();
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([_hoverController, _glowController]),
        builder: (context, child) {
          return Container(
            margin: EdgeInsets.all(8),
            child: Stack(
              children: [
                // Círculo naranja suave de fondo
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

                // Contenedor principal con efecto de vidrio
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      // Fondo base
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF373737).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),

                      // Overlay con animación de deslizamiento
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

                      // Contenido de la tarjeta
                      Transform.translate(
                        offset: Offset(0, _scaleAnimation.value),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Imagen del restaurante (círculo)
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
                                  child: Image.asset(
                                    widget.imagePath,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) => Icon(
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

                              // Nombre del restaurante
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

                              // Categoría y rating
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

                              // Precio y botón
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

                                  // Botón Order Now
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
