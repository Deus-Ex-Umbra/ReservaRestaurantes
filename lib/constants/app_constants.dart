import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Botanero Azteca';
  static const Color primaryColor = Color(0xFF8B6F47);
  static const Color darkBackground = Color(0xFF2A2A2A);
  static const Color tealAccent = Color(0xFF2E7D73);

  static const TextStyle titleStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle sectionTitleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle whiteText = TextStyle(color: Colors.white);
  static const TextStyle boldWhiteText = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static final BoxDecoration infoBarDecoration = BoxDecoration(
    color: Color(0xFF2A2A2A),
    borderRadius: BorderRadius.circular(25),
  );

  static Widget buildDot() {
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.teal[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  static Widget buildInfoItemWithIcon(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.teal, size: 20),
        const SizedBox(width: 4),
        Text(text, style: whiteText),
      ],
    );
  }
}
