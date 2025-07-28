import 'package:flutter/material.dart';
import 'package:tallermecanico/screens/detallesvehiculo_screen.dart';
import 'screens/login_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/recepcion_screen.dart';
import 'screens/vehiculos_screen.dart';
import 'screens/mantenimiento_screen.dart';
import 'screens/pedido_screen.dart';
import 'screens/vehiculos_ingresados_screen.dart';
import 'screens/register_screen.dart';
import 'screens/busqueda_screen.dart';
import 'screens/orden.dart'; 
import 'screens/informe_final.dart';

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
        '/clientes': (_) => RecepcionScreen(),
        '/vehiculos_ingresados':(_)=> VehiculosIngresadosScreen(), 
        '/pedido': (context) => const PedidoScreen(),
        '/vehiculos': (_) => VehiculosScreen(),
        '/busqueda': (_) => BusquedaScreen(),
        '/detallevehiculo': (_) => DetallesvehiculoScreen(),
        '/orden': (_)=> OrdenTrabajoScreen(),
        '/informe_final': (_) =>ResumenTrabajoScreen(),
        '/mantenimiento': (context) {
          final vehiculoId = ModalRoute.of(context)!.settings.arguments as String;
          return MantenimientoScreen(vehiculoId: vehiculoId);
        },
      },
    );
  }
}
