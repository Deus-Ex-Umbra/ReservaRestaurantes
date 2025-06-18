import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminReservationsScreen extends StatefulWidget {
  @override
  _AdminReservationsScreenState createState() =>
      _AdminReservationsScreenState();
}

class _AdminReservationsScreenState extends State<AdminReservationsScreen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedFilter = 'Todas'; // 'Todas', 'Confirmadas', 'Pendientes'
  String _selectedTime = 'Todas';

  // Datos estáticos de ejemplo
  final List<Map<String, dynamic>> _reservations = [
    // Reservas confirmadas
    {
      'id': '#R001',
      'name': 'Juan Pérez',
      'guests': 4,
      'time': '19:00',
      'date': '2023-06-15',
      'status': 'confirmed',
      'phone': '+591 12345678',
      'email': 'juan@example.com',
      'specialRequests': 'Mesa cerca de la ventana',
      'table': 'Mesa 4',
    },
    {
      'id': '#R002',
      'name': 'María Gómez',
      'guests': 2,
      'time': '20:00',
      'date': '2023-06-15',
      'status': 'confirmed',
      'phone': '+591 87654321',
      'email': 'maria@example.com',
      'specialRequests': 'Sin gluten',
      'table': 'Mesa 2',
    },
    {
      'id': '#R003',
      'name': 'Carlos Ruiz',
      'guests': 6,
      'time': '21:00',
      'date': '2023-06-15',
      'status': 'confirmed',
      'phone': '+591 55555555',
      'email': 'carlos@example.com',
      'specialRequests': 'Celebración de cumpleaños',
      'table': 'Mesa Privada',
    },
    {
      'id': '#R004',
      'name': 'Ana López',
      'guests': 3,
      'time': '19:30',
      'date': '2023-06-15',
      'status': 'confirmed',
      'phone': '+591 44444444',
      'email': 'ana@example.com',
      'specialRequests': 'Quieren el menú degustación',
      'table': 'Mesa 5',
    },
    // Reservas pendientes
    {
      'id': '#R005',
      'name': 'Luis Martínez',
      'guests': 5,
      'time': '20:30',
      'date': '2023-06-15',
      'status': 'pending',
      'phone': '+591 33333333',
      'email': 'luis@example.com',
      'specialRequests': 'Alergia a los mariscos',
      'table': '',
    },
    {
      'id': '#R006',
      'name': 'Sofía Castro',
      'guests': 2,
      'time': '19:00',
      'date': '2023-06-15',
      'status': 'pending',
      'phone': '+591 22222222',
      'email': 'sofia@example.com',
      'specialRequests': 'Quieren mesa en terraza',
      'table': '',
    },
    {
      'id': '#R007',
      'name': 'Pedro Vargas',
      'guests': 8,
      'time': '21:30',
      'date': '2023-06-15',
      'status': 'pending',
      'phone': '+591 11111111',
      'email': 'pedro@example.com',
      'specialRequests': 'Grupo empresarial',
      'table': '',
    },
    {
      'id': '#R008',
      'name': 'Laura Méndez',
      'guests': 4,
      'time': '20:00',
      'date': '2023-06-16',
      'status': 'pending',
      'phone': '+591 99999999',
      'email': 'laura@example.com',
      'specialRequests': 'Cena romántica - flores en mesa',
      'table': '',
    },
  ];

  final List<String> _timeSlots = [
    'Todas',
    '12:00',
    '13:00',
    '14:00',
    '19:00',
    '20:00',
    '21:00',
    '22:00',
  ];

  @override
  Widget build(BuildContext context) {
    final filteredReservations =
        _reservations.where((res) {
          final matchesDate =
              res['date'] == DateFormat('yyyy-MM-dd').format(_selectedDate);
          final matchesStatus =
              _selectedFilter == 'Todas' ||
              (_selectedFilter == 'Confirmadas' &&
                  res['status'] == 'confirmed') ||
              (_selectedFilter == 'Pendientes' && res['status'] == 'pending');
          final matchesTime =
              _selectedTime == 'Todas' ||
              res['time'].startsWith(_selectedTime.split(':')[0]);

          return matchesDate && matchesStatus && matchesTime;
        }).toList();

    return Scaffold(
      backgroundColor: Color(0xFF0c0f14), // Fondo oscuro
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Gestión de Reservas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () => _showAddReservationDialog(context),
            tooltip: 'Agregar reserva',
          ),
        ],
      ),
      body: Column(
        children: [
          // Selector de fecha
          _buildDateSelector(),
          SizedBox(height: 10),

          // Filtros
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(child: _buildFilterDropdown()),
                SizedBox(width: 10),
                Expanded(child: _buildTimeDropdown()),
              ],
            ),
          ),
          SizedBox(height: 15),

          // Resumen
          _buildSummaryCards(),
          SizedBox(height: 15),

          // Lista de reservas
          Expanded(child: _buildReservationsList(filteredReservations)),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left, color: Colors.white),
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.subtract(Duration(days: 1));
              });
            },
            tooltip: 'Día anterior',
          ),
          GestureDetector(
            onTap: _selectDate,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Color(0xFF1A1F2E), // Tarjeta oscura
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Color(0xFF8B9AAB),
                  ), // Texto secundario
                  SizedBox(width: 10),
                  Text(
                    DateFormat('EEEE, d MMMM').format(_selectedDate),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right, color: Colors.white),
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.add(Duration(days: 1));
              });
            },
            tooltip: 'Día siguiente',
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1A1F2E), // Tarjeta oscura
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<String>(
        value: _selectedFilter,
        isExpanded: true,
        underline: Container(),
        icon: Icon(
          Icons.filter_list,
          color: Color(0xFF8B9AAB),
        ), // Texto secundario
        items:
            ['Todas', 'Confirmadas', 'Pendientes'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(color: Colors.white)),
              );
            }).toList(),
        onChanged: (newValue) {
          setState(() {
            _selectedFilter = newValue!;
          });
        },
        dropdownColor: Color(0xFF1A1F2E), // Tarjeta oscura
      ),
    );
  }

  Widget _buildTimeDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1A1F2E), // Tarjeta oscura
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<String>(
        value: _selectedTime,
        isExpanded: true,
        underline: Container(),
        icon: Icon(
          Icons.access_time,
          color: Color(0xFF8B9AAB),
        ), // Texto secundario
        items:
            _timeSlots.map((String time) {
              return DropdownMenuItem<String>(
                value: time,
                child: Text(time, style: TextStyle(color: Colors.white)),
              );
            }).toList(),
        onChanged: (newValue) {
          setState(() {
            _selectedTime = newValue!;
          });
        },
        dropdownColor: Color(0xFF1A1F2E), // Tarjeta oscura
      ),
    );
  }

  Widget _buildSummaryCards() {
    final todayReservations =
        _reservations
            .where(
              (res) =>
                  res['date'] == DateFormat('yyyy-MM-dd').format(_selectedDate),
            )
            .toList();
    final confirmedCount =
        todayReservations.where((res) => res['status'] == 'confirmed').length;
    final pendingCount =
        todayReservations.where((res) => res['status'] == 'pending').length;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'Confirmadas',
              confirmedCount,
              Color(0xFF4CAF50), // Verde
              Icons.check_circle,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _buildSummaryCard(
              'Pendientes',
              pendingCount,
              Color(0xFFFF9800), // Naranja
              Icons.access_time,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _buildSummaryCard(
              'Total',
              todayReservations.length,
              Color(0xFF2196F3), // Azul
              Icons.people,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    int count,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF1A1F2E), // Tarjeta oscura
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Color(0xFF8B9AAB), // Texto secundario
                  fontSize: 12,
                ),
              ),
              Text(
                count.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReservationsList(List<Map<String, dynamic>> reservations) {
    if (reservations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_note,
              size: 50,
              color: Color(0xFF8B9AAB),
            ), // Texto secundario
            SizedBox(height: 10),
            Text(
              'No hay reservas para esta fecha',
              style: TextStyle(
                color: Color(0xFF8B9AAB), // Texto secundario
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20),
      itemCount: reservations.length,
      itemBuilder: (context, index) {
        final reservation = reservations[index];
        return _buildReservationCard(reservation);
      },
    );
  }

  Widget _buildReservationCard(Map<String, dynamic> reservation) {
    final isConfirmed = reservation['status'] == 'confirmed';
    final statusColor = isConfirmed ? Color(0xFF4CAF50) : Color(0xFFFF9800);
    final statusText = isConfirmed ? 'Confirmada' : 'Pendiente';
    final tableText =
        reservation['table']?.isNotEmpty == true
            ? reservation['table']
            : 'Sin mesa asignada';

    return Card(
      margin: EdgeInsets.only(bottom: 15),
      color: Color(0xFF1A1F2E), // Tarjeta oscura
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showReservationDetails(context, reservation),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isConfirmed ? Icons.check_circle : Icons.access_time,
                      size: 20,
                      color: statusColor,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reservation['name'],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '${reservation['guests']} personas • ${reservation['time']}',
                          style: TextStyle(
                            color: Color(0xFF8B9AAB), // Texto secundario
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Divider(color: Colors.grey[800], height: 1),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.phone,
                    size: 16,
                    color: Color(0xFF8B9AAB),
                  ), // Texto secundario
                  SizedBox(width: 5),
                  Text(
                    reservation['phone'],
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  SizedBox(width: 15),
                  Icon(
                    Icons.table_restaurant,
                    size: 16,
                    color: Color(0xFF8B9AAB),
                  ), // Texto secundario
                  SizedBox(width: 5),
                  Text(
                    tableText,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
              if (reservation['specialRequests'].isNotEmpty) ...[
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.star,
                      size: 16,
                      color: Color(0xFF8B9AAB),
                    ), // Texto secundario
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        reservation['specialRequests'],
                        style: TextStyle(color: Colors.white, fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    reservation['id'],
                    style: TextStyle(
                      color: Color(0xFF8B9AAB), // Texto secundario
                      fontSize: 12,
                    ),
                  ),
                  if (!isConfirmed)
                    ElevatedButton(
                      onPressed: () => _confirmReservation(reservation['id']),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4ECDC4), // Turquesa
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Confirmar',
                        style: TextStyle(color: Colors.white, fontSize: 12),
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

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Color(0xFF4ECDC4), // Turquesa
              onPrimary: Colors.white,
              surface: Color(0xFF1A1F2E), // Tarjeta oscura
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Color(0xFF0c0f14), // Fondo oscuro
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _confirmReservation(String reservationId) {
    setState(() {
      final index = _reservations.indexWhere(
        (res) => res['id'] == reservationId,
      );
      if (index != -1) {
        _reservations[index]['status'] = 'confirmed';
        _reservations[index]['table'] = _assignTable();
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reserva $reservationId confirmada'),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _assignTable() {
    // Lógica simple para asignar mesa
    final tables = [
      'Mesa 1',
      'Mesa 2',
      'Mesa 3',
      'Mesa 4',
      'Mesa 5',
      'Mesa Privada',
    ];
    return tables[_reservations.length % tables.length];
  }

  void _showReservationDetails(
    BuildContext context,
    Map<String, dynamic> reservation,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF1A1F2E), // Tarjeta oscura
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Detalles de Reserva',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildDetailItem('ID Reserva', reservation['id']),
              _buildDetailItem('Nombre', reservation['name']),
              _buildDetailItem('Teléfono', reservation['phone']),
              _buildDetailItem('Email', reservation['email']),
              _buildDetailItem('Fecha', reservation['date']),
              _buildDetailItem('Hora', reservation['time']),
              _buildDetailItem('Personas', reservation['guests'].toString()),
              _buildDetailItem(
                'Mesa',
                reservation['table']?.isNotEmpty == true
                    ? reservation['table']
                    : 'Sin asignar',
              ),
              _buildDetailItem(
                'Estado',
                reservation['status'] == 'confirmed'
                    ? 'Confirmada'
                    : 'Pendiente',
              ),
              if (reservation['specialRequests'].isNotEmpty)
                _buildDetailItem('Solicitudes', reservation['specialRequests']),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0xFF4ECDC4)), // Turquesa
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Cerrar',
                        style: TextStyle(color: Color(0xFF4ECDC4)), // Turquesa
                      ),
                    ),
                  ),
                  if (reservation['status'] != 'confirmed') ...[
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _confirmReservation(reservation['id']);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4ECDC4), // Turquesa
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Confirmar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Color(0xFF8B9AAB), // Texto secundario
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddReservationDialog(BuildContext context) {
    // Implementar diálogo para agregar nueva reserva
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1A1F2E), // Tarjeta oscura
          title: Text('Agregar Reserva', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    labelStyle: TextStyle(
                      color: Color(0xFF8B9AAB),
                    ), // Texto secundario
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF8B9AAB),
                      ), // Texto secundario
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                // Agregar más campos según necesidad
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: TextStyle(color: Color(0xFF8B9AAB)),
              ), // Texto secundario
            ),
            ElevatedButton(
              onPressed: () {
                // Lógica para agregar reserva
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4ECDC4), // Turquesa
              ),
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}
