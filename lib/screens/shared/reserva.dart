import 'package:flutter/material.dart';
import '../../screens/date_selection_screen.dart';

void main() {
  runApp(const RestauranteApp());
}

class RestauranteApp extends StatelessWidget {
  final DateTime? initialDate;
  const RestauranteApp({Key? key, this.initialDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurante App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
      ),
      home: const DateSelectionScreen(),
    );
  }
}
