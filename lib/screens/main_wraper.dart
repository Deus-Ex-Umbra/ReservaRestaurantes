import 'package:flutter/material.dart';
import 'package:flutter_application/models/auth/user_model.dart';
import '../screens/admin/admin_main.dart';
import '../screens/shared/home.dart';
import '../screens/restaurante/admin_home.dart';

class MainWrapper extends StatelessWidget {
  final UserModel user;

  const MainWrapper({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (user.role) {
      case 'administrador':
        //return AdminMainScreen(user: user);
        return AdminMainScreen();
      case 'cliente':
        return RecipeHomePage();
      case 'restaurante':
        return AdminHomeScreen();
      default:
        return Scaffold(body: Center(child: Text('Rol no reconocido')));
    }
  }
}
