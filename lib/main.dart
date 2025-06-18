import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/welcome_screen.dart';
import 'screens/main_wrapper.dart';
import 'screens/shared/reserva.dart'; // Importa la pantalla de reserva

// Clave global para el NavigatorState
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting(
    'es',
    null,
  ); // Inicializa los datos de localización para español
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // Agregado el GlobalKey aquí
      title: 'Delicious Food App',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: Color(0xFF2C2C2C),
        fontFamily: 'Arial',
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', ''), // Español
      ],
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => WelcomeScreen(),
        '/main': (context) => MainWrapper(),
        '/reserva': (context) => RestauranteApp(), // Nueva ruta
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
