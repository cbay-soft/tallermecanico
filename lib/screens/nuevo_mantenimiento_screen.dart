import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/recepcion_controller.dart';
import '../widgets/custom_widgets.dart';

class NuevoMantenimientoScreen extends StatelessWidget {
  const NuevoMantenimientoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RecepcionController(),
      child: Consumer<RecepcionController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBar(
              leading: const BackButton(color: Colors.white),
              title: const Text(
                'Registro del Cliente y Vehículo',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.blue,
              elevation: 0,
            ),
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF89CFF0), Color(0xFF4682B4)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Datos del Cliente',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      CustomWidgets.buildTextField('Nombre completo', controller: controller.nombreController),
                      CustomWidgets.buildTextField('Cédula o RUC', controller: controller.cedulaController),
                      CustomWidgets.buildTextField('Teléfono', controller: controller.telefonoController),
                      CustomWidgets.buildTextField('Correo electrónico', controller: controller.correoController),
                      const SizedBox(height: 20),
                      const Text(
                        'Datos del Vehículo',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Descripción del problema',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      CustomWidgets.buildMultilineTextField('Escriba el problema...'),
                      const SizedBox(height: 20),

                      const Text(
                        'Fotos del vehículo',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _imagePlaceholder('Frontal'),
                          _imagePlaceholder('Lateral'),
                          _imagePlaceholder('Interior'),
                        ],
                      ),
                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(50),
                          ),
                          onPressed: () {
                            // Acción del botón
                          },
                          child: const Text('Generar pedido'),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            // Footer
            bottomNavigationBar: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset('assets/images/logoTaller.png', width: 50, height: 50),
                  _bottomButton(Icons.add_circle_outline, 'Nuevo', () {
                    Navigator.pushNamed(context, '/pedido');
                  }),
                  _bottomButton(Icons.list_alt, 'Listar', () {
                    Navigator.pushNamed(context, '/vehiculos_ingresados');
                  }),
                  _bottomButton(Icons.search, 'Buscar', () {
                    Navigator.pushNamed(context, '/busqueda');
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
    
  }

  static Widget _imagePlaceholder(String label) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.image, size: 40, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }

  static Widget _bottomButton(
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 24),
          ),
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}
