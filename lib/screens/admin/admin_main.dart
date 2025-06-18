import 'package:flutter/material.dart';
import 'admin_restaurants.dart';
import 'admin_users.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({Key? key}) : super(key: key);

  @override
  _AdminMainScreenState createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isDrawerOpen = false;
  late AnimationController _fabAnimationController;
  late AnimationController _drawerAnimationController;

  // Datos de ejemplo para el dashboard
  final List<DashboardCard> _dashboardCards = [
    DashboardCard(
      title: 'Restaurantes Activos',
      value: '24',
      change: '+3',
      changePercent: '12.5%',
      icon: Icons.restaurant,
      color: Colors.green,
      isPositive: true,
    ),
    DashboardCard(
      title: 'Reservas Hoy',
      value: '156',
      change: '+28',
      changePercent: '21.8%',
      icon: Icons.event_available,
      color: Colors.blue,
      isPositive: true,
    ),
    DashboardCard(
      title: 'Usuarios Registrados',
      value: '1,247',
      change: '+89',
      changePercent: '7.7%',
      icon: Icons.people,
      color: Colors.purple,
      isPositive: true,
    ),
    DashboardCard(
      title: 'Ingresos Mensuales',
      value: '\$45,230',
      change: '-2,150',
      changePercent: '4.5%',
      icon: Icons.attach_money,
      color: Colors.orange,
      isPositive: false,
    ),
  ];

  static final List<Widget> _widgetOptions = <Widget>[
    AdminRestaurantsScreen(),
    AdminUsersScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _drawerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _drawerAnimationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _fabAnimationController.forward().then((_) {
      _fabAnimationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1419),
      appBar: _buildAppBar(),
      drawer: _buildModernDrawer(),
      body: _buildBody(),
      bottomNavigationBar: _buildModernBottomNavBar(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF1E2328),
      elevation: 0,
      leading: Builder(
        builder:
            (context) => IconButton(
              icon: AnimatedIcon(
                icon: AnimatedIcons.menu_arrow,
                progress:
                    _isDrawerOpen
                        ? const AlwaysStoppedAnimation(1.0)
                        : const AlwaysStoppedAnimation(0.0),
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _isDrawerOpen = !_isDrawerOpen;
                });
                Scaffold.of(context).openDrawer();
              },
            ),
      ),
      actions: [
        _buildProfileMenu(),
        _buildNotificationButton(),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4),
        child: Container(
          height: 4,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF4ECDC4).withOpacity(0.3),
                const Color(0xFF4ECDC4),
                const Color(0xFF4ECDC4).withOpacity(0.3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernDrawer() {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      backgroundColor: const Color(0xFF1E2328),
      child: Column(
        children: [
          _buildEnhancedDrawerHeader(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 12),
                _buildSectionTitle('GESTIÓN'),
                _buildModernDrawerItem(
                  icon: Icons.restaurant_menu_outlined,
                  title: 'Restaurantes',
                  subtitle: 'Gestionar establecimientos',
                  index: 0,
                  badgeCount: 3,
                ),
                _buildModernDrawerItem(
                  icon: Icons.people_outline,
                  title: 'Administradores',
                  subtitle: 'Control de usuarios admin',
                  index: 1,
                ),
              ],
            ),
          ),
          _buildModernDrawerFooter(),
        ],
      ),
    );
  }

  Widget _buildEnhancedDrawerHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4ECDC4), Color(0xFF2E8B86)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.admin_panel_settings,
                size: 28,
                color: Color(0xFF1E2328),
              ),
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Administrador General',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'admin@restaurantes.com',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Super Admin',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white.withOpacity(0.5),
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildModernDrawerItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required int index,
    int? badgeCount,
    bool isSpecial = false,
  }) {
    final isSelected = _selectedIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color:
            isSelected
                ? const Color(0xFF4ECDC4).withOpacity(0.15)
                : Colors.transparent,
        border:
            isSelected
                ? Border.all(color: const Color(0xFF4ECDC4).withOpacity(0.3))
                : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? const Color(0xFF4ECDC4)
                    : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.8),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.9),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
        ),
        trailing:
            badgeCount != null
                ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badgeCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                : isSelected
                ? const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF4ECDC4),
                  size: 20,
                )
                : null,
        onTap: () {
          if (index >= 0 && index < _widgetOptions.length) {
            _onItemTapped(index);
          } else if (isSpecial) {
            _showDashboard();
          }
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildModernDrawerFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1E2328), Color(0xFF0F1419)],
        ),
      ),
      child:
          _selectedIndex == -1
              ? _buildDashboard()
              : _widgetOptions.elementAt(_selectedIndex),
    );
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeSection(),
          const SizedBox(height: 24),
          _buildQuickStats(),
          const SizedBox(height: 24),
          _buildQuickActions(),
          const SizedBox(height: 24),
          _buildRecentActivity(),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4ECDC4), Color(0xFF2E8B86)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '¡Bienvenido de vuelta!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Administra tu red de restaurantes de forma eficiente',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _onItemTapped(0),
                  icon: const Icon(Icons.restaurant, color: Color(0xFF1E2328)),
                  label: const Text(
                    'Ver Restaurantes',
                    style: TextStyle(color: Color(0xFF1E2328)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.dashboard, size: 60, color: Colors.white24),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Estadísticas Rápidas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
          ),
          itemCount: _dashboardCards.length,
          itemBuilder: (context, index) {
            return _buildStatsCard(_dashboardCards[index]);
          },
        ),
      ],
    );
  }

  Widget _buildStatsCard(DashboardCard card) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF252D40),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(card.icon, color: card.color, size: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: card.isPositive ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${card.isPositive ? '+' : ''}${card.changePercent}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            card.value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            card.title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${card.isPositive ? '+' : ''}${card.change} vs mes anterior',
            style: TextStyle(
              color: card.isPositive ? Colors.green : Colors.red,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Acciones Rápidas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: Icons.add_business,
                title: 'Agregar Restaurante',
                subtitle: 'Registrar nuevo local',
                color: Colors.blue,
                onTap: () => _showAddRestaurantDialog(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                icon: Icons.person_add,
                title: 'Nuevo Admin',
                subtitle: 'Crear administrador',
                color: Colors.purple,
                onTap: () => _showAddAdminDialog(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF252D40),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Actividad Reciente',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => _showNotifications(),
              child: const Text(
                'Ver todas',
                style: TextStyle(color: Color(0xFF4ECDC4)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return _buildActivityItem(
              icon:
                  [Icons.restaurant, Icons.person_add, Icons.analytics][index],
              title:
                  [
                    'Nuevo restaurante registrado',
                    'Administrador agregado',
                  ][index],
              subtitle:
                  [
                    'Sabores del Mar - Zona Norte',
                    'María González - Sucursal Centro',
                  ][index],
              time: ['Hace 15 min', 'Hace 1 hora', 'Hace 2 horas'][index],
              color: [Colors.green, Colors.blue, Colors.orange][index],
            );
          },
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF252D40),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationButton() {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: _showNotifications,
          tooltip: 'Notificaciones',
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: const Text(
              '5',
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileMenu() {
    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF4ECDC4), width: 2),
        ),
        child: const CircleAvatar(
          radius: 14,
          backgroundColor: Color(0xFF4ECDC4),
          child: Text(
            'AG',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      onSelected: (value) {
        switch (value) {
          case 'profile':
            _showProfile();
            break;
          case 'settings':
            _openSettings();
            break;
          case 'logout':
            _logout();
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: 'profile',
            child: Row(
              children: [
                Icon(Icons.person, color: Color(0xFF0F1419)),
                SizedBox(width: 8),
                Text('Mi perfil'),
              ],
            ),
          ),
          const PopupMenuItem<String>(
            value: 'settings',
            child: Row(
              children: [
                Icon(Icons.settings, color: Color(0xFF0F1419)),
                SizedBox(width: 8),
                Text('Configuración'),
              ],
            ),
          ),
          const PopupMenuDivider(),
          const PopupMenuItem<String>(
            value: 'logout',
            child: Row(
              children: [
                Icon(Icons.logout, color: Colors.red),
                SizedBox(width: 8),
                Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ];
      },
    );
  }

  Widget _buildModernBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E2328),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: _buildNavIcon(Icons.restaurant_outlined, 0),
              activeIcon: _buildActiveNavIcon(Icons.restaurant, 0),
              label: 'Restaurantes',
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(Icons.people_outline, 1),
              activeIcon: _buildActiveNavIcon(Icons.people, 1),
              label: 'Administradores',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFF4ECDC4),
          unselectedItemColor: const Color(0xFF8B9AAB),
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Icon(icon, size: 24),
    );
  }

  Widget _buildActiveNavIcon(IconData icon, int index) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF4ECDC4).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: const Color(0xFF4ECDC4), size: 24),
    );
  }

  Widget _buildFloatingActionButton() {
    return ScaleTransition(
      scale: Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(
          parent: _fabAnimationController,
          curve: Curves.elasticOut,
        ),
      ),
      child: FloatingActionButton(
        onPressed: _showQuickActions,
        backgroundColor: const Color(0xFF4ECDC4),
        elevation: 8,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  // Métodos de utilidad
  String _getPageTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Gestión de Restaurantes';
      case 1:
        return 'Administradores Locales';
      case 2:
        return 'Reportes y Estadísticas';
      default:
        return 'Dashboard Principal';
    }
  }

  void _showDashboard() {
    setState(() {
      _selectedIndex = -1;
    });
  }

  void _showQuickActions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF1E2328),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Acciones Rápidas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    _buildQuickActionCard(
                      icon: Icons.add_business,
                      title: 'Agregar Restaurante',
                      color: Colors.blue,
                      onTap: () {
                        Navigator.pop(context);
                        _showAddRestaurantDialog();
                      },
                    ),
                    _buildQuickActionCard(
                      icon: Icons.person_add,
                      title: 'Nuevo Admin',
                      color: Colors.purple,
                      onTap: () {
                        Navigator.pop(context);
                        _showAddAdminDialog();
                      },
                    ),
                    _buildQuickActionCard(
                      icon: Icons.analytics,
                      title: 'Generar Reporte',
                      color: Colors.orange,
                      onTap: () {
                        Navigator.pop(context);
                        _generateReport();
                      },
                    ),
                    _buildQuickActionCard(
                      icon: Icons.settings,
                      title: 'Configuración',
                      color: Colors.green,
                      onTap: () {
                        Navigator.pop(context);
                        _openSettings();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF252D40),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF252D40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Buscar en el sistema',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Buscar restaurantes, usuarios, reportes...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF4ECDC4),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1E2328),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Búsquedas recientes:',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    _buildSearchChip('Restaurante "Sabores"'),
                    _buildSearchChip('Admin María González'),
                    _buildSearchChip('Reporte mensual'),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Color(0xFF4ECDC4)),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4ECDC4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Buscar'),
              ),
            ],
          ),
    );
  }

  Widget _buildSearchChip(String label) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 11),
      ),
      backgroundColor: const Color(0xFF1E2328),
      side: BorderSide(color: Colors.white.withOpacity(0.2)),
    );
  }

  void _showAddRestaurantDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF252D40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.restaurant, color: Colors.blue),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Agregar Restaurante',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogTextField('Nombre del restaurante'),
                const SizedBox(height: 12),
                _buildDialogTextField('Dirección'),
                const SizedBox(height: 12),
                _buildDialogTextField('Teléfono'),
                const SizedBox(height: 12),
                _buildDialogTextField('Email del administrador'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Color(0xFF4ECDC4)),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showSuccessSnackBar('Restaurante agregado exitosamente');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Agregar'),
              ),
            ],
          ),
    );
  }

  void _showAddAdminDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF252D40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_add, color: Colors.purple),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Nuevo Administrador',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogTextField('Nombre completo'),
                const SizedBox(height: 12),
                _buildDialogTextField('Email'),
                const SizedBox(height: 12),
                _buildDialogTextField('Teléfono'),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Rol',
                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    filled: true,
                    fillColor: const Color(0xFF1E2328),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  dropdownColor: const Color(0xFF1E2328),
                  style: const TextStyle(color: Colors.white),
                  items: const [
                    DropdownMenuItem(
                      value: 'admin',
                      child: Text('Administrador Local'),
                    ),
                    DropdownMenuItem(value: 'manager', child: Text('Gerente')),
                    DropdownMenuItem(
                      value: 'supervisor',
                      child: Text('Supervisor'),
                    ),
                  ],
                  onChanged: (value) {},
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Color(0xFF4ECDC4)),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showSuccessSnackBar('Administrador creado exitosamente');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Crear'),
              ),
            ],
          ),
    );
  }

  Widget _buildDialogTextField(String label) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        filled: true,
        fillColor: const Color(0xFF1E2328),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  void _generateReport() {
    _showSuccessSnackBar(
      'Generando reporte... Se enviará por email cuando esté listo',
    );
  }

  void _showProfile() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: const BoxDecoration(
              color: Color(0xFF1E2328),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFF4ECDC4),
                  child: Text(
                    'AG',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Administrador General',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'admin@restaurantes.com',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 20),
                _buildProfileInfoCard('Último acceso', 'Hoy, 14:30'),
                _buildProfileInfoCard('Restaurantes administrados', '24'),
                _buildProfileInfoCard('Tiempo en el cargo', '2 años, 5 meses'),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    // Implementar editar perfil
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar Perfil'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4ECDC4),
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildProfileInfoCard(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF252D40),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: Colors.white.withOpacity(0.7))),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: const BoxDecoration(
              color: Color(0xFF1E2328),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Notificaciones',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Marcar todas como leídas',
                              style: TextStyle(
                                color: Color(0xFF4ECDC4),
                                fontSize: 12,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return _buildEnhancedNotificationCard(
                        icon:
                            [
                              Icons.restaurant,
                              Icons.event_available,
                              Icons.warning,
                              Icons.analytics,
                              Icons.person_add,
                            ][index],
                        color:
                            [
                              Colors.green,
                              Colors.blue,
                              Colors.red,
                              Colors.orange,
                              Colors.purple,
                            ][index],
                        title:
                            [
                              'Nuevo restaurante registrado',
                              'Reserva confirmada',
                              'Problema reportado',
                              'Reporte mensual generado',
                              'Nuevo administrador agregado',
                            ][index],
                        subtitle:
                            [
                              'El restaurante "Sabores del Mar" ha sido agregado exitosamente',
                              'Mesa para 4 personas confirmada en Sucursal Norte',
                              'Sucursal Centro reportó un problema con el sistema de pagos',
                              'El reporte de ventas de junio está disponible para descargar',
                              'María González fue agregada como administradora local',
                            ][index],
                        time:
                            [
                              'Hace 15 min',
                              'Hace 1 hora',
                              'Hace 3 horas',
                              'Ayer',
                              'Hace 2 días',
                            ][index],
                        isNew: index < 2,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildEnhancedNotificationCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String time,
    required bool isNew,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF252D40),
        borderRadius: BorderRadius.circular(12),
        border: isNew ? Border.all(color: color.withOpacity(0.3)) : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            if (isNew)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'NUEVO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              time,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 11,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF8B9AAB)),
        onTap: () {
          // Implementar acción de notificación
        },
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF252D40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.logout, color: Colors.red),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Cerrar sesión',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: const Text(
              '¿Estás seguro que deseas salir de la aplicación? Se cerrará tu sesión actual.',
              style: TextStyle(color: Color(0xFF8B9AAB)),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Color(0xFF4ECDC4)),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Implementar lógica de logout
                  _showSuccessSnackBar('Sesión cerrada exitosamente');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Cerrar sesión'),
              ),
            ],
          ),
    );
  }

  void _openSettings() {
    // Implementar navegación a configuración
    _showSuccessSnackBar('Próximamente: Configuración del sistema');
  }
}

// Clase modelo para las tarjetas del dashboard
class DashboardCard {
  final String title;
  final String value;
  final String change;
  final String changePercent;
  final IconData icon;
  final Color color;
  final bool isPositive;

  DashboardCard({
    required this.title,
    required this.value,
    required this.change,
    required this.changePercent,
    required this.icon,
    required this.color,
    required this.isPositive,
  });
}
