import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:flutter_application/screens/shared/reserva.dart';
import '../time_selection_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Define Restaurante class if not already defined or import it from its file
class Restaurante {
  final int id;
  final int idUsuario;
  final String nombreRestaurante;
  final String direccion;
  final String telefono;
  final String categoria;
  final String horarioApertura;
  final String horarioCierre;
  final String tipoRestaurante;
  final String calificacion;
  final String? rutaImagenRestaurante;
  final String? imagenBase64;
  final List<dynamic> menus;

  Restaurante({
    required this.id,
    required this.idUsuario,
    required this.nombreRestaurante,
    required this.direccion,
    required this.telefono,
    required this.categoria,
    required this.horarioApertura,
    required this.horarioCierre,
    required this.tipoRestaurante,
    required this.calificacion,
    this.rutaImagenRestaurante,
    this.imagenBase64,
    required this.menus,
  });

  factory Restaurante.fromJson(Map<String, dynamic> json) {
    return Restaurante(
      id: json['id'],
      idUsuario: json['id_usuario'],
      nombreRestaurante: json['nombre_restaurante'],
      direccion: json['direccion'],
      telefono: json['telefono'],
      categoria: json['categoria'],
      horarioApertura: json['horario_apertura'],
      horarioCierre: json['horario_cierre'],
      tipoRestaurante: json['tipo_restaurante'],
      calificacion: json['calificacion'],
      rutaImagenRestaurante: json['ruta_imagen_restaurante'],
      imagenBase64: json['imagen_base64'],
      menus: json['menus'] ?? [],
    );
  }
}

class RestaurantDetailScreen extends StatefulWidget {
  final int restaurantId;

  const RestaurantDetailScreen({super.key, required this.restaurantId});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  final Completer<GoogleMapController> _mapController = Completer();
  late List<Map<String, dynamic>> _dateOptions;
  int _selectedDateIndex = -1;
  int _currentSection = 0;
  final GlobalKey _reservationsKey = GlobalKey();
  final GlobalKey _menuKey = GlobalKey();
  final GlobalKey _detailsKey = GlobalKey();
  final GlobalKey _addressKey = GlobalKey();
  bool _showStickyNavBar = false;
  double _addressPosition = 0;
  late Future<Restaurante> _restauranteFuture;
  Restaurante? _restaurante;

  static const LatLng _center = LatLng(-19.0429, -65.2554);
  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('restaurant'),
      position: LatLng(-19.0429, -65.2554),
      infoWindow: InfoWindow(title: 'Restaurante'),
    ),
  };

  @override
  void initState() {
    super.initState();
    _dateOptions = _generateDateOptions();
    _scrollController.addListener(_scrollListener);
    _restauranteFuture = _fetchRestaurante();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateAddressPosition();
    });
  }

  List<Map<String, dynamic>> _generateDateOptions() {
    final now = DateTime.now();
    return List.generate(7, (index) {
      final date = now.add(Duration(days: index));
      final dayName = _getDayName(date.weekday);
      final monthName = _getMonthName(date.month);
      final displayText = '$dayName, ${date.day} $monthName';
      return {'date': date, 'displayText': displayText};
    });
  }

  String _getDayName(int weekday) {
    const days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    return days[(weekday - 1) % 7];
  }

  String _getMonthName(int month) {
    const months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];
    return months[(month - 1) % 12];
  }

  Future<Restaurante> _fetchRestaurante() async {
    final response = await http.get(
      Uri.parse(
        'http://127.0.0.1:8000/api/publico/restaurante/${widget.restaurantId}',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _restaurante = Restaurante.fromJson(data['usuario_restaurante']);
      });
      return Restaurante.fromJson(data['usuario_restaurante']);
    } else {
      throw Exception('Failed to load restaurant');
    }
  }

  void _scrollListener() {
    // Example logic: show sticky navbar when scrolled past address position
    if (_scrollController.hasClients) {
      final offset = _scrollController.offset;
      if (offset > _addressPosition && !_showStickyNavBar) {
        setState(() {
          _showStickyNavBar = true;
        });
      } else if (offset <= _addressPosition && _showStickyNavBar) {
        setState(() {
          _showStickyNavBar = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _calculateAddressPosition() {
    final addressContext = _addressKey.currentContext;
    if (addressContext != null) {
      final addressBox = addressContext.findRenderObject() as RenderBox;
      final position = addressBox.localToGlobal(Offset.zero).dy;
      setState(() {
        _addressPosition = position;
      });
    }
  }

  // ... (mantén los métodos _scrollListener, _scrollToSection, _generateDateOptions,
  // _getDayName, _getMonthName, _navigateToReservation iguales)

  Widget _buildInfoRow(
    IconData icon,
    String title,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: Colors.teal),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: valueColor ?? Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularDishCard(String name, String price, String? imageUrl) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.grey[200]),
            child:
                imageUrl != null
                    ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Center(
                            child: Icon(
                              Icons.restaurant,
                              size: 40,
                              color: Colors.grey[400],
                            ),
                          ),
                    )
                    : Center(
                      child: Icon(
                        Icons.restaurant,
                        size: 40,
                        color: Colors.grey[400],
                      ),
                    ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: const TextStyle(
                    color: Colors.teal,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Container(
      width: 80,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, size: 28, color: Colors.teal),
          ),
          const SizedBox(height: 8),
          if (value.isNotEmpty)
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDishItem(String title, String description, String price) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                price,
                style: const TextStyle(
                  color: Colors.teal,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        const SizedBox(height: 16),
        const Divider(height: 1, color: Colors.grey),
      ],
    );
  }

  Widget _buildDateButton(String text, bool isSelected, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: Colors.teal.withOpacity(0.3),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => _scrollToSection(0),
                style: TextButton.styleFrom(
                  foregroundColor:
                      _currentSection == 0 ? Colors.teal : Colors.grey[700],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Reservaciones',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () => _scrollToSection(1),
                style: TextButton.styleFrom(
                  foregroundColor:
                      _currentSection == 1 ? Colors.teal : Colors.grey[700],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Menú',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () => _scrollToSection(2),
                style: TextButton.styleFrom(
                  foregroundColor:
                      _currentSection == 2 ? Colors.teal : Colors.grey[700],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Detalles',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FutureBuilder<Restaurante>(
      future: _restauranteFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error al cargar el restaurante'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('No se encontró el restaurante'));
        }

        final restaurante = snapshot.data!;

        return Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  child:
                      restaurante.imagenBase64 != null
                          ? Image.memory(
                            base64Decode(restaurante.imagenBase64!),
                            fit: BoxFit.cover,
                          )
                          : Center(
                            child: Icon(
                              Icons.restaurant,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                          ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            size: 18,
                            color: Colors.black,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.9,
              ),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              restaurante.nombreRestaurante,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              restaurante.categoria,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 15),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.teal.withOpacity(0.3),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text(
                              restaurante.calificacion,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        _buildStatItem(Icons.access_time, '35', 'min'),
                        SizedBox(width: 10),
                        _buildStatItem(Icons.people, '03', 'persons'),
                        SizedBox(width: 10),
                        _buildStatItem(
                          Icons.local_fire_department,
                          '103',
                          'kcal',
                        ),
                        SizedBox(width: 10),
                        _buildStatItem(
                          Icons.sentiment_very_satisfied,
                          '',
                          'Easy',
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    key: _addressKey,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on, size: 18, color: Colors.grey),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          restaurante.direccion,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  if (!_showStickyNavBar)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: _buildNavigationBar(),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildReservationsSection() {
    return Container(
      key: _reservationsKey,
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.9,
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Lamentablemente, este restaurante no está en la red de reservaciones de OpenTable. Puedes llamarlos para hacer una reservación. Si lo desea, le notificaremos por correo electrónico si este restaurante se une.',
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed:
                _restaurante != null
                    ? () {
                      // Lógica para llamar al restaurante
                    }
                    : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Llamar al restaurante',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.teal,
              side: BorderSide(color: Colors.teal),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Recibir correo electrónico cuando esté disponible',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection() {
    return FutureBuilder<Restaurante>(
      future: _restauranteFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error al cargar el menú'));
        }

        final restaurante = snapshot.data!;

        return Container(
          key: _menuKey,
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.access_time, color: Colors.teal, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Reservar para',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(_dateOptions.length, (index) {
                          final option = _dateOptions[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _buildDateButton(
                              option['displayText'],
                              index == _selectedDateIndex,
                              onTap: () {
                                setState(() {
                                  _selectedDateIndex = index;
                                });
                                final selectedDate =
                                    _dateOptions[_selectedDateIndex]['date'];
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => TimeSelectionScreen(
                                          selectedDate: selectedDate,
                                        ),
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Carta',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Última modificación: ${DateTime.now().year}',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const SizedBox(height: 24),
              const Text(
                'PLATOS POPULARES',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (restaurante.menus.isNotEmpty)
                      ...restaurante.menus
                          .take(3)
                          .map(
                            (menu) => _buildPopularDishCard(
                              menu['nombre'] ?? 'Plato sin nombre',
                              '\$${menu['precio']?.toStringAsFixed(2) ?? '0.00'}',
                              menu['imagen_url'],
                            ),
                          )
                    else
                      Text('No hay menús disponibles'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Icon(Icons.euro, color: Colors.teal, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'PRECIO MEDIO DE \$${restaurante.menus.isNotEmpty ? (restaurante.menus.map((m) => m['precio'] ?? 0).reduce((a, b) => a + b) / restaurante.menus.length).toStringAsFixed(2) : '0.00'}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (restaurante.menus.isNotEmpty)
                ...restaurante.menus
                    .map(
                      (menu) => _buildDishItem(
                        menu['nombre'] ?? 'Plato sin nombre',
                        menu['descripcion'] ?? 'Sin descripción',
                        '\$${menu['precio']?.toStringAsFixed(2) ?? '0.00'}',
                      ),
                    )
                    .toList(),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'VER TODA LA CARTA',
                        style: TextStyle(
                          color: Colors.teal,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.teal, size: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailsSection() {
    return FutureBuilder<Restaurante>(
      future: _restauranteFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error al cargar detalles'));
        }

        final restaurante = snapshot.data!;

        return Container(
          key: _detailsKey,
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Información adicional',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    Icons.description_outlined,
                    'Descripción',
                    restaurante.categoria,
                  ),
                  const Divider(),
                  _buildInfoRow(
                    Icons.phone_outlined,
                    'Teléfono',
                    restaurante.telefono,
                    valueColor: Colors.teal,
                  ),
                  const Divider(),
                  _buildInfoRow(
                    Icons.monetization_on_outlined,
                    'Precio',
                    'Hasta \$30',
                  ),
                  const Divider(),
                  _buildInfoRow(
                    Icons.restaurant_menu,
                    'Cocina',
                    restaurante.tipoRestaurante,
                  ),
                  const Divider(),
                  _buildInfoRow(
                    Icons.access_time,
                    'Horarios',
                    '${restaurante.horarioApertura} - ${restaurante.horarioCierre}',
                  ),
                  const Divider(),
                  _buildInfoRow(
                    Icons.credit_card,
                    'Opciones de pago',
                    'Mastercard, Visa',
                  ),
                  const Divider(),
                  _buildInfoRow(
                    Icons.local_parking,
                    'Estacionamiento',
                    'Estacionamiento en vía pública',
                  ),
                  const Divider(),
                  _buildInfoRow(
                    Icons.accessibility_new,
                    'Código de etiqueta',
                    'Ropa informal',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _scrollToSection(int sectionIndex) {
    setState(() {
      _currentSection = sectionIndex;
    });
    final contextMap = {0: _reservationsKey, 1: _menuKey, 2: _detailsKey};
    final key = contextMap[sectionIndex];
    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _navigateToReservation(BuildContext context) {
    // TODO: Implement navigation to reservation screen
    // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => ReservaScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                _buildHeader(),
                _buildReservationsSection(),
                _buildMenuSection(),
                _buildDetailsSection(),
                SizedBox(height: 80),
              ],
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: _showStickyNavBar ? 0 : -100,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _showStickyNavBar ? 1.0 : 0.0,
              child: _buildNavigationBar(),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton(
          onPressed: () => _navigateToReservation(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 4,
            shadowColor: Colors.teal.withOpacity(0.3),
          ),
          child: const Text(
            'Reservar una mesa',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
