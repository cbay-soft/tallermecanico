import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/recepcion_screen.dart';
import 'screens/vehiculos_screen.dart';
import 'screens/mantenimiento_screen.dart';

class TallerApp extends StatelessWidget {
  const TallerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taller Mecánico',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 142, 200, 242),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 198, 222, 239),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => LoginScreen(),
        '/dashboard': (_) => DashboardScreen(),
        '/clientes': (_) => RecepcionScreen(),
        '/vehiculos': (_) => VehiculosScreen(),
        '/mantenimiento': (context) {
          final vehiculoId = ModalRoute.of(context)!.settings.arguments as String;
          return MantenimientoScreen(vehiculoId: vehiculoId);
        },
      },
    );
  }
}
