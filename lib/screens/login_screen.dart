import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final auth = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/logoTaller.png',
              width: 280,
              height: 240,
            ),
            const Text(
              'INICIO DE SESIÓN',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Texto negro para contraste
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Correo',
                filled: true,
                fillColor: Colors.white70,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                filled: true,
                fillColor: Colors.white70,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Botón verde
                foregroundColor: Colors.white, // Texto blanco
                minimumSize: const Size(double.infinity, 45),
              ),
              onPressed: () async {
                final user = await auth.signIn(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );
                if (user != null && context.mounted) {
                  Navigator.pushReplacementNamed(context, '/menu');
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Correo o contraseña incorrectos'),
                      ),
                    );
                  }
                }
              },
              child: const Text('Ingresar'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Botón verde
                foregroundColor: Colors.white, // Texto blanco
                minimumSize: const Size(double.infinity, 45),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/register'); // Ruta de registro
              },
              child: const Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}
