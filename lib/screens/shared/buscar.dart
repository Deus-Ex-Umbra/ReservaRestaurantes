import 'package:flutter/material.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/category_chips.dart';
import '../../widgets/greeting_header.dart';
import '../../widgets/burritos.dart'; // Importa el fondo reutilizable

class BuscarPage extends StatefulWidget {
  @override
  _BuscarPageState createState() => _BuscarPageState();
}

class _BuscarPageState extends State<BuscarPage> {
  String _selectedCategory = 'Internacional';
  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Internacional',
      'icon': Icons.restaurant_rounded,
      'color': Color(0xFFFF6B35),
    },
    {
      'name': 'Rápida',
      'icon': Icons.fastfood_rounded,
      'color': Color(0xFF6C5CE7),
    },
    {
      'name': 'Saludable',
      'icon': Icons.eco_rounded,
      'color': Color(0xFF00B894),
    },
    {
      'name': 'Bebidas',
      'icon': Icons.local_bar_rounded,
      'color': Color(0xFF0984E3),
    },
    {'name': 'Postres', 'icon': Icons.cake_rounded, 'color': Color(0xFFFD79A8)},
    {
      'name': 'Parrilladas',
      'icon': Icons.outdoor_grill_rounded,
      'color': Color(0xFFE17055),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FoodieBackground(
        foodOpacity: 0.1,
        showSaladBowl: true,
        showBurger: true,
        showFries: true,
        showDrink: true,
        showPizza: true,
        showTaco: true,
        child: SafeArea(
          child: Column(
            children: [
              GreetingHeader(
                userName: 'Teresa',
                profileImagePath: 'assets/profile.jpg',
                onNotificationPressed: () {
                  // Lógica para manejar las notificaciones
                },
              ),
              SizedBox(height: 20),

              // Search bar component
              RecipeSearchBar(
                onSearchChanged: (query) {
                  // Search logic here
                  print('Searching for: $query');
                },
              ),

              SizedBox(height: 30),

              // Categories component
              CategoryChips(
                categories: _categories,
                selectedCategory: _selectedCategory,
                onCategorySelected: (category) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
              ),

              // Add your search results list here if needed
              Expanded(
                child: Center(
                  child: Text(
                    'Search results will appear here',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
