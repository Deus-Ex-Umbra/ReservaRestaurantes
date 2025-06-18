import 'package:flutter/material.dart';

class AdminRestaurantsScreen extends StatefulWidget {
  @override
  _AdminRestaurantsScreenState createState() => _AdminRestaurantsScreenState();
}

class _AdminRestaurantsScreenState extends State<AdminRestaurantsScreen> {
  int _selectedFilter = 0; // 0: Todos, 1: Activos, 2: Inactivos, 3: Sin admin
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Map<String, dynamic>> restaurants = [
    {
      'id': 1,
      'name': 'La Trattoria',
      'location': 'Centro, Calle Principal #123',
      'status': 'Activo',
      'admin': 'Maria García',
      'email': 'maria@latrattoria.com',
      'phone': '+591 4 456 7890',
      'capacity': 120,
      'rating': 4.8,
      'totalReviews': 256,
      'todayReservations': 15,
      'totalReservations': 1250,
      'revenue': 45600.0,
      'category': 'Italiana',
      'openTime': '12:00',
      'closeTime': '23:00',
      'createdAt': '2024-01-15',
    },
    {
      'id': 3,
      'name': 'Carnes Premium',
      'location': 'Zona Sur, Boulevard Carnes #789',
      'status': 'Inactivo',
      'admin': 'Sin asignar',
      'email': 'info@carnespremium.com',
      'phone': '+591 4 456 7892',
      'capacity': 150,
      'rating': 4.2,
      'totalReviews': 134,
      'todayReservations': 0,
      'totalReservations': 567,
      'revenue': 18900.0,
      'category': 'Parrilla',
      'openTime': '13:00',
      'closeTime': '00:00',
      'createdAt': '2024-03-10',
    },
  ];

  List<Map<String, dynamic>> get filteredRestaurants {
    List<Map<String, dynamic>> filtered = restaurants;

    // Aplicar filtro por búsqueda
    if (_searchQuery.isNotEmpty) {
      filtered =
          filtered.where((r) {
            return r['name'].toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                r['location'].toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                r['admin'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
                r['category'].toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                );
          }).toList();
    }

    // Aplicar filtro por estado
    switch (_selectedFilter) {
      case 1:
        return filtered.where((r) => r['status'] == 'Activo').toList();
      case 2:
        return filtered.where((r) => r['status'] == 'Inactivo').toList();
      case 3:
        return filtered.where((r) => r['admin'] == 'Sin asignar').toList();
      default:
        return filtered;
    }
  }

  String _getPageTitle() {
    switch (_selectedFilter) {
      case 1:
        return 'Restaurantes Activos';
      case 2:
        return 'Restaurantes Inactivos';
      case 3:
        return 'Restaurantes sin Administrador';
      default:
        return 'Todos los Restaurantes';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Panel de Administración',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Text(
              _getPageTitle(),
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.7),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.primaryColor,
                theme.primaryColorDark ?? theme.primaryColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addRestaurant,
        icon: const Icon(Icons.add_business),
        label: const Text('Nuevo Restaurante'),
        backgroundColor: theme.primaryColor,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient:
              isDarkMode
                  ? LinearGradient(
                    colors: [Colors.grey[900]!, Colors.grey[850]!],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                  : LinearGradient(
                    colors: [Colors.grey[100]!, Colors.grey[50]!],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildSearchAndFilters(isDarkMode, screenWidth),
              _buildStatsOverview(screenWidth),
              _buildRestaurantsList(screenWidth),
              const SizedBox(height: 80), // Space for FAB
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters(bool isDarkMode, double screenWidth) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: screenWidth * 0.90,
      child: Column(
        children: [
          // Barra de búsqueda
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, ubicación, administrador...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    _searchQuery.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),
          const SizedBox(height: 16),

          // Filtros
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              spacing: 8,
              children: [
                _buildFilterChip('Todos', 0, Icons.restaurant),
                _buildFilterChip('Activos', 1, Icons.check_circle),
                _buildFilterChip('Inactivos', 2, Icons.pause_circle),
                _buildFilterChip('Sin Admin', 3, Icons.person_off),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int index, IconData icon) {
    final isSelected = _selectedFilter == index;
    final theme = Theme.of(context);

    return ChoiceChip(
      avatar: Icon(
        icon,
        size: 18,
        color: isSelected ? theme.primaryColor : Colors.grey,
      ),
      label: Text(
        label,
        style: TextStyle(color: isSelected ? theme.primaryColor : null),
      ),
      selected: isSelected,
      onSelected: (bool value) {
        setState(() => _selectedFilter = value ? index : 0);
      },
      selectedColor: theme.primaryColor.withOpacity(0.2),
      backgroundColor: Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: isSelected ? 2 : 0,
      pressElevation: 1,
    );
  }

  Widget _buildStatsOverview(double screenWidth) {
    final totalRestaurants = restaurants.length;
    final activeRestaurants =
        restaurants.where((r) => r['status'] == 'Activo').length;
    final todayReservations = restaurants.fold(
      0,
      (sum, r) => sum + (r['todayReservations'] as int),
    );
    final totalRevenue = restaurants.fold(
      0.0,
      (sum, r) => sum + (r['revenue'] as double),
    );

    return Container(
      width: screenWidth * 0.85,
      padding: const EdgeInsets.only(bottom: 16),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: [
          _buildStatCard(
            'Total',
            '$totalRestaurants',
            Icons.restaurant,
            Colors.blueAccent,
          ),
          _buildStatCard(
            'Activos',
            '$activeRestaurants',
            Icons.check_circle,
            Colors.greenAccent,
          ),
          _buildStatCard(
            'Reservas Hoy',
            '$todayReservations',
            Icons.today,
            Colors.orangeAccent,
          ),
          _buildStatCard(
            'Ingresos',
            '\$${(totalRevenue / 1000).toStringAsFixed(1)}K',
            Icons.attach_money,
            Colors.purpleAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      shadowColor: color.withOpacity(0.2),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRestaurantsList(double screenWidth) {
    return Container(
      width: screenWidth * 0.85,
      padding: const EdgeInsets.only(bottom: 20),
      child:
          filteredRestaurants.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredRestaurants.length,
                itemBuilder: (context, index) {
                  return _buildRestaurantCard(filteredRestaurants[index]);
                },
              ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No se encontraron restaurantes',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            'Intenta cambiar los filtros o agregar un nuevo restaurante',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _addRestaurant,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Agregar Restaurante'),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantCard(Map<String, dynamic> restaurant) {
    final isActive = restaurant['status'] == 'Activo';
    final hasAdmin = restaurant['admin'] != 'Sin asignar';
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        shadowColor: theme.primaryColor.withOpacity(0.1),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => _viewRestaurantDetails(restaurant),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors:
                    isDarkMode
                        ? [Colors.grey[800]!, Colors.grey[850]!]
                        : [Colors.white, Colors.grey[50]!],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Encabezado
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              restaurant['name'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              restaurant['category'],
                              style: TextStyle(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildStatusBadge(restaurant['status']),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Información clave
                  _buildInfoItem(
                    Icons.location_on,
                    restaurant['location'],
                    Colors.redAccent,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoItem(
                    Icons.person,
                    hasAdmin ? restaurant['admin'] : 'Sin administrador',
                    hasAdmin ? Colors.greenAccent : Colors.orangeAccent,
                  ),

                  const SizedBox(height: 16),

                  // Métricas importantes
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildMetricChip(
                        Icons.people,
                        '${restaurant['capacity']} personas',
                        Colors.blueAccent,
                      ),
                      _buildMetricChip(
                        Icons.star,
                        '${restaurant['rating']} (${restaurant['totalReviews']})',
                        Colors.amber,
                      ),
                      _buildMetricChip(
                        Icons.today,
                        '${restaurant['todayReservations']} hoy',
                        Colors.greenAccent,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Botones de acción
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _buildActionButton(
                            Icons.edit,
                            'Editar',
                            () => _editRestaurant(restaurant),
                            Colors.blueAccent,
                          ),
                          const SizedBox(width: 8),
                          _buildActionButton(
                            Icons.calendar_today,
                            'Reservas',
                            () => _viewReservations(restaurant),
                            Colors.purpleAccent,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          if (isActive)
                            _buildActionButton(
                              Icons.pause,
                              'Desactivar',
                              () => _toggleRestaurantStatus(restaurant, false),
                              Colors.orangeAccent,
                            )
                          else
                            _buildActionButton(
                              Icons.play_arrow,
                              'Activar',
                              () => _toggleRestaurantStatus(restaurant, true),
                              Colors.greenAccent,
                            ),
                          const SizedBox(width: 8),
                          _buildActionButton(
                            Icons.more_vert,
                            '',
                            () => _showMoreOptions(restaurant),
                            Colors.grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final isActive = status == 'Activo';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color:
            isActive
                ? Colors.green.withOpacity(0.1)
                : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isActive ? Colors.green : Colors.red,
          width: 1.5,
        ),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: isActive ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14),
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    VoidCallback onPressed,
    Color color,
  ) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Métodos de funcionalidad (se mantienen iguales)
  void _refreshData() {
    setState(() {
      // Simular refresh de datos
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Datos actualizados'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        ),
      ),
    );
  }

  void _showStatistics() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Estadísticas Generales'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total de restaurantes: ${restaurants.length}'),
                Text(
                  'Restaurantes activos: ${restaurants.where((r) => r['status'] == 'Activo').length}',
                ),
                Text(
                  'Reservas hoy: ${restaurants.fold(0, (sum, r) => sum + (r['todayReservations'] as int))}',
                ),
                Text(
                  'Ingresos totales: \$${restaurants.fold(0.0, (sum, r) => sum + (r['revenue'] as double)).toStringAsFixed(2)}',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ],
          ),
    );
  }

  void _addRestaurant() {
    showDialog(
      context: context,
      builder: (context) => _buildRestaurantDialog(),
    );
  }

  void _editRestaurant(Map<String, dynamic> restaurant) {
    showDialog(
      context: context,
      builder: (context) => _buildRestaurantDialog(restaurant: restaurant),
    );
  }

  Widget _buildRestaurantDialog({Map<String, dynamic>? restaurant}) {
    final isEditing = restaurant != null;
    final nameController = TextEditingController(
      text: restaurant?['name'] ?? '',
    );
    final locationController = TextEditingController(
      text: restaurant?['location'] ?? '',
    );
    final categoryController = TextEditingController(
      text: restaurant?['category'] ?? '',
    );
    final capacityController = TextEditingController(
      text: restaurant?['capacity']?.toString() ?? '',
    );
    final adminController = TextEditingController(
      text: restaurant?['admin'] ?? '',
    );
    final emailController = TextEditingController(
      text: restaurant?['email'] ?? '',
    );
    final phoneController = TextEditingController(
      text: restaurant?['phone'] ?? '',
    );

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isEditing ? 'Editar Restaurante' : 'Nuevo Restaurante',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del restaurante',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.restaurant),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: locationController,
                      decoration: const InputDecoration(
                        labelText: 'Ubicación',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_on),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: categoryController,
                      decoration: const InputDecoration(
                        labelText: 'Categoría',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.category),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: capacityController,
                      decoration: const InputDecoration(
                        labelText: 'Capacidad',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.people),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: adminController,
                      decoration: const InputDecoration(
                        labelText: 'Administrador',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Teléfono',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('El nombre es obligatorio'),
                        ),
                      );
                      return;
                    }

                    final newRestaurant = {
                      'id':
                          isEditing
                              ? restaurant!['id']
                              : restaurants.length + 1,
                      'name': nameController.text,
                      'location': locationController.text,
                      'category': categoryController.text,
                      'capacity': int.tryParse(capacityController.text) ?? 0,
                      'admin':
                          adminController.text.isEmpty
                              ? 'Sin asignar'
                              : adminController.text,
                      'email': emailController.text,
                      'phone': phoneController.text,
                      'status': 'Activo',
                      'rating': 0.0,
                      'totalReviews': 0,
                      'todayReservations': 0,
                      'totalReservations': 0,
                      'revenue': 0.0,
                      'openTime': '09:00',
                      'closeTime': '22:00',
                      'createdAt': DateTime.now().toString().substring(0, 10),
                    };

                    setState(() {
                      if (isEditing) {
                        final index = restaurants.indexWhere(
                          (r) => r['id'] == restaurant!['id'],
                        );
                        if (index != -1) {
                          restaurants[index] = {
                            ...restaurants[index],
                            ...newRestaurant,
                          };
                        }
                      } else {
                        restaurants.add(newRestaurant);
                      }
                    });

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isEditing
                              ? 'Restaurante actualizado'
                              : 'Restaurante agregado',
                        ),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(isEditing ? 'Actualizar' : 'Agregar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _viewRestaurantDetails(Map<String, dynamic> restaurant) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          restaurant['name'],
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _buildStatusBadge(restaurant['status']),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      restaurant['category'],
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                      ),
                    ),
                    const Divider(height: 30),
                    _buildDetailRow(
                      'Ubicación',
                      restaurant['location'],
                      Icons.location_on,
                      Colors.redAccent,
                    ),
                    _buildDetailRow(
                      'Administrador',
                      restaurant['admin'],
                      Icons.person,
                      Colors.greenAccent,
                    ),
                    _buildDetailRow(
                      'Email',
                      restaurant['email'],
                      Icons.email,
                      Colors.blueAccent,
                    ),
                    _buildDetailRow(
                      'Teléfono',
                      restaurant['phone'],
                      Icons.phone,
                      Colors.tealAccent,
                    ),
                    _buildDetailRow(
                      'Capacidad',
                      '${restaurant['capacity']} personas',
                      Icons.people,
                      Colors.blueGrey,
                    ),
                    _buildDetailRow(
                      'Estado',
                      restaurant['status'],
                      Icons.circle_notifications,
                      Colors.orangeAccent,
                    ),
                    _buildDetailRow(
                      'Rating',
                      '${restaurant['rating']} (${restaurant['totalReviews']} reseñas)',
                      Icons.star,
                      Colors.amber,
                    ),
                    _buildDetailRow(
                      'Reservas hoy',
                      '${restaurant['todayReservations']}',
                      Icons.today,
                      Colors.greenAccent,
                    ),
                    _buildDetailRow(
                      'Total reservas',
                      '${restaurant['totalReservations']}',
                      Icons.calendar_today,
                      Colors.purpleAccent,
                    ),
                    _buildDetailRow(
                      'Ingresos',
                      '\$${restaurant['revenue']}',
                      Icons.attach_money,
                      Colors.green,
                    ),
                    _buildDetailRow(
                      'Horario',
                      '${restaurant['openTime']} - ${restaurant['closeTime']}',
                      Icons.access_time,
                      Colors.indigoAccent,
                    ),
                    _buildDetailRow(
                      'Fecha de registro',
                      restaurant['createdAt'],
                      Icons.date_range,
                      Colors.brown,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Cerrar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _viewReservations(Map<String, dynamic> restaurant) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Reservas - ${restaurant['name']}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Reservas de hoy: ${restaurant['todayReservations']}'),
                Text('Total de reservas: ${restaurant['totalReservations']}'),
                const SizedBox(height: 16),
                const Text('Aquí se mostraría la lista detallada de reservas'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ],
          ),
    );
  }

  void _toggleRestaurantStatus(Map<String, dynamic> restaurant, bool activate) {
    final action = activate ? 'activar' : 'desactivar';
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('${activate ? 'Activar' : 'Desactivar'} restaurante'),
            content: Text('¿Estás seguro de $action ${restaurant['name']}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    restaurant['status'] = activate ? 'Activo' : 'Inactivo';
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Restaurante ${activate ? 'activado' : 'desactivado'}',
                      ),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
                child: Text(activate ? 'Activar' : 'Desactivar'),
              ),
            ],
          ),
    );
  }

  void _showMoreOptions(Map<String, dynamic> restaurant) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    restaurant['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info, color: Colors.blue),
                  title: const Text('Ver detalles'),
                  onTap: () {
                    Navigator.pop(context);
                    _viewRestaurantDetails(restaurant);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.analytics, color: Colors.green),
                  title: const Text('Ver estadísticas'),
                  onTap: () {
                    Navigator.pop(context);
                    _showRestaurantStats(restaurant);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.phone, color: Colors.purple),
                  title: const Text('Contactar administrador'),
                  onTap: () {
                    Navigator.pop(context);
                    _contactAdmin(restaurant);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person_add, color: Colors.orange),
                  title: const Text('Asignar administrador'),
                  onTap: () {
                    Navigator.pop(context);
                    _assignAdmin(restaurant);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Eliminar restaurante'),
                  onTap: () {
                    Navigator.pop(context);
                    _deleteRestaurant(restaurant);
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
    );
  }

  void _showRestaurantStats(Map<String, dynamic> restaurant) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Estadísticas - ${restaurant['name']}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatRow('Rating promedio', '${restaurant['rating']} ⭐'),
                _buildStatRow(
                  'Total de reseñas',
                  '${restaurant['totalReviews']}',
                ),
                _buildStatRow(
                  'Reservas hoy',
                  '${restaurant['todayReservations']}',
                ),
                _buildStatRow(
                  'Total reservas',
                  '${restaurant['totalReservations']}',
                ),
                _buildStatRow(
                  'Ingresos generados',
                  '\$${restaurant['revenue']}',
                ),
                _buildStatRow(
                  'Capacidad',
                  '${restaurant['capacity']} personas',
                ),
                _buildStatRow(
                  'Fecha de registro',
                  '${restaurant['createdAt']}',
                ),
                const SizedBox(height: 12),
                const Text(
                  'Rendimiento del mes:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value:
                      restaurant['todayReservations'] / restaurant['capacity'],
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    restaurant['todayReservations'] / restaurant['capacity'] >
                            0.7
                        ? Colors.green
                        : restaurant['todayReservations'] /
                                restaurant['capacity'] >
                            0.4
                        ? Colors.orange
                        : Colors.red,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ocupación hoy: ${((restaurant['todayReservations'] / restaurant['capacity']) * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ],
          ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _contactAdmin(Map<String, dynamic> restaurant) {
    if (restaurant['admin'] == 'Sin asignar') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Este restaurante no tiene administrador asignado'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            //borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Contactar - ${restaurant['admin']}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.email, color: Colors.blue),
                  title: const Text('Enviar email'),
                  subtitle: Text(restaurant['email']),
                  onTap: () {
                    Navigator.pop(context);
                    // Implementar funcionalidad de email
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Abriendo email para ${restaurant['email']}',
                        ),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.phone, color: Colors.green),
                  title: const Text('Llamar'),
                  subtitle: Text(restaurant['phone']),
                  onTap: () {
                    Navigator.pop(context);
                    // Implementar funcionalidad de llamada
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Llamando a ${restaurant['phone']}'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.message, color: Colors.purple),
                  title: const Text('Enviar mensaje'),
                  onTap: () {
                    Navigator.pop(context);
                    _sendMessage(restaurant);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
            ],
          ),
    );
  }

  void _sendMessage(Map<String, dynamic> restaurant) {
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Mensaje para ${restaurant['admin']}'),
            content: TextField(
              controller: messageController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Escribe tu mensaje aquí...',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (messageController.text.isNotEmpty) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Mensaje enviado a ${restaurant['admin']}',
                        ),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Enviar'),
              ),
            ],
          ),
    );
  }

  void _assignAdmin(Map<String, dynamic> restaurant) {
    final adminController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Asignar Administrador - ${restaurant['name']}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: adminController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del administrador',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (adminController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'El nombre del administrador es obligatorio',
                        ),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          //borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                    return;
                  }

                  setState(() {
                    restaurant['admin'] = adminController.text;
                    if (emailController.text.isNotEmpty) {
                      restaurant['email'] = emailController.text;
                    }
                    if (phoneController.text.isNotEmpty) {
                      restaurant['phone'] = phoneController.text;
                    }
                  });

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Administrador asignado a ${restaurant['name']}',
                      ),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
                child: const Text('Asignar'),
              ),
            ],
          ),
    );
  }

  void _deleteRestaurant(Map<String, dynamic> restaurant) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Eliminar Restaurante'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.warning, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  '¿Estás seguro de eliminar "${restaurant['name']}"?',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Esta acción no se puede deshacer y se perderán todos los datos asociados.',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    restaurants.removeWhere((r) => r['id'] == restaurant['id']);
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${restaurant['name']} eliminado correctamente',
                      ),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }
}
