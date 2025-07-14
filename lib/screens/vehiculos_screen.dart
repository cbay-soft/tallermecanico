import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/vehiculos_controller.dart';

class VehiculosScreen extends StatelessWidget {
  const VehiculosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VehiculosController()..cargarVehiculos(),
      child: Scaffold(
        body: Consumer<VehiculosController>(
          builder: (context, controller, _) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF8EC8F2), Color(0xFF3A6FA5)],
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
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
                  Text(
                    'LISTADO DE VEHÍCULOS',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  ToggleButtons(
                    isSelected: [
                      controller.todos.isNotEmpty,
                      controller.pendientes.isNotEmpty,
                      controller.realizados.isNotEmpty,
                    ],
                    onPressed: (index) {
                      // Filtrar, no incluido por simplicidad aquí
                    },
                    children: const [
                      Padding(padding: EdgeInsets.all(8), child: Text("Todos")),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text("Pendientes"),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text("Realizados"),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.todos.length,
                      itemBuilder: (_, index) {
                        final v = controller.todos[index];
                        return ListTile(
                          title: Text('${v.placa} - ${v.marca} ${v.modelo}'),
                          subtitle: Text(v.estado.toUpperCase()),
                        );
                      },
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
