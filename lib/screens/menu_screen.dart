import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Centrado vertical
          crossAxisAlignment: CrossAxisAlignment.center, // Centrado horizontal
          children: [
            const Text(
              'Menú Principal',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/register'); // Redirige a la pantalla de registro(Cambiar a la pantalla que desees, cambiar el register por otra ruta)
                },
                child: const Text('Nuevo pedido'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/register'); // Redirige a la pantalla de registro(Cambiar a la pantalla que desees, cambiar el register por otra ruta)
                },
                child: const Text('Lista de vehículos'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/busqueda'); // Redirige a la pantalla de registro(Cambiar a la pantalla que desees, cambiar el register por otra ruta)
                },
                child: const Text('Buscar vehículo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
