import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/selection_info_bar.dart';
import '../widgets/table_widget.dart';
import 'reservation_form_screen.dart';
import '../main.dart';
import '../screens/main_wrapper.dart';

class TableSelectionScreen extends StatefulWidget {
  final DateTime selectedDate;
  final String selectedTime;

  const TableSelectionScreen({
    Key? key,
    required this.selectedDate,
    required this.selectedTime,
  }) : super(key: key);

  @override
  _TableSelectionScreenState createState() => _TableSelectionScreenState();
}

class _TableSelectionScreenState extends State<TableSelectionScreen> {
  int? selectedTable;
  List<int> reservedTables = [2, 5, 8];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // En tu Scaffold
      appBar: CustomAppBar(
        context: context,
        onBackPressed: () => Navigator.pop(context),
        onHomePressed: () {
          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => MainWrapper(initialIndex: 0),
            ),
            (route) => false,
          );
        },
        onMenuSelected: (value) {
          switch (value) {
            case 'inicio':
              navigatorKey.currentState?.pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => MainWrapper(initialIndex: 0),
                ),
                (route) => false,
              );
              break;
            case 'buscar':
              navigatorKey.currentState?.pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => MainWrapper(initialIndex: 1),
                ),
                (route) => false,
              );
              break;
            case 'reservas':
              navigatorKey.currentState?.pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => MainWrapper(initialIndex: 2),
                ),
                (route) => false,
              );
              break;
            case 'favoritos':
              navigatorKey.currentState?.pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => MainWrapper(initialIndex: 3),
                ),
                (route) => false,
              );
              break;
            case 'perfil':
              navigatorKey.currentState?.pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => MainWrapper(initialIndex: 4),
                ),
                (route) => false,
              );
              break;
          }
        },
      ),
      body: Stack(
        children: [
          // Contenedor azul con curva
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 270, // Altura del contenedor azul
              child: CustomPaint(
                painter: CurvedBackgroundPainter(),
                child: Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      // Nombre del restaurante
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Text(
                          'Botanero Azteca',
                          style: AppConstants.sectionTitleStyle.copyWith(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Información de selección
                      SelectionInfoBar(
                        date: widget.selectedDate,
                        time: widget.selectedTime,
                        guestCount:
                            selectedTable != null
                                ? _getGuestCountForTable(selectedTable!)
                                : null,
                        tableNumber: selectedTable,
                        showTableIcon: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Contenedor de mesas (flotante)
          Positioned(
            top: 170, // Posición para que se superponga con la curva
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 80),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Elige una mesa disponible',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Mesas individuales
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TableWidget(
                          tableNumber: 1,
                          isReserved: reservedTables.contains(1),
                          isSelected: selectedTable == 1,
                          onTap: _navigateToReservationForm,
                          type: TableType.individual,
                        ),
                        const SizedBox(width: 40),
                        TableWidget(
                          tableNumber: 2,
                          isReserved: reservedTables.contains(2),
                          isSelected: selectedTable == 2,
                          onTap: _navigateToReservationForm,
                          type: TableType.individual,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    // Mesas para dos
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TableWidget(
                          tableNumber: 3,
                          isReserved: reservedTables.contains(3),
                          isSelected: selectedTable == 3,
                          onTap: _navigateToReservationForm,
                          type: TableType.forTwo,
                        ),
                        const SizedBox(width: 40),
                        TableWidget(
                          tableNumber: 4,
                          isReserved: reservedTables.contains(4),
                          isSelected: selectedTable == 4,
                          onTap: _navigateToReservationForm,
                          type: TableType.forTwo,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    // Mesas para cuatro
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TableWidget(
                          tableNumber: 5,
                          isReserved: reservedTables.contains(5),
                          isSelected: selectedTable == 5,
                          onTap: _navigateToReservationForm,
                          type: TableType.forFour,
                        ),
                        const SizedBox(width: 40),
                        TableWidget(
                          tableNumber: 6,
                          isReserved: reservedTables.contains(6),
                          isSelected: selectedTable == 6,
                          onTap: _navigateToReservationForm,
                          type: TableType.forFour,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    // Mesas para seis
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TableWidget(
                          tableNumber: 7,
                          isReserved: reservedTables.contains(7),
                          isSelected: selectedTable == 7,
                          onTap: _navigateToReservationForm,
                          type: TableType.forSix,
                        ),
                        const SizedBox(width: 40),
                        TableWidget(
                          tableNumber: 8,
                          isReserved: reservedTables.contains(8),
                          isSelected: selectedTable == 8,
                          onTap: _navigateToReservationForm,
                          type: TableType.forSix,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    // Mesas para ocho
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TableWidget(
                          tableNumber: 9,
                          isReserved: reservedTables.contains(9),
                          isSelected: selectedTable == 9,
                          onTap: _navigateToReservationForm,
                          type: TableType.forEight,
                        ),
                        const SizedBox(width: 40),
                        TableWidget(
                          tableNumber: 10,
                          isReserved: reservedTables.contains(10),
                          isSelected: selectedTable == 10,
                          onTap: _navigateToReservationForm,
                          type: TableType.forEight,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToReservationForm(int tableNumber) {
    setState(() => selectedTable = tableNumber);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ReservationFormScreen(
              selectedDate: widget.selectedDate,
              selectedTime: widget.selectedTime,
              guestCount: _getGuestCountForTable(tableNumber),
              tableNumber: tableNumber,
            ),
      ),
    );
  }

  int _getGuestCountForTable(int tableNumber) {
    if (tableNumber <= 2) return 1;
    if (tableNumber <= 4) return 2;
    if (tableNumber <= 6) return 4;
    if (tableNumber <= 8) return 6;
    return 8;
  }
}

// CustomPainter para crear el fondo azul con curva
class CurvedBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xFF4285F4)
          ..style = PaintingStyle.fill;

    final path = Path();

    // Comenzar desde la esquina superior izquierda
    path.moveTo(0, 0);
    // Línea hasta la esquina superior derecha
    path.lineTo(size.width, 0);
    // Línea hacia abajo por el lado derecho
    path.lineTo(size.width, size.height - 70);

    // Crear la curva en la parte inferior (como una U invertida)
    path.quadraticBezierTo(
      size.width * 0.5, // punto de control X (centro)
      size.height, // punto de control Y (más abajo para crear la curva)
      0, // punto final X (esquina izquierda)
      size.height - 70, // punto final Y (misma altura que el lado derecho)
    );

    // Cerrar el path
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
