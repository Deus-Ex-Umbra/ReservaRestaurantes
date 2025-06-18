import 'package:flutter/material.dart';

class CalendarWidget extends StatelessWidget {
  final int currentMonth;
  final int currentYear;
  final DateTime selectedDate;
  final Map<String, bool> descuentoDias;
  final Function(int month, int year) onMonthChanged;
  final Function(DateTime date) onDateSelected;

  const CalendarWidget({
    Key? key,
    required this.currentMonth,
    required this.currentYear,
    required this.selectedDate,
    required this.descuentoDias,
    required this.onMonthChanged,
    required this.onDateSelected,
  }) : super(key: key);

  String _getMonthNameSpanish(int month) {
    const monthNames = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    return monthNames[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          // Contenedor azul con curva hacia abajo
          Container(
            width: double.infinity,
            height: 200, // Altura ajustada para incluir la curva
            child: CustomPaint(
              painter: CurvedBackgroundPainter(),
              child: Container(
                padding: const EdgeInsets.only(bottom: 130, top: 0),
                child: _buildMonthNavigation(),
              ),
            ),
          ),

          // Contenedor blanco para el calendario (80% width) posicionado debajo
          Positioned(
            top: 100, // Posicionado para que se superponga con la curva
            left: MediaQuery.of(context).size.width * 0.1, // Centrado
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
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
                  // Encabezados de días de la semana
                  _buildWeekHeaders(),
                  const SizedBox(height: 10),
                  // Días del calendario
                  _buildCalendarDays(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthNavigation() {
    String prevMonth = _getMonthNameSpanish(
      currentMonth == 1 ? 12 : currentMonth - 1,
    );
    String nextMonth = _getMonthNameSpanish(
      currentMonth == 12 ? 1 : currentMonth + 1,
    );

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Mes anterior
          _buildMonthButton(prevMonth, () {
            if (currentMonth == 1) {
              onMonthChanged(12, currentYear - 1);
            } else {
              onMonthChanged(currentMonth - 1, currentYear);
            }
          }, false),
          const SizedBox(width: 24), // Increased spacing
          // Mes actual (más grande y destacado)
          _buildMonthButton(
            _getMonthNameSpanish(currentMonth),
            () {}, // No acción para el mes actual
            true,
          ),
          const SizedBox(width: 24), // Increased spacing
          // Mes siguiente
          _buildMonthButton(nextMonth, () {
            if (currentMonth == 12) {
              onMonthChanged(1, currentYear + 1);
            } else {
              onMonthChanged(currentMonth + 1, currentYear);
            }
          }, false),
        ],
      ),
    );
  }

  Widget _buildMonthButton(
    String monthName,
    VoidCallback onPressed,
    bool isCurrent,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isCurrent ? 24 : 20, // Larger padding for current month
          vertical: isCurrent ? 12 : 10, // Larger padding for current month
        ),
        decoration: BoxDecoration(
          color: isCurrent ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          monthName,
          style: TextStyle(
            color: isCurrent ? Colors.white : Colors.white.withOpacity(0.7),
            fontSize: isCurrent ? 24 : 18, // Larger font for current month
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildWeekHeaders() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        Text(
          'Lun',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        Text(
          'Mar',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        Text(
          'Mié',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        Text(
          'Jue',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        Text(
          'Vie',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        Text(
          'Sáb',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        Text(
          'Dom',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarDays() {
    DateTime firstDay = DateTime(currentYear, currentMonth, 1);
    int daysInMonth = DateTime(currentYear, currentMonth + 1, 0).day;
    int firstDayOfWeek = firstDay.weekday % 7;

    List<Widget> dayWidgets = [];

    // Días del mes anterior (opacos)
    for (int i = 0; i < firstDayOfWeek; i++) {
      int prevMonthDay =
          DateTime(currentYear, currentMonth, 0).day - firstDayOfWeek + i + 1;
      dayWidgets.add(
        Container(
          width: 40,
          height: 40,
          margin: const EdgeInsets.all(2),
          child: Center(
            child: Text(
              '$prevMonthDay',
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      );
    }

    // Días del mes actual
    for (int day = 1; day <= daysInMonth; day++) {
      bool hasDiscount = descuentoDias.containsKey(day.toString());
      bool isSelected =
          day == selectedDate.day &&
          currentMonth == selectedDate.month &&
          currentYear == selectedDate.year;

      Color buttonColor;
      Color shadowColor;
      Color textColor = Colors.black;

      if (isSelected) {
        buttonColor = const Color(
          0xFF4285F4,
        ); // Color específico para el botón seleccionado
        shadowColor = const Color(0xFF4285F4);
        textColor = Colors.white;
      } else if (hasDiscount) {
        if (day >= 2 && day <= 4) {
          // Rango rosa como en la imagen
          buttonColor = const Color(0xFFFF6B8A);
          shadowColor = const Color(0xFFFF6B8A);
          textColor = Colors.white;
        } else if (day == 6) {
          // Verde como en la imagen
          buttonColor = const Color(0xFF00C896);
          shadowColor = const Color(0xFF00C896);
          textColor = Colors.white;
        } else {
          buttonColor = Colors.transparent;
          shadowColor = Colors.transparent;
        }
      } else {
        buttonColor = Colors.transparent;
        shadowColor = Colors.transparent;
      }

      dayWidgets.add(
        GestureDetector(
          onTap: () => onDateSelected(DateTime(currentYear, currentMonth, day)),
          child: Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow:
                  buttonColor != Colors.transparent
                      ? [
                        BoxShadow(
                          color: shadowColor.withOpacity(0.3),
                          spreadRadius: 0,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                      : [],
            ),
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Calculate how many weeks we need to display all days
    int totalDaysShown = firstDayOfWeek + daysInMonth;
    int totalWeeksNeeded = (totalDaysShown / 7).ceil();
    int totalCellsNeeded = totalWeeksNeeded * 7;

    // Add empty cells if needed to complete the grid
    while (dayWidgets.length < totalCellsNeeded) {
      dayWidgets.add(
        Container(width: 40, height: 40, margin: const EdgeInsets.all(2)),
      );
    }

    return Column(
      children: List.generate(
        totalWeeksNeeded,
        (weekIndex) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: dayWidgets.sublist(weekIndex * 7, (weekIndex + 1) * 7),
          ),
        ),
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
          ..color = const Color.fromARGB(
            255,
            54,
            94,
            252,
          ) // Color específico para el fondo
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
