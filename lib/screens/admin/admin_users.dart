import 'package:flutter/material.dart';

class AdminUsersScreen extends StatefulWidget {
  @override
  _AdminUsersScreenState createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  String _searchQuery = '';

  List<Map<String, dynamic>> admins = [
    {
      'id': '1',
      'name': 'María García',
      'email': 'maria@example.com',
      'restaurant': 'La Trattoria',
      'phone': '+591 123-4567',
      'status': 'active',
      'createdAt': '15 Feb 2024',
      'lastLogin': '2 horas',
    },
    {
      'id': '2',
      'name': 'Carlos López',
      'email': 'carlos@example.com',
      'restaurant': 'Sushi Palace',
      'phone': '+591 987-6543',
      'status': 'active',
      'createdAt': '10 Feb 2024',
      'lastLogin': '1 día',
    },
    {
      'id': '3',
      'name': 'Ana Mendoza',
      'email': 'ana@example.com',
      'restaurant': 'Carnes Premium',
      'phone': '+591 456-7890',
      'status': 'inactive',
      'createdAt': '8 Feb 2024',
      'lastLogin': '5 días',
    },
    {
      'id': '4',
      'name': 'Pendiente',
      'email': '',
      'restaurant': 'Café Central',
      'phone': '',
      'status': 'pending',
      'createdAt': '1 Feb 2024',
      'lastLogin': 'Nunca',
    },
  ];

  List<String> availableRestaurants = [
    'Café Central',
    'Pizzería Roma',
    'Restaurante El Fogón',
    'Mariscos del Puerto',
    'Asados Don José',
  ];

  @override
  Widget build(BuildContext context) {
    final filteredAdmins =
        admins.where((admin) {
          return admin['name'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              admin['restaurant'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              admin['email'].toLowerCase().contains(_searchQuery.toLowerCase());
        }).toList();

    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
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
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColorDark,
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddAdminDialog(context),
        icon: const Icon(Icons.person_add_alt_1, size: 22),
        label: const Text('Agregar Admin', style: TextStyle(fontSize: 14)),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.075,
        ),
        child: Column(
          children: [
            // Header con estadísticas
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatCard(
                    'Total',
                    admins.length.toString(),
                    Colors.blue,
                    Icons.people_alt_outlined,
                  ),
                  _buildStatCard(
                    'Activos',
                    admins
                        .where((a) => a['status'] == 'active')
                        .length
                        .toString(),
                    Colors.green,
                    Icons.check_circle_outline,
                  ),
                  _buildStatCard(
                    'Pendientes',
                    admins
                        .where((a) => a['status'] == 'pending')
                        .length
                        .toString(),
                    Colors.orange,
                    Icons.access_time_outlined,
                  ),
                  _buildStatCard(
                    'Inactivos',
                    admins
                        .where((a) => a['status'] == 'inactive')
                        .length
                        .toString(),
                    Colors.red,
                    Icons.pause_circle_outlined,
                  ),
                ],
              ),
            ),

            // Barra de búsqueda
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Buscar por nombre, restaurante o email...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).primaryColor,
                  ),
                  suffixIcon:
                      _searchQuery.isNotEmpty
                          ? IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey[500]),
                            onPressed: () => setState(() => _searchQuery = ''),
                          )
                          : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),

            // Lista de administradores
            Expanded(
              child:
                  filteredAdmins.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 100),
                        itemCount: filteredAdmins.length,
                        itemBuilder: (context, index) {
                          final admin = filteredAdmins[index];
                          return _buildAdminCard(context, admin);
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.18,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 72, color: Colors.grey[300]),
          const SizedBox(height: 20),
          Text(
            'No se encontraron administradores',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Intenta con otros términos de búsqueda',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _showAddAdminDialog(context),
            icon: Icon(Icons.person_add, size: 18),
            label: Text('Agregar nuevo administrador'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminCard(BuildContext context, Map<String, dynamic> admin) {
    final isPending = admin['status'] == 'pending';
    final isActive = admin['status'] == 'active';
    final isInactive = admin['status'] == 'inactive';

    Color statusColor = Colors.grey;
    String statusText = 'Inactivo';
    IconData statusIcon = Icons.pause_circle;
    Color statusBgColor = Colors.grey.withOpacity(0.1);

    if (isActive) {
      statusColor = Color(0xFF10B981);
      statusText = 'Activo';
      statusIcon = Icons.check_circle;
      statusBgColor = Color(0xFFECFDF5);
    } else if (isPending) {
      statusColor = Color(0xFFF59E0B);
      statusText = 'Pendiente';
      statusIcon = Icons.access_time;
      statusBgColor = Color(0xFFFFFBEB);
    } else if (isInactive) {
      statusColor = Color(0xFFEF4444);
      statusText = 'Inactivo';
      statusIcon = Icons.pause_circle;
      statusBgColor = Color(0xFFFEF2F2);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con estado y acciones
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusBgColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              border: Border(
                bottom: BorderSide(color: Colors.grey.withOpacity(0.1)),
              ),
            ),
            child: Row(
              children: [
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 16, color: statusColor),
                      const SizedBox(width: 6),
                      Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 12,
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Menu de acciones
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected:
                      (value) => _handleMenuAction(context, value, admin),
                  itemBuilder:
                      (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 18, color: Colors.blue),
                              SizedBox(width: 8),
                              Text('Editar'),
                            ],
                          ),
                        ),
                        if (!isPending) ...[
                          PopupMenuItem(
                            value: 'reset_password',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.lock_reset,
                                  size: 18,
                                  color: Colors.blue,
                                ),
                                SizedBox(width: 8),
                                Text('Restablecer contraseña'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: isActive ? 'deactivate' : 'activate',
                            child: Row(
                              children: [
                                Icon(
                                  isActive
                                      ? Icons.person_off
                                      : Icons.person_add,
                                  size: 18,
                                  color:
                                      isActive ? Colors.orange : Colors.green,
                                ),
                                SizedBox(width: 8),
                                Text(isActive ? 'Desactivar' : 'Activar'),
                              ],
                            ),
                          ),
                        ],
                        if (isPending)
                          const PopupMenuItem(
                            value: 'activate',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.person_add,
                                  size: 18,
                                  color: Colors.green,
                                ),
                                SizedBox(width: 8),
                                Text('Activar cuenta'),
                              ],
                            ),
                          ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 18, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Eliminar'),
                            ],
                          ),
                        ),
                      ],
                ),
              ],
            ),
          ),

          // Contenido principal
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre y avatar
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        size: 24,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            admin['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          if (admin['email'].isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              admin['email'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Información del restaurante
                _buildInfoRow(
                  Icons.restaurant,
                  admin['restaurant'],
                  Theme.of(context).primaryColor,
                ),

                if (admin['phone'].isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.phone, admin['phone'], Colors.blue),
                ],

                const SizedBox(height: 16),

                // Footer con metadata
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      _buildMetaDataItem(
                        Icons.access_time,
                        'Último acceso: ${admin['lastLogin']}',
                      ),
                      const Spacer(),
                      _buildMetaDataItem(
                        Icons.calendar_today,
                        'Creado: ${admin['createdAt']}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color iconColor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetaDataItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey[500]),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  // Resto de los métodos permanecen iguales (handleMenuAction, showDialogs, etc.)
  void _handleMenuAction(
    BuildContext context,
    String action,
    Map<String, dynamic> admin,
  ) {
    switch (action) {
      case 'edit':
        _showEditAdminDialog(context, admin);
        break;
      case 'reset_password':
        _showConfirmationDialog(
          context,
          '¿Restablecer contraseña?',
          'Se enviará un enlace de restablecimiento a ${admin['email']}.',
          Colors.blue,
          () => _resetPassword(admin),
        );
        break;
      case 'activate':
        if (admin['status'] == 'pending') {
          _showConfirmationDialog(
            context,
            '¿Activar cuenta?',
            'Se enviará un correo de activación a este administrador.',
            Colors.green,
            () => _activateAdmin(admin),
          );
        } else {
          _showConfirmationDialog(
            context,
            '¿Reactivar administrador?',
            '${admin['name']} recuperará acceso al sistema.',
            Colors.green,
            () => _toggleAdminStatus(admin, 'active'),
          );
        }
        break;
      case 'deactivate':
        _showConfirmationDialog(
          context,
          '¿Desactivar administrador?',
          '${admin['name']} perderá acceso temporal al sistema.',
          Colors.orange,
          () => _toggleAdminStatus(admin, 'inactive'),
        );
        break;
      case 'delete':
        _showDeleteConfirmationDialog(context, admin);
        break;
    }
  }

  void _showAddAdminDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    String? selectedRestaurant;

    final unassignedRestaurants =
        availableRestaurants.where((restaurant) {
          return !admins.any((admin) => admin['restaurant'] == restaurant);
        }).toList();

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Agregar Nuevo Administrador',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre completo *',
                      prefixIcon: Icon(Icons.person, color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Correo electrónico *',
                      prefixIcon: Icon(Icons.email, color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: 'Teléfono',
                      prefixIcon: Icon(Icons.phone, color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedRestaurant,
                    decoration: InputDecoration(
                      labelText: 'Restaurante asignado *',
                      prefixIcon: Icon(
                        Icons.restaurant,
                        color: Colors.grey[600],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    items:
                        unassignedRestaurants.map((restaurant) {
                          return DropdownMenuItem(
                            value: restaurant,
                            child: Text(restaurant),
                          );
                        }).toList(),
                    onChanged: (value) => selectedRestaurant = value,
                    validator:
                        (value) =>
                            value == null ? 'Selecciona un restaurante' : null,
                  ),
                  if (unassignedRestaurants.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Todos los restaurantes ya tienen un administrador asignado',
                        style: TextStyle(color: Colors.red[600], fontSize: 12),
                      ),
                    ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed:
                            unassignedRestaurants.isEmpty
                                ? null
                                : () {
                                  if (nameController.text.isNotEmpty &&
                                      emailController.text.isNotEmpty &&
                                      selectedRestaurant != null) {
                                    _addNewAdmin(
                                      nameController.text,
                                      emailController.text,
                                      phoneController.text,
                                      selectedRestaurant!,
                                    );
                                    Navigator.pop(context);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Por favor, completa todos los campos obligatorios',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Guardar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _showEditAdminDialog(BuildContext context, Map<String, dynamic> admin) {
    final nameController = TextEditingController(text: admin['name']);
    final emailController = TextEditingController(text: admin['email']);
    final phoneController = TextEditingController(text: admin['phone']);
    String selectedRestaurant = admin['restaurant'];

    final availableForEdit =
        availableRestaurants.where((restaurant) {
          return restaurant == admin['restaurant'] ||
              !admins.any((a) => a['restaurant'] == restaurant);
        }).toList();

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Editar Administrador',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre completo *',
                      prefixIcon: Icon(Icons.person, color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Correo electrónico *',
                      prefixIcon: Icon(Icons.email, color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: 'Teléfono',
                      prefixIcon: Icon(Icons.phone, color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedRestaurant,
                    decoration: InputDecoration(
                      labelText: 'Restaurante asignado *',
                      prefixIcon: Icon(
                        Icons.restaurant,
                        color: Colors.grey[600],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    items:
                        availableForEdit.map((restaurant) {
                          return DropdownMenuItem(
                            value: restaurant,
                            child: Text(restaurant),
                          );
                        }).toList(),
                    onChanged: (value) => selectedRestaurant = value!,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          if (nameController.text.isNotEmpty &&
                              emailController.text.isNotEmpty) {
                            _updateAdmin(
                              admin['id'],
                              nameController.text,
                              emailController.text,
                              phoneController.text,
                              selectedRestaurant,
                            );
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Guardar cambios'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _showConfirmationDialog(
    BuildContext context,
    String title,
    String message,
    Color actionColor,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onConfirm();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: actionColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Confirmar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    Map<String, dynamic> admin,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '¿Eliminar administrador?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Esta acción no se puede deshacer.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Se eliminará permanentemente:',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• ${admin['name']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('• Restaurante: ${admin['restaurant']}'),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning, color: Colors.red[600], size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'El restaurante quedará sin administrador',
                            style: TextStyle(
                              color: Colors.red[700],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _deleteAdmin(admin);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Eliminar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  // Métodos de funcionalidad
  void _addNewAdmin(
    String name,
    String email,
    String phone,
    String restaurant,
  ) {
    setState(() {
      admins.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': name,
        'email': email,
        'restaurant': restaurant,
        'phone': phone,
        'status': 'pending',
        'createdAt': 'Hoy',
        'lastLogin': 'Nunca',
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Administrador "$name" agregado exitosamente'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'Enviar invitación',
          textColor: Colors.white,
          onPressed: () {
            // Lógica para enviar invitación
          },
        ),
      ),
    );
  }

  void _updateAdmin(
    String id,
    String name,
    String email,
    String phone,
    String restaurant,
  ) {
    setState(() {
      final index = admins.indexWhere((admin) => admin['id'] == id);
      if (index != -1) {
        admins[index] = {
          ...admins[index],
          'name': name,
          'email': email,
          'phone': phone,
          'restaurant': restaurant,
        };
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Información actualizada exitosamente'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _deleteAdmin(Map<String, dynamic> admin) {
    setState(() {
      admins.removeWhere((a) => a['id'] == admin['id']);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Administrador "${admin['name']}" eliminado'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'Deshacer',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              admins.add(admin);
            });
          },
        ),
      ),
    );
  }

  void _toggleAdminStatus(Map<String, dynamic> admin, String newStatus) {
    setState(() {
      final index = admins.indexWhere((a) => a['id'] == admin['id']);
      if (index != -1) {
        admins[index]['status'] = newStatus;
      }
    });

    final message =
        newStatus == 'active'
            ? 'Administrador reactivado exitosamente'
            : 'Administrador desactivado temporalmente';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: newStatus == 'active' ? Colors.green : Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _activateAdmin(Map<String, dynamic> admin) {
    setState(() {
      final index = admins.indexWhere((a) => a['id'] == admin['id']);
      if (index != -1) {
        admins[index]['status'] = 'active';
        admins[index]['lastLogin'] = 'Recién activado';
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cuenta activada y correo de bienvenida enviado'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          //borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _resetPassword(Map<String, dynamic> admin) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Enlace de restablecimiento enviado a ${admin['email']}'),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  String _getPageTitle() {
    return 'Administradores de restaurantes';
  }
}
