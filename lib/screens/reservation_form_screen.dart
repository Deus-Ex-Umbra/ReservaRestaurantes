import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/selection_info_bar.dart';
import '../widgets/form_field_widget.dart';
import '../main.dart';
import '../screens/main_wrapper.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReservationFormScreen extends StatelessWidget {
  final DateTime selectedDate;
  final String selectedTime;
  final int guestCount;
  final int tableNumber;

  const ReservationFormScreen({
    Key? key,
    required this.selectedDate,
    required this.selectedTime,
    required this.guestCount,
    required this.tableNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              height: 270,
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
                        date: selectedDate,
                        time: selectedTime,
                        guestCount: guestCount,
                        tableNumber: tableNumber,
                        showTableIcon: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Contenedor del formulario (flotante)
          Positioned(
            top: 170,
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
                  children: [
                    const Text(
                      'Formulario de reserva',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    FormFieldWidget(
                      label: 'Nombre',
                      hintText: 'Ingresa tu nombre completo',
                    ),
                    const SizedBox(height: 15),
                    FormFieldWidget(
                      label: 'Teléfono',
                      hintText: 'Ingresa tu número de teléfono',
                    ),
                    const SizedBox(height: 15),
                    FormFieldWidget(
                      label: 'Correo electrónico',
                      hintText: 'Ingresa tu correo electrónico',
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () => _showPaymentQRDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Completar reserva',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  void _showPaymentQRDialog(BuildContext context) {
    // Generar un ID único para la reserva
    final reservationId = 'RES-${DateTime.now().millisecondsSinceEpoch}';
    final paymentData = 'botaneroazteca://pay/$reservationId?amount=50.00';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Pago de reserva',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Escanea el código QR para completar el pago',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: QrImageView(
                    data: paymentData,
                    version: QrVersions.auto,
                    size: 200,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'O copia el siguiente enlace:',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: paymentData));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Enlace copiado al portapapeles'),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            paymentData,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        const Icon(Icons.copy, size: 18),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cierra el diálogo del QR
                    _showReservationConfirmed(context); // Muestra confirmación
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'He completado el pago',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showReservationConfirmed(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reserva confirmada'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.teal, size: 60),
              const SizedBox(height: 20),
              Text(
                '¡Gracias por tu reserva!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Tu reserva para el ${DateFormat('dd/MM/yyyy', 'es').format(selectedDate)} a las $selectedTime ha sido confirmada.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Recibirás un correo con los detalles.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Redirige a la pantalla de reservas (índice 2)
                navigatorKey.currentState?.pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => MainWrapper(initialIndex: 2),
                  ),
                  (route) => false,
                );
              },
              child: const Text(
                'Ver mis reservas',
                style: TextStyle(color: Colors.teal),
              ),
            ),
          ],
        );
      },
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

    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - 70);

    path.quadraticBezierTo(size.width * 0.5, size.height, 0, size.height - 70);

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
