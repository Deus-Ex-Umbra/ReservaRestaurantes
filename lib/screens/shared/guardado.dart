import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_application/screens/shared/reserva.dart';
import '../../widgets/burritos.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({Key? key}) : super(key: key);

  @override
  _FavoritosScreenState createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen>
    with TickerProviderStateMixin {
  late AnimationController _heartAnimationController;
  late Animation<double> _heartScaleAnimation;
  late AnimationController _loadingAnimationController;

  final List<Restaurante> _restaurantesFavoritos = [
    Restaurante(
      id: '1',
      nombre: 'La Trattoria',
      direccion: 'Av. Principal 123, Ciudad',
      telefono: '+1 234 567 890',
      rating: 4.5,
      imagen: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4',
      horario: 'Lun-Vie: 12:00 - 23:00',
      tipoCocina: 'Italiana',
      precioPromedio: '\$\$',
      esFavorito: true,
      descripcion:
          'Auténtica cocina italiana en un ambiente acogedor. Especialistas en pastas frescas y pizzas al horno de leña.',
    ),
    Restaurante(
      id: '2',
      nombre: 'Sushi Palace',
      direccion: 'Calle Sushi 456, Ciudad',
      telefono: '+1 987 654 321',
      rating: 4.2,
      imagen: 'https://images.unsplash.com/photo-1580828343064-fde4fc206bc6',
      horario: 'Mar-Dom: 11:30 - 22:30',
      tipoCocina: 'Japonesa',
      precioPromedio: '\$\$\$',
      esFavorito: true,
      descripcion:
          'Sushi fresco preparado por chefs japoneses. Amplia selección de rolls creativos y platos tradicionales.',
    ),
    Restaurante(
      id: '3',
      nombre: 'Carnes Premium',
      direccion: 'Boulevard Carnes 789, Ciudad',
      telefono: '+1 555 123 4567',
      rating: 4.7,
      imagen: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5',
      horario: 'Mie-Lun: 13:00 - 00:00',
      tipoCocina: 'Parrilla',
      precioPromedio: '\$\$\$\$',
      esFavorito: true,
      descripcion:
          'Cortes premium de carne madurados y preparados a la perfección. Experiencia gourmet para amantes de la carne.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _heartAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _heartScaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _heartAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    _heartAnimationController.repeat(reverse: true);

    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _loadingAnimationController.repeat();
  }

  @override
  void dispose() {
    _heartAnimationController.dispose();
    _loadingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FoodieBackground(
        foodOpacity: 0.1,
        showSaladBowl: false,
        showBurger: false,
        showFries: false,
        showDrink: false,
        showPizza: true,
        showTaco: true,
        child: Column(
          children: [
            // Contenedor principal estilo Spotify
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 30,
                ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Header estilo "Currently Playing"
                    _buildCurrentlyPlayingHeader(),
                    const SizedBox(height: 16),

                    // Lista de restaurantes
                    Expanded(
                      child:
                          _restaurantesFavoritos.isEmpty
                              ? _buildEmptyState()
                              : ListView.builder(
                                itemCount: _restaurantesFavoritos.length,
                                itemBuilder: (context, index) {
                                  return _buildRestauranteRow(
                                    context,
                                    _restaurantesFavoritos[index],
                                    index,
                                  );
                                },
                              ),
                    ),
                  ],
                ),
              ),
            ),

            // Botón para agregar nuevos favoritos
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              margin: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Acción para explorar restaurantes
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Agregar nuevo favorito',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentlyPlayingHeader() {
    return Row(
      children: [
        // Icono estilo Spotify
        Container(
          width: 50,
          height: 50,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            gradient: const RadialGradient(
              colors: [Color(0xFF1DB954), Color(0xFF1ED760)],
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Icon(Icons.favorite, color: Colors.white, size: 24),
        ),
        const Text(
          'Restaurantes Favoritos',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildRestauranteRow(
    BuildContext context,
    Restaurante restaurante,
    int index,
  ) {
    return Container(
      height: 70,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            _showDetallesRestaurante(context, restaurante);
          },
          onHover: (isHovering) {
            // Efecto hover se maneja por el InkWell
          },
          child: Row(
            children: [
              // Corazón animado (equivalente a las barras de sonido)
              SizedBox(
                width: 40,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _heartScaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _heartScaleAnimation.value,
                        child: GestureDetector(
                          onTap: () {
                            _removeFromFavorites(restaurante);
                          },
                          child: Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 20 * _heartScaleAnimation.value,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Imagen del restaurante (album cover)
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  width: 40,
                  height: 40,
                  color: const Color(0xFFE9E8E8),
                  child: Image.network(
                    restaurante.imagen,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFE9E8E8),
                        child: Icon(
                          Icons.restaurant,
                          size: 20,
                          color: Colors.grey[400],
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Información del restaurante
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Nombre del restaurante
                    Text(
                      restaurante.nombre,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 2),

                    // Tipo de cocina y precio
                    Row(
                      children: [
                        Text(
                          restaurante.tipoCocina,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '• ${restaurante.precioPromedio}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Rating con estrellas
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RatingBarIndicator(
                    rating: restaurante.rating,
                    itemBuilder:
                        (context, index) =>
                            const Icon(Icons.star, color: Colors.amber),
                    itemCount: 5,
                    itemSize: 12,
                    unratedColor: Colors.amber.withAlpha(50),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    restaurante.rating.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _removeFromFavorites(Restaurante restaurante) {
    setState(() {
      _restaurantesFavoritos.remove(restaurante);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${restaurante.nombre} eliminado de favoritos'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 72, color: Colors.grey[300]),
          const SizedBox(height: 20),
          Text(
            'No tienes restaurantes favoritos',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Guarda tus restaurantes favoritos aquí\npara acceder a ellos rápidamente',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  void _showDetallesRestaurante(BuildContext context, Restaurante restaurante) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FoodieBackground(
          foodOpacity: 0.05,
          showBurger: false,
          showDrink: false,
          showPizza: false,
          showTaco: false,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Handle deslizable
                Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),

                // Imagen del restaurante
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    restaurante.imagen,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 200,
                        color: Colors.grey[100],
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[100],
                        child: const Center(
                          child: Icon(
                            Icons.restaurant,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Nombre y rating
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          restaurante.nombre,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      RatingBarIndicator(
                        rating: restaurante.rating,
                        itemBuilder:
                            (context, index) =>
                                const Icon(Icons.star, color: Colors.amber),
                        itemCount: 5,
                        itemSize: 24,
                        unratedColor: Colors.amber.withAlpha(50),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Tipo de cocina y precio
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.restaurant_menu,
                        size: 18,
                        color: Colors.teal[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        restaurante.tipoCocina,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.attach_money,
                        size: 18,
                        color: Colors.teal[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        restaurante.precioPromedio,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Lista de detalles
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildDetailItem(
                        Icons.description,
                        'Descripción',
                        restaurante.descripcion,
                      ),
                      _buildDetailItem(
                        Icons.location_on,
                        'Dirección',
                        restaurante.direccion,
                      ),
                      _buildDetailItem(
                        Icons.phone,
                        'Teléfono',
                        restaurante.telefono,
                      ),
                      _buildDetailItem(
                        Icons.access_time,
                        'Horario',
                        restaurante.horario,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                // Botón de reserva
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _navigateToReservation(context, restaurante);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Reservar ahora',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 22, color: Colors.teal[600]),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.teal[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: Colors.grey),
        ],
      ),
    );
  }

  void _navigateToReservation(BuildContext context, Restaurante restaurante) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RestauranteApp()),
    );
  }
}

class Restaurante {
  final String id;
  final String nombre;
  final String direccion;
  final String telefono;
  final double rating;
  final String imagen;
  final String horario;
  final String tipoCocina;
  final String precioPromedio;
  bool esFavorito;
  final String descripcion;

  Restaurante({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.telefono,
    required this.rating,
    required this.imagen,
    required this.horario,
    required this.tipoCocina,
    required this.precioPromedio,
    required this.esFavorito,
    required this.descripcion,
  });
}
