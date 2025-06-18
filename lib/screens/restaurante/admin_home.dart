import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'buscar.dart';
import 'reservas.dart';
import 'perfil.dart';

class AdminHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Datos de ejemplo para gráficos
    final List<ReservationData> weeklyReservations = [
      ReservationData('Lun', 15),
      ReservationData('Mar', 22),
      ReservationData('Mié', 18),
      ReservationData('Jue', 25),
      ReservationData('Vie', 30),
      ReservationData('Sáb', 35),
      ReservationData('Dom', 28),
    ];

    final List<RevenueData> monthlyRevenue = [
      RevenueData('Ene', 12000),
      RevenueData('Feb', 15000),
      RevenueData('Mar', 18000),
      RevenueData('Abr', 16000),
      RevenueData('May', 20000),
      RevenueData('Jun', 22000),
    ];

    final List<TableData> tableOccupation = [
      TableData('Mesa 1', 85),
      TableData('Mesa 2', 70),
      TableData('Mesa 3', 90),
      TableData('Mesa 4', 65),
      TableData('Mesa 5', 80),
    ];

    return Scaffold(
      backgroundColor: Color(0xFFf5f5f5), // Fondo claro
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bienvenido, Admin',
                      style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
                    ),
                    Text(
                      'Panel de Control',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    // Navegación a la pantalla de perfil
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminProfileScreen(),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage('assets/admin_profile.jpg'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),

            // Resumen rápido con más estadísticas
            Text(
              'Resumen del Día',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 15),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.5,
              children: [
                _buildStatCard(
                  'Reservas Hoy',
                  '24',
                  Icons.calendar_today,
                  Colors.blueAccent,
                  '+5% vs ayer',
                ),
                _buildStatCard(
                  'Órdenes Activas',
                  '12',
                  Icons.restaurant,
                  Colors.greenAccent,
                  '3 nuevas',
                ),
                _buildStatCard(
                  'Facturación',
                  '\$1,850',
                  Icons.attach_money,
                  Colors.amberAccent,
                  '+12% vs ayer',
                ),
                _buildStatCard(
                  'Ocupación',
                  '78%',
                  Icons.people,
                  Colors.purpleAccent,
                  'Capacidad 120',
                ),
              ],
            ),
            SizedBox(height: 30),

            // Gráfico de reservas semanales
            _buildSectionTitle('Reservas Semanales', Icons.trending_up),
            SizedBox(height: 15),
            Container(
              height: 250,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  labelStyle: TextStyle(color: Color(0xFF666666)),
                ),
                primaryYAxis: NumericAxis(
                  labelStyle: TextStyle(color: Color(0xFF666666)),
                ),
                series: <CartesianSeries>[
                  ColumnSeries<ReservationData, String>(
                    dataSource: weeklyReservations,
                    xValueMapper: (ReservationData data, _) => data.day,
                    yValueMapper:
                        (ReservationData data, _) => data.reservations,
                    color: Color(0xFFd17842), // Naranja
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      textStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Gráfico de ingresos mensuales
            _buildSectionTitle('Ingresos Mensuales', Icons.bar_chart),
            SizedBox(height: 15),
            Container(
              height: 250,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  labelStyle: TextStyle(color: Color(0xFF666666)),
                ),
                primaryYAxis: NumericAxis(
                  numberFormat: NumberFormat.currency(
                    locale: 'es',
                    symbol: '\$',
                  ),
                  labelStyle: TextStyle(color: Color(0xFF666666)),
                ),
                series: <CartesianSeries>[
                  LineSeries<RevenueData, String>(
                    dataSource: monthlyRevenue,
                    xValueMapper: (RevenueData data, _) => data.month,
                    yValueMapper: (RevenueData data, _) => data.revenue,
                    color: Color(0xFF4ECDC4), // Turquesa
                    markerSettings: MarkerSettings(isVisible: true),
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      textStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Ocupación de mesas
            _buildSectionTitle('Ocupación de Mesas', Icons.table_restaurant),
            SizedBox(height: 15),
            Container(
              height: 250,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  labelStyle: TextStyle(color: Color(0xFF666666)),
                ),
                primaryYAxis: NumericAxis(
                  maximum: 100,
                  labelStyle: TextStyle(color: Color(0xFF666666)),
                ),
                series: <CartesianSeries>[
                  BarSeries<TableData, String>(
                    dataSource: tableOccupation,
                    xValueMapper: (TableData data, _) => data.table,
                    yValueMapper: (TableData data, _) => data.occupation,
                    color: Color(0xFF8B9AAB),
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      textStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Reservas recientes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionTitle('Reservas Recientes', Icons.event_note),
                TextButton(
                  onPressed: () {
                    // Navegación a la pantalla de reservas
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminReservationsScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Ver todas',
                    style: TextStyle(color: Color(0xFFd17842)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            _buildRecentReservationItem(
              'Juan Pérez',
              'Mesa 4 - 19:30 - 4 personas',
              'Hoy',
              Icons.check_circle,
              Colors.green,
            ),
            _buildRecentReservationItem(
              'Ana Gómez',
              'Mesa 2 - 20:00 - 2 personas',
              'Hoy',
              Icons.access_time,
              Colors.orange,
            ),
            _buildRecentReservationItem(
              'Carlos Ruiz',
              'Mesa 5 - 21:00 - 6 personas',
              'Mañana',
              Icons.event,
              Colors.blue,
            ),
            _buildRecentReservationItem(
              'María López',
              'Mesa Privada - 20:30 - 10 personas',
              'Mañana',
              Icons.star,
              Colors.purple,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFFd17842), size: 24),
        SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Text(title, style: TextStyle(color: Color(0xFF666666), fontSize: 14)),
          SizedBox(height: 5),
          Text(subtitle, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildRecentReservationItem(
    String name,
    String details,
    String date,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
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
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  details,
                  style: TextStyle(color: Color(0xFF666666), fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(date, style: TextStyle(color: color, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

// Clases para los datos de los gráficos
class ReservationData {
  final String day;
  final int reservations;

  ReservationData(this.day, this.reservations);
}

class RevenueData {
  final String month;
  final double revenue;

  RevenueData(this.month, this.revenue);
}

class TableData {
  final String table;
  final int occupation;

  TableData(this.table, this.occupation);
}
