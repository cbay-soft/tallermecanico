import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoPrincipalClaro, // Fondo blanco
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Centrado vertical
          crossAxisAlignment: CrossAxisAlignment.center, // Centrado horizontal
          children: [
            const Text(
              'MENÚ PRINCIPAL',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppColors.textoTitulo,
                // 🟨 Sombra del texto
                shadows: [
                  Shadow(
                    color: AppColors.advertenciaTexto,
                    offset: Offset(1, 1),
                    blurRadius: 30,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.fondoPrincipalOscuro, // Botón Gris
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/clientes',
                  ); // Redirige a la pantalla de registro(Cambiar a la pantalla que desees, cambiar el register por otra ruta)
                },
                child: const Text('BUSCAR CLIENTE'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.fondoPrincipalOscuro, // Botón Gris
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/vehiculos',
                  ); // Redirige a la pantalla de registro(Cambiar a la pantalla que desees, cambiar el register por otra ruta)
                },
                child: const Text('VEHICULOS'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
