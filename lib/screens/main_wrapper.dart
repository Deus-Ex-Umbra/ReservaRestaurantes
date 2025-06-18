import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import '../screens/shared/home.dart';
import '../screens/shared/buscar.dart';
import '../screens/shared/historial.dart';
import '../screens/shared/guardado.dart';
import '../screens/shared/perfil.dart';

class MainWrapper extends StatefulWidget {
  final int initialIndex;

  const MainWrapper({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  _MainWrapperState createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _screens = [
    RecipeHomePage(),
    BuscarPage(),
    ReservasScreen(clienteId: 1),
    FavoritosScreen(),
    ProfileSettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      backgroundColor: Color(0xFFFCF5E5),

      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
