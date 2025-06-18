import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class BuscarSucursalesScreen extends StatefulWidget {
  @override
  _BuscarSucursalesScreenState createState() => _BuscarSucursalesScreenState();
}

class _BuscarSucursalesScreenState extends State<BuscarSucursalesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Todas';
  String _selectedMetric = 'Ventas';

  final List<String> _filters = [
    'Todas',
    'Centro',
    'Norte',
    'Sur',
    'Este',
    'Oeste',
  ];

  final List<String> _metrics = ['Ventas', 'Ocupación', 'Rating', 'Empleados'];

  final List<Map<String, dynamic>> _sucursales = [
    {
      'nombre': 'Sucursal Centro',
      'direccion': 'Av. Principal #123, Centro',
      'telefono': '+591 12345678',
      'gerente': 'Juan Pérez',
      'ventasMes': 125000,
      'ventasAnio': 1500000,
      'empleados': 15,
      'rating': 4.5,
      'imagen': 'assets/sucursal1.jpg',
      'zona': 'Centro',
      'status': 'Excelente',
      'ocupacionPromedio': 85,
      'clientesFrecuentes': 320,
      'costosOperacion': 85000,
      'utilidad': 40000,
      'horario': 'Lunes a Domingo: 11:00 - 23:00',
      'especialidad': 'Comida Gourmet',
      'metodosPago': ['Efectivo', 'Tarjeta', 'Transferencia'],
      'inventario': {'stockBajo': 8, 'stockCritico': 3, 'totalProductos': 150},
      'personal': {
        'turnoMañana': 6,
        'turnoTarde': 5,
        'ausenciasMes': 2,
        'capacitaciones': 3,
      },
    },
    {
      'nombre': 'Sucursal Norte',
      'direccion': 'Av. Norte #456, Zona Norte',
      'telefono': '+591 87654321',
      'gerente': 'María Gómez',
      'ventasMes': 98000,
      'ventasAnio': 1176000,
      'empleados': 12,
      'rating': 4.2,
      'imagen': 'assets/sucursal2.jpg',
      'zona': 'Norte',
      'status': 'Bueno',
      'ocupacionPromedio': 75,
      'clientesFrecuentes': 280,
      'costosOperacion': 65000,
      'utilidad': 33000,
      'horario': 'Lunes a Domingo: 11:00 - 22:30',
      'especialidad': 'Carnes',
      'metodosPago': ['Efectivo', 'Tarjeta'],
      'inventario': {'stockBajo': 12, 'stockCritico': 5, 'totalProductos': 120},
      'personal': {
        'turnoMañana': 5,
        'turnoTarde': 4,
        'ausenciasMes': 3,
        'capacitaciones': 2,
      },
    },
    {
      'nombre': 'Sucursal Sur',
      'direccion': 'Calle Sur #789, Zona Sur',
      'telefono': '+591 56781234',
      'gerente': 'Carlos Ruiz',
      'ventasMes': 75000,
      'ventasAnio': 900000,
      'empleados': 10,
      'rating': 3.9,
      'imagen': 'assets/sucursal3.jpg',
      'zona': 'Sur',
      'status': 'Regular',
      'ocupacionPromedio': 65,
      'clientesFrecuentes': 210,
      'costosOperacion': 55000,
      'utilidad': 20000,
      'horario': 'Lunes a Sábado: 11:00 - 22:00',
      'especialidad': 'Comida Rápida',
      'metodosPago': ['Efectivo', 'Tarjeta'],
      'inventario': {'stockBajo': 15, 'stockCritico': 7, 'totalProductos': 110},
      'personal': {
        'turnoMañana': 4,
        'turnoTarde': 4,
        'ausenciasMes': 5,
        'capacitaciones': 1,
      },
    },
    {
      'nombre': 'Sucursal Este',
      'direccion': 'Av. Este #321, Zona Este',
      'telefono': '+591 43218765',
      'gerente': 'Ana López',
      'ventasMes': 110000,
      'ventasAnio': 1320000,
      'empleados': 14,
      'rating': 4.3,
      'imagen': 'assets/sucursal4.jpg',
      'zona': 'Este',
      'status': 'Bueno',
      'ocupacionPromedio': 80,
      'clientesFrecuentes': 290,
      'costosOperacion': 75000,
      'utilidad': 35000,
      'horario': 'Lunes a Domingo: 11:00 - 23:00',
      'especialidad': 'Mariscos',
      'metodosPago': ['Efectivo', 'Tarjeta', 'Transferencia'],
      'inventario': {'stockBajo': 10, 'stockCritico': 4, 'totalProductos': 130},
      'personal': {
        'turnoMañana': 6,
        'turnoTarde': 5,
        'ausenciasMes': 2,
        'capacitaciones': 2,
      },
    },
    {
      'nombre': 'Sucursal Oeste',
      'direccion': 'Calle Oeste #654, Zona Oeste',
      'telefono': '+591 98765432',
      'gerente': 'Luis Martínez',
      'ventasMes': 85000,
      'ventasAnio': 1020000,
      'empleados': 11,
      'rating': 4.0,
      'imagen': 'assets/sucursal5.jpg',
      'zona': 'Oeste',
      'status': 'Bueno',
      'ocupacionPromedio': 70,
      'clientesFrecuentes': 250,
      'costosOperacion': 60000,
      'utilidad': 25000,
      'horario': 'Lunes a Domingo: 11:00 - 22:30',
      'especialidad': 'Comida Internacional',
      'metodosPago': ['Efectivo', 'Tarjeta'],
      'inventario': {'stockBajo': 9, 'stockCritico': 3, 'totalProductos': 125},
      'personal': {
        'turnoMañana': 5,
        'turnoTarde': 4,
        'ausenciasMes': 3,
        'capacitaciones': 2,
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0c0f14),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Gestión de Sucursales',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.bar_chart, color: Colors.white),
            onPressed: _showComparativeAnalysis,
            tooltip: 'Análisis comparativo',
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: EdgeInsets.all(15),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF1A1F2E),
                prefixIcon: Icon(Icons.search, color: Color(0xFF8B9AAB)),
                hintText: 'Buscar sucursales...',
                hintStyle: TextStyle(color: Color(0xFF8B9AAB)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),

          // Filtros
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: _buildFilterDropdown(
                    'Zona',
                    _filters,
                    _selectedFilter,
                    (value) => setState(() => _selectedFilter = value),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildFilterDropdown(
                    'Métrica',
                    _metrics,
                    _selectedMetric,
                    (value) => setState(() => _selectedMetric = value),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),

          // Resumen general
          _buildSummaryCards(),
          SizedBox(height: 15),

          // Lista de sucursales
          Expanded(child: _buildSucursalesList()),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(
    String label,
    List<String> items,
    String selectedValue,
    Function(String) onChanged,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1A1F2E),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<String>(
        value: selectedValue,
        isExpanded: true,
        underline: Container(),
        icon: Icon(Icons.arrow_drop_down, color: Color(0xFF8B9AAB)),
        items:
            items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(color: Colors.white)),
              );
            }).toList(),
        onChanged: (newValue) => onChanged(newValue!),
        dropdownColor: Color(0xFF1A1F2E),
        hint: Text(label, style: TextStyle(color: Color(0xFF8B9AAB))),
      ),
    );
  }

  Widget _buildSummaryCards() {
    final totalVentas = _sucursales.fold(
      0,
      (sum, suc) => (sum as int) + (suc['ventasMes'] as int),
    );
    final promedioRating =
        _sucursales.fold(0.0, (sum, suc) => sum + suc['rating']) /
        _sucursales.length;
    final totalEmpleados = _sucursales.fold(
      0,
      (sum, suc) => sum + (suc['empleados'] as int),
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'Ventas Totales',
              '\$${totalVentas.toStringAsFixed(0)}',
              Icons.attach_money,
              Color(0xFF4CAF50),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _buildSummaryCard(
              'Rating Promedio',
              promedioRating.toStringAsFixed(1),
              Icons.star,
              Color(0xFFFFC107),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _buildSummaryCard(
              'Empleados',
              totalEmpleados.toString(),
              Icons.people,
              Color(0xFF2196F3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF1A1F2E),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Color(0xFF8B9AAB), fontSize: 12)),
          SizedBox(height: 5),
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              SizedBox(width: 10),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSucursalesList() {
    final filteredSucursales =
        _sucursales.where((suc) {
          final matchesFilter =
              _selectedFilter == 'Todas' || suc['zona'] == _selectedFilter;
          final matchesSearch =
              _searchController.text.isEmpty ||
              suc['nombre'].toLowerCase().contains(
                _searchController.text.toLowerCase(),
              );
          return matchesFilter && matchesSearch;
        }).toList();

    if (filteredSucursales.isEmpty) {
      return Center(
        child: Text(
          'No se encontraron sucursales',
          style: TextStyle(color: Color(0xFF8B9AAB)),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      itemCount: filteredSucursales.length,
      itemBuilder: (context, index) {
        final sucursal = filteredSucursales[index];
        return _buildSucursalCard(sucursal);
      },
    );
  }

  Widget _buildSucursalCard(Map<String, dynamic> sucursal) {
    double metricValue;
    String metricUnit = '';
    Color metricColor;

    switch (_selectedMetric) {
      case 'Ventas':
        metricValue = sucursal['ventasMes'].toDouble();
        metricUnit = '\$';
        metricColor = Color(0xFF4CAF50);
        break;
      case 'Ocupación':
        metricValue = sucursal['ocupacionPromedio'].toDouble();
        metricUnit = '%';
        metricColor = Color(0xFF2196F3);
        break;
      case 'Rating':
        metricValue = sucursal['rating'].toDouble();
        metricColor = Color(0xFFFFC107);
        break;
      case 'Empleados':
        metricValue = sucursal['empleados'].toDouble();
        metricColor = Color(0xFF9C27B0);
        break;
      default:
        metricValue = 0;
        metricColor = Colors.grey;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 15),
      color: Color(0xFF1A1F2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showSucursalDetails(context, sucursal),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen de la sucursal
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      sucursal['imagen'],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[800],
                            child: Icon(Icons.store, color: Colors.grey),
                          ),
                    ),
                  ),
                  SizedBox(width: 15),

                  // Información principal
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sucursal['nombre'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          sucursal['direccion'],
                          style: TextStyle(
                            color: Color(0xFF8B9AAB),
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              size: 14,
                              color: Color(0xFF8B9AAB),
                            ),
                            SizedBox(width: 5),
                            Text(
                              sucursal['gerente'],
                              style: TextStyle(
                                color: Color(0xFF8B9AAB),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Estado y métrica principal
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            sucursal['status'],
                          ).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getStatusColor(sucursal['status']),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          sucursal['status'],
                          style: TextStyle(
                            color: _getStatusColor(sucursal['status']),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '$metricUnit${metricValue.toStringAsFixed(_selectedMetric == 'Rating' ? 1 : 0)}',
                        style: TextStyle(
                          color: metricColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _selectedMetric,
                        style: TextStyle(
                          color: Color(0xFF8B9AAB),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 15),

              // Métricas rápidas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickMetric(
                    'Ventas',
                    '\$${sucursal['ventasMes'].toStringAsFixed(0)}',
                    Icons.attach_money,
                    Color(0xFF4CAF50),
                  ),
                  _buildQuickMetric(
                    'Ocupación',
                    '${sucursal['ocupacionPromedio']}%',
                    Icons.people_alt,
                    Color(0xFF2196F3),
                  ),
                  _buildQuickMetric(
                    'Rating',
                    sucursal['rating'].toStringAsFixed(1),
                    Icons.star,
                    Color(0xFFFFC107),
                  ),
                  _buildQuickMetric(
                    'Empleados',
                    sucursal['empleados'].toString(),
                    Icons.people,
                    Color(0xFF9C27B0),
                  ),
                ],
              ),
              SizedBox(height: 10),

              // Botón de acción
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showSucursalDetails(context, sucursal),
                  icon: Icon(Icons.analytics, size: 18),
                  label: Text('Ver Desempeño Completo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4ECDC4),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickMetric(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, size: 16, color: color),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: TextStyle(color: Color(0xFF8B9AAB), fontSize: 10)),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Excelente':
        return Color(0xFF4CAF50);
      case 'Bueno':
        return Color(0xFF8BC34A);
      case 'Regular':
        return Color(0xFFFFC107);
      case 'Crítico':
        return Color(0xFFF44336);
      default:
        return Color(0xFF9E9E9E);
    }
  }

  void _showSucursalDetails(
    BuildContext context,
    Map<String, dynamic> sucursal,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF1A1F2E),
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.85,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    sucursal['nombre'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Divider(color: Colors.grey[800]),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Información básica
                      _buildDetailSection('Información General', Icons.info, [
                        _buildDetailItem('Dirección', sucursal['direccion']),
                        _buildDetailItem('Teléfono', sucursal['telefono']),
                        _buildDetailItem('Gerente', sucursal['gerente']),
                        _buildDetailItem('Zona', sucursal['zona']),
                        _buildDetailItem('Horario', sucursal['horario']),
                        _buildDetailItem(
                          'Especialidad',
                          sucursal['especialidad'],
                        ),
                        _buildDetailItem(
                          'Métodos de Pago',
                          sucursal['metodosPago'].join(', '),
                        ),
                      ]),

                      // Gráfico de reservas semanales (reemplazando el de ventas)
                      SizedBox(height: 20),
                      Text(
                        'Reservas Semanales',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 250,
                        child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(
                            labelStyle: TextStyle(color: Color(0xFF8B9AAB)),
                          ),
                          primaryYAxis: NumericAxis(
                            labelStyle: TextStyle(color: Color(0xFF8B9AAB)),
                          ),
                          series: <CartesianSeries>[
                            ColumnSeries<ReservationData, String>(
                              dataSource: weeklyReservations,
                              xValueMapper:
                                  (ReservationData data, _) => data.day,
                              yValueMapper:
                                  (ReservationData data, _) =>
                                      data.reservations,
                              color: Color(0xFFd17842), // Naranja
                              dataLabelSettings: DataLabelSettings(
                                isVisible: true,
                                textStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
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

  List<Map<String, dynamic>> _generateMonthlySales(int currentSales) {
    final months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'];
    final random = Random();
    return months.map((month) {
      final variation = (random.nextDouble() * 0.3) - 0.15; // -15% a +15%
      return {'month': month, 'sales': currentSales * (1 + variation)};
    }).toList();
  }

  Widget _buildDetailSection(
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Row(
          children: [
            Icon(icon, size: 20, color: Color(0xFF4ECDC4)),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        ...children,
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Color(0xFF8B9AAB), fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showComparativeAnalysis() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF1A1F2E),
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              Text(
                'Análisis Comparativo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(
                    labelStyle: TextStyle(color: Color(0xFF8B9AAB)),
                  ),
                  primaryYAxis: NumericAxis(
                    labelStyle: TextStyle(color: Color(0xFF8B9AAB)),
                  ),
                  series: <CartesianSeries>[
                    BarSeries<Map<String, dynamic>, String>(
                      dataSource: _sucursales,
                      xValueMapper: (data, _) => data['nombre'],
                      yValueMapper: (data, _) => data['ventasMes'],
                      name: 'Ventas',
                      color: Color(0xFF4CAF50),
                    ),
                    BarSeries<Map<String, dynamic>, String>(
                      dataSource: _sucursales,
                      xValueMapper: (data, _) => data['nombre'],
                      yValueMapper:
                          (data, _) => data['ocupacionPromedio'] * 1000,
                      name: 'Ocupación (x1000)',
                      color: Color(0xFF2196F3),
                    ),
                  ],
                  legend: Legend(
                    isVisible: true,
                    textStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Comparación de Rating',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 200,
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(
                    labelStyle: TextStyle(color: Color(0xFF8B9AAB)),
                  ),
                  primaryYAxis: NumericAxis(
                    minimum: 3,
                    maximum: 5,
                    interval: 0.5,
                    labelStyle: TextStyle(color: Color(0xFF8B9AAB)),
                  ),
                  series: <CartesianSeries>[
                    LineSeries<Map<String, dynamic>, String>(
                      dataSource: _sucursales,
                      xValueMapper: (data, _) => data['nombre'],
                      yValueMapper: (data, _) => data['rating'],
                      name: 'Rating',
                      color: Color(0xFFFFC107),
                      markerSettings: MarkerSettings(isVisible: true),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ReservationData {
  final String day;
  final int reservations;

  ReservationData(this.day, this.reservations);
}

final List<ReservationData> weeklyReservations = [
  ReservationData('Lun', 30),
  ReservationData('Mar', 45),
  ReservationData('Mié', 40),
  ReservationData('Jue', 50),
  ReservationData('Vie', 60),
  ReservationData('Sáb', 80),
  ReservationData('Dom', 70),
];

class Random {
  double nextDouble() {
    return 0.0;
  }
}
