import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/selection_info_bar.dart';
import '../widgets/time_grid_widget.dart';
import '../main.dart';
import '../screens/main_wrapper.dart';

class TimeSelectionScreen extends StatelessWidget {
  final DateTime selectedDate;
  final String selectedTime;

  const TimeSelectionScreen({
    Key? key,
    required this.selectedDate,
    this.selectedTime = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco para el scaffold
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
              height: 270, // Altura reducida del contenedor azul
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
                      SelectionInfoBar(date: selectedDate),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Contenedor de horarios (flotante)
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        'ALMUERZO',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TimeGridWidget(
                      times: [
                        '12:45',
                        '13:15',
                        '13:45',
                        '14:15',
                        '14:45',
                        '15:15',
                        '15:45',
                        '16:15',
                        '16:45',
                      ],
                      selectedDate: selectedDate,
                    ),
                    const SizedBox(height: 30),
                    const Center(
                      child: Text(
                        'CENA',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TimeGridWidget(
                      times: [
                        '17:15',
                        '17:45',
                        '18:15',
                        '18:45',
                        '19:15',
                        '19:45',
                        '20:15',
                        '20:45',
                        '21:15',
                      ],
                      selectedDate: selectedDate,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
