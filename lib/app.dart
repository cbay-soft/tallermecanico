import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/recepcion_screen.dart';
import 'screens/vehiculos_screen.dart';
import 'screens/mantenimiento_screen.dart';
import 'screens/register_screen.dart';
import 'screens/expediente_screen.dart';
import 'screens/detalle_vehiculo_screen.dart';
import 'screens/clientes_screen.dart';
import 'screens/mecanico_home_screen.dart';
import 'screens/mecanico_expediente_screen.dart';
import 'screens/mecanico_mantenimiento_screen.dart';

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
        '/register': (_) => RegisterScreen(),
        '/menu': (_) => MenuScreen(),
        '/recepcion': (_) => RecepcionScreen(),
        '/vehiculos': (_) => VehiculosScreen(),
        '/clientes': (context) => const ClientesScreen(),
        '/expediente': (context) {
          final vehiculoId =
              ModalRoute.of(context)!.settings.arguments as String;
          return ExpedienteScreen(vehiculoId: vehiculoId);
        },
        '/detalle': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          return DetalleVehiculoScreen(
            vehiculo: args['vehiculo'],
            mantenimientoId: args['mantenimientoId'],
          );
        },
        '/mantenimiento': (context) {
          final arguments = ModalRoute.of(context)!.settings.arguments;

          if (arguments is Map<String, dynamic>) {
            // Si es un Map, usar los valores
            return MantenimientoScreen(
              vehiculoId: arguments['vehiculoId'] as String,
              cedulaId: arguments['cedulaId'] as String,
            );
          } else if (arguments is String) {
            // Si es un String (navegación antigua), usar solo vehiculoId
            return MantenimientoScreen(
              vehiculoId: arguments,
              cedulaId: '', // Valor por defecto vacío
            );
          } else {
            // Si no hay argumentos válidos, mostrar error
            return const Scaffold(
              body: Center(
                child: Text(
                  'Error: Argumentos inválidos para MantenimientoScreen',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            );
          }
        },
        '/mecanico': (_) => const MecanicoHomeScreen(),
      },
    );
  }
}
