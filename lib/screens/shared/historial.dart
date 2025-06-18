import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservasScreen extends StatefulWidget {
  @override
  _ReservasScreenState createState() => _ReservasScreenState();
}

class _ReservasScreenState extends State<ReservasScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Datos estáticos de ejemplo mejorados
  final List<Reservation> reservations = [
    Reservation(
      id: 'RES-001',
      date: DateTime.now().add(Duration(days: 2)),
      time: '19:30',
      guestCount: 4,
      tableNumber: 12,
      status: 'Confirmada',
      createdAt: DateTime.now().subtract(Duration(days: 1)),
      restaurantName: 'La Trattoria',
      restaurantAddress: 'Av. Principal 123, Ciudad',
      restaurantPhone: '+1 234 567 890',
      paymentMethod: 'Tarjeta Visa terminada en 4242',
    ),
    Reservation(
      id: 'RES-002',
      date: DateTime.now().add(Duration(days: 5)),
      time: '20:00',
      guestCount: 2,
      tableNumber: 5,
      status: 'Pendiente',
      createdAt: DateTime.now().subtract(Duration(hours: 3)),
      restaurantName: 'Sushi Palace',
      restaurantAddress: 'Calle Sushi 456, Ciudad',
      restaurantPhone: '+1 987 654 321',
    ),
    Reservation(
      id: 'RES-003',
      date: DateTime.now().add(Duration(days: 7)),
      time: '14:00',
      guestCount: 6,
      tableNumber: 8,
      status: 'Cancelada',
      createdAt: DateTime.now().subtract(Duration(days: 2)),
      restaurantName: 'Carnes Premium',
      restaurantAddress: 'Boulevard Carnes 789, Ciudad',
      restaurantPhone: '+1 555 123 4567',
      cancellationReason: 'Cambio de planes',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FoodieBackground(
        foodOpacity: 0.08,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 30,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return AnimatedBuilder(
                      animation: _fadeAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, 30 * (1 - _fadeAnimation.value)),
                          child: Opacity(
                            opacity: _fadeAnimation.value,
                            child: _buildReservationCard(
                              context,
                              reservations[index],
                              index,
                            ),
                          ),
                        );
                      },
                    );
                  }, childCount: reservations.length),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReservationCard(
    BuildContext context,
    Reservation reservation,
    int index,
  ) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.only(bottom: 24),
      child: MouseRegion(
        onEnter: (_) => setState(() {}),
        onExit: (_) => setState(() {}),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.white.withOpacity(0.95)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: Offset(0, 8),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.blue.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
                spreadRadius: 2,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => _showReservationDetails(context, reservation),
              splashColor: Colors.blue.withOpacity(0.1),
              highlightColor: Colors.blue.withOpacity(0.05),
              child: Container(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Encabezado mejorado
                    _buildEnhancedHeader(reservation),
                    SizedBox(height: 20),

                    // Información principal con nuevo diseño
                    _buildMainInfo(reservation),
                    SizedBox(height: 16),

                    // Información del restaurante mejorada
                    _buildRestaurantInfo(reservation),

                    // Separador elegante
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.grey.withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),

                    // Footer mejorado
                    _buildEnhancedFooter(context, reservation),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedHeader(Reservation reservation) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.withOpacity(0.1),
                      Colors.blue.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  'Reservación #${reservation.id}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1565C0),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildStatusBadge(reservation.status),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color statusColor = _getStatusColor(status);
    IconData statusIcon = _getStatusIcon(status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            statusColor.withOpacity(0.15),
            statusColor.withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: statusColor.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 16, color: statusColor),
          SizedBox(width: 6),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              color: statusColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainInfo(Reservation reservation) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF8FBFF), Color(0xFFF0F7FF)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.1), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildInfoItem(
              Icons.calendar_today_rounded,
              DateFormat('EEE, dd MMM').format(reservation.date).toUpperCase(),
              reservation.time,
              Colors.blue,
            ),
          ),
          Container(
            width: 1,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.grey.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Expanded(
            child: _buildInfoItem(
              Icons.people_rounded,
              '${reservation.guestCount} ${reservation.guestCount == 1 ? 'Persona' : 'Personas'}',
              'Mesa ${reservation.tableNumber}',
              Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    IconData icon,
    String primary,
    String secondary,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.15), color.withOpacity(0.08)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 24, color: color),
        ),
        SizedBox(height: 8),
        Text(
          primary,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 4),
        Text(
          secondary,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildRestaurantInfo(Reservation reservation) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.orange.withOpacity(0.15),
                  Colors.orange.withOpacity(0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.restaurant_rounded,
              size: 20,
              color: Colors.orange[700],
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              reservation.restaurantName ?? 'Restaurante no especificado',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedFooter(BuildContext context, Reservation reservation) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 14,
                color: Colors.grey[600],
              ),
              SizedBox(width: 4),
              Text(
                'Reservado el ${DateFormat('dd MMM yyyy').format(reservation.createdAt)}',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        MouseRegion(
          onEnter: (_) => setState(() {}),
          onExit: (_) => setState(() {}),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            child: ElevatedButton.icon(
              onPressed: () => _showReservationDetails(context, reservation),
              icon: Icon(Icons.visibility_rounded, size: 16),
              label: Text(
                'Ver detalles',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1976D2),
                foregroundColor: Colors.white,
                elevation: 4,
                shadowColor: Color(0xFF1976D2).withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showReservationDetails(BuildContext context, Reservation reservation) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FoodieBackground(
          foodOpacity: 0.05,
          showBurger: false,
          showDrink: false,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Color(0xFFF8FBFF)],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Handle mejorado
                Container(
                  margin: EdgeInsets.only(top: 12),
                  width: 60,
                  height: 6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.grey[300]!, Colors.grey[400]!],
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                SizedBox(height: 20),

                // Título mejorado
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF1976D2).withOpacity(0.15),
                              Color(0xFF1976D2).withOpacity(0.08),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.receipt_long_rounded,
                          color: Color(0xFF1976D2),
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Detalles de la reservación',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1565C0),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // Tarjeta de resumen mejorada
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.white, Color(0xFFF0F7FF)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.1),
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildEnhancedHeader(reservation),
                      SizedBox(height: 20),
                      _buildMainInfo(reservation),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Lista de detalles mejorada
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: ListView(
                      children: [
                        _buildDetailItem(
                          Icons.restaurant_rounded,
                          'Restaurante',
                          reservation.restaurantName ?? 'No especificado',
                          Colors.orange,
                        ),
                        _buildDetailItem(
                          Icons.location_on_rounded,
                          'Dirección',
                          reservation.restaurantAddress ?? 'No especificada',
                          Colors.red,
                        ),
                        _buildDetailItem(
                          Icons.phone_rounded,
                          'Teléfono',
                          reservation.restaurantPhone ?? 'No especificado',
                          Colors.green,
                        ),
                        if (reservation.paymentMethod != null)
                          _buildDetailItem(
                            Icons.payment_rounded,
                            'Método de pago',
                            reservation.paymentMethod!,
                            Colors.purple,
                          ),
                        if (reservation.cancellationReason != null)
                          _buildDetailItem(
                            Icons.cancel_rounded,
                            'Razón de cancelación',
                            reservation.cancellationReason!,
                            Colors.red,
                          ),
                        _buildDetailItem(
                          Icons.access_time_rounded,
                          'Reservado el',
                          DateFormat(
                            'dd MMMM yyyy - HH:mm',
                          ).format(reservation.createdAt),
                          Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ),

                // Botones de acción mejorados
                Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.close_rounded),
                          label: Text('Cerrar'),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            side: BorderSide(
                              color: Color(0xFF1976D2),
                              width: 2,
                            ),
                            foregroundColor: Color(0xFF1976D2),
                          ),
                        ),
                      ),
                      if (reservation.status.toLowerCase() != 'cancelada') ...[
                        SizedBox(width: 15),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Acción para cancelar reserva
                            },
                            icon: Icon(Icons.cancel_rounded),
                            label: Text('Cancelar Reserva'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[500],
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 4,
                              shadowColor: Colors.red.withOpacity(0.4),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(
    IconData icon,
    String title,
    String value,
    Color color,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.15), color.withOpacity(0.08)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: color),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmada':
        return Colors.green[600]!;
      case 'pendiente':
        return Colors.orange[600]!;
      case 'cancelada':
        return Colors.red[600]!;
      case 'completada':
        return Colors.blue[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'confirmada':
        return Icons.check_circle_rounded;
      case 'pendiente':
        return Icons.schedule_rounded;
      case 'cancelada':
        return Icons.cancel_rounded;
      case 'completada':
        return Icons.task_alt_rounded;
      default:
        return Icons.help_rounded;
    }
  }
}

class Reservation {
  final String id;
  final DateTime date;
  final String time;
  final int guestCount;
  final int tableNumber;
  final String status;
  final DateTime createdAt;
  final String? restaurantName;
  final String? restaurantAddress;
  final String? restaurantPhone;
  final String? paymentMethod;
  final String? cancellationReason;

  Reservation({
    required this.id,
    required this.date,
    required this.time,
    required this.guestCount,
    required this.tableNumber,
    required this.status,
    required this.createdAt,
    this.restaurantName,
    this.restaurantAddress,
    this.restaurantPhone,
    this.paymentMethod,
    this.cancellationReason,
  });
}

class FoodieBackground extends StatelessWidget {
  final Widget? child;
  final double foodOpacity;
  final bool showSaladBowl;
  final bool showBurger;
  final bool showFries;
  final bool showDrink;
  final bool showPizza;
  final bool showTaco;

  const FoodieBackground({
    Key? key,
    this.child,
    this.foodOpacity = 0.15,
    this.showSaladBowl = true,
    this.showBurger = true,
    this.showFries = true,
    this.showDrink = true,
    this.showPizza = true,
    this.showTaco = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fondo base
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB), Color(0xFF90CAF9)],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
        ),

        // Elementos de comida decorativos
        if (showSaladBowl)
          Positioned(
            top: 100,
            right: 50,
            child: Opacity(
              opacity: foodOpacity,
              child: Icon(Icons.ramen_dining, size: 120, color: Colors.green),
            ),
          ),

        if (showBurger)
          Positioned(
            bottom: 150,
            left: 30,
            child: Opacity(
              opacity: foodOpacity,
              child: Icon(Icons.lunch_dining, size: 100, color: Colors.brown),
            ),
          ),

        if (showFries)
          Positioned(
            top: 300,
            left: 70,
            child: Opacity(
              opacity: foodOpacity,
              child: Icon(Icons.fastfood, size: 80, color: Colors.yellow[700]),
            ),
          ),

        if (showDrink)
          Positioned(
            bottom: 200,
            right: 80,
            child: Opacity(
              opacity: foodOpacity,
              child: Icon(Icons.local_drink, size: 90, color: Colors.red),
            ),
          ),

        if (showPizza)
          Positioned(
            top: 200,
            left: 100,
            child: Opacity(
              opacity: foodOpacity,
              child: Icon(Icons.local_pizza, size: 110, color: Colors.orange),
            ),
          ),

        if (showTaco)
          Positioned(
            bottom: 100,
            right: 100,
            child: Opacity(
              opacity: foodOpacity,
              child: Icon(Icons.tapas, size: 70, color: Colors.yellow[600]),
            ),
          ),

        // Contenido principal
        if (child != null) child!,
      ],
    );
  }
}
