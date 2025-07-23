import 'package:flutter/material.dart';
// Este import es solo una referencia para el controlador de autenticación
import '../controllers/auth_controller.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Instancia del controlador (los del backend lo usarán)
  final auth = AuthController(); // 👉 Aquí los del backend colocan su lógica real

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/logoTaller.png',
              width: 200,
              height: 200,
            ),
            const Text(
              'REGISTRARSE',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),

            // Campo: Nombre completo
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre completo',
                filled: true,
                fillColor: Colors.white70,
              ),
            ),
            const SizedBox(height: 10),

            // Campo: Teléfono
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Teléfono',
                filled: true,
                fillColor: Colors.white70,
              ),
            ),
            const SizedBox(height: 10),

            // Campo: Correo electrónico
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                filled: true,
                fillColor: Colors.white70,
              ),
            ),
            const SizedBox(height: 10),

            // Campo: Contraseña
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

            // Botón de Registro
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 45),
              ),
              onPressed: () async {
                //Aqui va la logica de registro
              },
              child: const Text('Registrarse'),
            ),
            const SizedBox(height: 15),

            // Texto para volver al login
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                '¿Ya tienes cuenta? Inicia sesión',
                style: TextStyle(color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
