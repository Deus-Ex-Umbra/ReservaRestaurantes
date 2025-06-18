import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/selection_info_bar.dart';
import '../widgets/calendar_widget.dart';
import 'time_selection_screen.dart';
import '../screens/main_wrapper.dart';
import '../main.dart';

class DateSelectionScreen extends StatefulWidget {
  final DateTime? initialDate;

  const DateSelectionScreen({Key? key, this.initialDate}) : super(key: key);

  @override
  State<DateSelectionScreen> createState() => _DateSelectionScreenState();
}

class _DateSelectionScreenState extends State<DateSelectionScreen> {
  late DateTime currentDate;
  late DateTime selectedDate;
  late int currentMonth;
  late int currentYear;
  bool _initialNavigationDone = false;

  Map<String, bool> descuentoDias = {
    '6': true,
    '7': true,
    '8': true,
    '13': true,
    '14': true,
    '15': true,
    '20': true,
    '21': true,
    '22': true,
    '27': true,
    '28': true,
    '29': true,
  };

  @override
  void initState() {
    super.initState();
    currentDate = DateTime.now();
    selectedDate = widget.initialDate ?? currentDate;
    currentMonth = selectedDate.month;
    currentYear = selectedDate.year;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialDate != null && !_initialNavigationDone) {
        _initialNavigationDone = true;
        _navigateToTimeSelection();
      }
    });
  }

  void _navigateToTimeSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimeSelectionScreen(selectedDate: selectedDate),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4285F4),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
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
            const SizedBox(height: 30),
            SelectionInfoBar(date: selectedDate),
            const SizedBox(height: 35),
            Container(
              height: 470,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              child: CalendarWidget(
                currentMonth: currentMonth,
                currentYear: currentYear,
                selectedDate: selectedDate,
                descuentoDias: descuentoDias,
                onMonthChanged: (month, year) {
                  setState(() {
                    currentMonth = month;
                    currentYear = year;
                  });
                },
                onDateSelected: (date) {
                  setState(() => selectedDate = date);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => TimeSelectionScreen(selectedDate: date),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
