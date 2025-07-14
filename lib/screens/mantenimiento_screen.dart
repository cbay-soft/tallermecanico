import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/mantenimiento_controller.dart';

class MantenimientoScreen extends StatelessWidget {
  final String vehiculoId;
  const MantenimientoScreen({super.key, required this.vehiculoId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MantenimientoController(),
      child: Scaffold(
        body: Consumer<MantenimientoController>(
          builder: (context, controller, _) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF8EC8F2), Color(0xFF3A6FA5)],
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Text(
                    'OBSERVACIONES DEL VEHÍCULO',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.observaciones.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: TextField(
                            controller: controller.observaciones[index],
                            decoration: InputDecoration(
                              labelText: 'Novedad ${index + 1}',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () =>
                                    controller.eliminarObservacion(index),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: controller.agregarObservacion,
                        icon: const Icon(Icons.add),
                        label: const Text("Añadir Observación"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF3A6FA5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await controller
                          .subirFotoMock(); // reemplazar luego por lógica real
                    },
                    icon: const Icon(Icons.add_a_photo),
                    label: const Text("Subir Foto de Ingreso"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await controller.guardarMantenimiento(vehiculoId);
                      if (context.mounted) Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 120, 198, 163),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                    ),
                    child: const Text(
                      "Guardar Mantenimiento",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
