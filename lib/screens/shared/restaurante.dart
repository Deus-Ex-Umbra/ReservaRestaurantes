import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:flutter_application/screens/shared/reserva.dart';
import '../time_selection_screen.dart';

class RestaurantDetailScreen extends StatefulWidget {
  const RestaurantDetailScreen({super.key});

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

  static const LatLng _center = LatLng(-19.0429, -65.2554);
  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('restaurant'),
      position: LatLng(-19.0429, -65.2554),
      infoWindow: InfoWindow(title: 'Malaba'),
    ),
  };

  @override
  void initState() {
    super.initState();
    _dateOptions = _generateDateOptions();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateAddressPosition();
    });
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

  void _scrollListener() {
    final scrollPosition = _scrollController.position.pixels;
    final newShowStickyNavBar = scrollPosition > _addressPosition - 100;

    if (newShowStickyNavBar != _showStickyNavBar) {
      setState(() {
        _showStickyNavBar = newShowStickyNavBar;
      });
    }

    final reservationsContext = _reservationsKey.currentContext;
    final menuContext = _menuKey.currentContext;
    final detailsContext = _detailsKey.currentContext;

    if (reservationsContext != null &&
        menuContext != null &&
        detailsContext != null) {
      final reservationsPosition =
          reservationsContext.findRenderObject() as RenderBox;
      final menuPosition = menuContext.findRenderObject() as RenderBox;
      final detailsPosition = detailsContext.findRenderObject() as RenderBox;

      final reservationsOffset =
          reservationsPosition.localToGlobal(Offset.zero).dy;
      final menuOffset = menuPosition.localToGlobal(Offset.zero).dy;
      final detailsOffset = detailsPosition.localToGlobal(Offset.zero).dy;

      if (scrollPosition >= detailsOffset - 100) {
        setState(() => _currentSection = 2);
      } else if (scrollPosition >= menuOffset - 100) {
        setState(() => _currentSection = 1);
      } else {
        setState(() => _currentSection = 0);
      }
    }
  }

  void _scrollToSection(int section) {
    final key =
        section == 0
            ? _reservationsKey
            : section == 1
            ? _menuKey
            : _detailsKey;
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  List<Map<String, dynamic>> _generateDateOptions() {
    final now = DateTime.now();
    final List<Map<String, dynamic>> dateOptions = [];

    for (int i = 1; i <= 7; i++) {
      final date = now.add(Duration(days: i));
      final dayName = _getDayName(date.weekday);
      final monthName = _getMonthName(date.month);

      dateOptions.add({
        'date': date,
        'displayText': '$dayName ${date.day} $monthName',
      });
    }

    return dateOptions;
  }

  String _getDayName(int weekday) {
    const days = ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];
    return days[weekday % 7];
  }

  String _getMonthName(int month) {
    const months = [
      'ene',
      'feb',
      'mar',
      'abr',
      'may',
      'jun',
      'jul',
      'ago',
      'sep',
      'oct',
      'nov',
      'dic',
    ];
    return months[month - 1];
  }

  void _navigateToReservation(BuildContext context) {
    if (_selectedDateIndex != -1) {
      final selectedDate = _dateOptions[_selectedDateIndex]['date'];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RestauranteApp(initialDate: selectedDate),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RestauranteApp()),
      );
    }
  }

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

  Widget _buildPopularDishCard(String name, String price, String imageUrl) {
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
            child: Image.network(
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
    return Column(
      children: [
        // Restaurant image with overlay
        Stack(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.grey[200]),
              child: Image.network(
                'https://placekitten.com/600/400',
                fit: BoxFit.cover,
              ),
            ),

            // Header Controls
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

            Positioned(
              bottom: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Ver las 14 fotos',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),

        // Restaurant info
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
                      children: const [
                        Text(
                          'Malaba',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Hamburguesas',
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
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                      children: const [
                        Icon(Icons.star, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '4.5',
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

              // Restaurant Stats
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    _buildStatItem(Icons.access_time, '35', 'min'),
                    SizedBox(width: 10),
                    _buildStatItem(Icons.people, '03', 'persons'),
                    SizedBox(width: 10),
                    _buildStatItem(Icons.local_fire_department, '103', 'kcal'),
                    SizedBox(width: 10),
                    _buildStatItem(Icons.sentiment_very_satisfied, '', 'Easy'),
                    SizedBox(width: 10),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Address row
              Row(
                key: _addressKey,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.location_on, size: 18, color: Colors.grey),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '386 Grau, Sucre, Departamento de Chuquisaca, 00000',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ],
              ),

              // Navigation bar below address (initial position)
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
            onPressed: () {},
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
          // Sección para reservar
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

          // Título de la carta
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
            'Última modificación: febrero 2023',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),

          const SizedBox(height: 24),

          // Platos populares
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
                _buildPopularDishCard(
                  'Pan de elote con helado',
                  'EUR5.50',
                  'https://picsum.photos/200/150',
                ),
                SizedBox(width: 16),
                _buildPopularDishCard(
                  'Combo regular',
                  'EUR9',
                  'https://picsum.photos/201/150',
                ),
                SizedBox(width: 16),
                _buildPopularDishCard(
                  'Nachos especiales',
                  'EUR14',
                  'https://picsum.photos/202/150',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Indicador de precio medio
          Row(
            children: [
              Icon(Icons.euro, color: Colors.teal, size: 16),
              SizedBox(width: 4),
              Text(
                'PRECIO MEDIO DE EUR16',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Lista de platos
          _buildDishItem(
            'Nachos especiales',
            'Totopos crujientes cubiertos con queso fundido, frijoles, guacamole, y pico de gallo vibrante.',
            'EUR14',
          ),
          _buildDishItem(
            'Papas especiales',
            'Patatas crujientes cubiertas con queso fundido, frijoles, guacamole, y pico de gallo vibrante.',
            'EUR13',
          ),
          _buildDishItem(
            'Molcajete',
            'Delicioso guacamole fresco servido en un auténtico molcajete. Acompañado de queso fresco mexicano, totopos y tortillas.',
            'EUR12',
          ),

          const SizedBox(height: 24),

          // Botón para ver toda la carta
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
  }

  Widget _buildDetailsSection() {
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
          // Google Maps section
          SizedBox(
            height: 200,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: _center,
                      zoom: 15.0,
                    ),
                    markers: _markers,
                    onMapCreated: (GoogleMapController controller) {
                      _mapController.complete(controller);
                    },
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Image.asset('assets/google_logo.png', height: 20),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Información adicional
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Información adicional',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Descripción
              _buildInfoRow(
                Icons.description_outlined,
                'Descripción',
                'Restaurant especializado en comida estilo americano con una variedad amplia de comida rápida, teniendo como especialidad las hamburguesas. Bar con variedad cocteles de autor y tradicionales, bebidas con y sin alcohol. Ambiente acogedor con tres diferentes areas preparadas para brindas un excelente servicio y una experiencia inolvidable para nuestros clientes.',
              ),

              const Divider(),

              // Teléfono
              _buildInfoRow(
                Icons.phone_outlined,
                'Teléfono',
                '75788100',
                valueColor: Colors.teal,
              ),

              const Divider(),

              // Precio
              _buildInfoRow(
                Icons.monetization_on_outlined,
                'Precio',
                'Hasta \$30',
              ),

              const Divider(),

              // Cocina
              _buildInfoRow(Icons.restaurant_menu, 'Cocina', 'Hamburguesas'),

              const Divider(),

              // Horarios
              _buildInfoRow(Icons.access_time, 'Horarios', 'Dom 16:00–23:00'),

              const Divider(),

              // Opciones de pago
              _buildInfoRow(
                Icons.credit_card,
                'Opciones de pago',
                'Mastercard, Visa',
              ),

              const Divider(),

              // Estacionamiento
              _buildInfoRow(
                Icons.local_parking,
                'Estacionamiento',
                'Estacionamiento en vía pública',
              ),

              const Divider(),

              // Código de etiqueta
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
                SizedBox(height: 80), // Espacio para el botón flotante
              ],
            ),
          ),

          // Sticky navigation bar that appears when scrolling past address
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
