import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tallermecanico/screens/menu_screen.dart';
import '../services/admin_service.dart';
import '../screens/admin_dashboard_screen.dart';
import '../screens/recepcion_screen.dart';
import '../screens/mecanico_home_screen.dart';

class RouterService {
  static final AdminService _adminService = AdminService();

  // Determinar la pantalla inicial según el rol del usuario
  static Future<Widget> getPantallaInicial() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Si no hay usuario autenticado, ir al login
      return const Scaffold(
        body: Center(child: Text('Redirigiendo al login...')),
      );
    }

    try {
      final rol = await _adminService.obtenerRolUsuario();

      switch (rol) {
        case 'admin':
          return const AdminDashboardScreen();
        case 'recepcionista':
          return const MenuScreen();
        case 'mecanico':
          return const MecanicoHomeScreen();
        default:
          // Usuario sin rol definido
          return const PantallaUsuarioSinRol();
      }
    } catch (e) {
      print('Error obteniendo rol: $e');
      // En caso de error, mostrar pantalla por defecto
      return const RecepcionScreen();
    }
  }

  // Verificar si el usuario puede acceder a una pantalla específica
  static Future<bool> puedeAcceder(String pantalla) async {
    final rol = await _adminService.obtenerRolUsuario();

    switch (pantalla) {
      case 'admin':
        return rol == 'admin';
      case 'recepcionista':
        return rol == 'admin' || rol == 'recepcionista';
      case 'mecanico':
        return rol == 'admin' || rol == 'mecanico';
      default:
        return true;
    }
  }

  // Navegar a la pantalla correcta según el rol
  static Future<void> navegarSegunRol(BuildContext context) async {
    final pantalla = await getPantallaInicial();

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => pantalla),
        (route) => false,
      );
    }
  }
}

// Pantalla para usuarios sin rol definido
class PantallaUsuarioSinRol extends StatelessWidget {
  const PantallaUsuarioSinRol({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acceso Restringido'),
        backgroundColor: Colors.red,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 20),
              Text(
                'Usuario sin permisos',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Tu cuenta no tiene permisos asignados. Contacta al administrador.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
