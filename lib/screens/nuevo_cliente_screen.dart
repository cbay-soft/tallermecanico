import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/recepcion_controller.dart';
import '../widgets/custom_widgets.dart';

class NuevoClienteScreen extends StatelessWidget {
  const NuevoClienteScreen({super.key});

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
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(50),
                          ),
                          onPressed: () =>
                            controller.registrarClienteNuevo(() {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Cliente registrado'),
                                ),
                              );
                            }),
                            // Acción del botón
                          child: const Text('Guardar Cliente'),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
    
  }
}
