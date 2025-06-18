import 'package:flutter/material.dart';
import '../screens/table_selection_screen.dart';

class TimeGridWidget extends StatelessWidget {
  final List<String> times;
  final DateTime selectedDate;

  const TimeGridWidget({
    Key? key,
    required this.times,
    required this.selectedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        spacing: 15,
        runSpacing: 15,
        children:
            times
                .map(
                  (time) => GestureDetector(
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => TableSelectionScreen(
                                  selectedDate: selectedDate,
                                  selectedTime: time,
                                ),
                          ),
                        ),
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 50) / 6,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A4A4A),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          time,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}
