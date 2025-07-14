import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/mantenimiento_screen.dart';
import '../controllers/recepcion_controller.dart';

class RecepcionScreen extends StatelessWidget {
  const RecepcionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RecepcionController(),
      child: Consumer<RecepcionController>(
        builder: (context, controller, _) {
          return Scaffold(
            body: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF8EC8F2), Color(0xFF3A6FA5)],
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 50,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Image.asset(
                                  'assets/images/clienteLogo.png',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextField(
                                    textAlign: TextAlign.center,
                                    controller: controller.cedulaController,
                                    decoration: const InputDecoration(
                                      labelText: 'Cédula del Cliente',
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: controller.buscarCliente,
                                    child: const Text('Buscar Cliente'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 30, color: Colors.white),

                        if (controller.clienteEncontrado != null) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Cliente Verificado:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 120, 198, 163),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.check_circle,
                                color: Color.fromARGB(255, 120, 198, 163),
                              ),
                            ],
                          ),
                          const Divider(height: 30),
                          Text(
                            "Datos del cliente",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Nombre: ${controller.clienteEncontrado!.nombre}',
                          ),
                          Text(
                            'Teléfono: ${controller.clienteEncontrado!.telefono}',
                          ),
                          Text(
                            'Correo: ${controller.clienteEncontrado!.correo}',
                          ),
                          const Divider(height: 30),
                          const Text(
                            "Vehículos del Cliente",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.vehiculosCliente.length,
                            itemBuilder: (context, index) {
                              final v = controller.vehiculosCliente[index];
                              return ListTile(
                                title: Text(
                                  "${v.placa} - ${v.marca} ${v.modelo}",
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete_forever,
                                    color: Color.fromARGB(255, 201, 201, 201),
                                  ),
                                  onPressed: () =>
                                      controller.eliminarVehiculo(v.id),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          MantenimientoScreen(vehiculoId: v.id),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: controller.toggleFormularioVehiculo,
                            icon: Icon(
                              controller.mostrarFormularioVehiculo
                                  ? Icons.close
                                  : Icons.add,
                            ),
                            label: Text(
                              controller.mostrarFormularioVehiculo
                                  ? 'Cancelar'
                                  : 'Agregar nuevo vehículo',
                            ),
                          ),
                          if (controller.mostrarFormularioVehiculo) ...[
                            const Divider(),
                            const Text(
                              "Registrar nuevo vehículo",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextField(
                              controller: controller.placaController,
                              decoration: const InputDecoration(
                                labelText: 'Placa',
                              ),
                            ),
                            TextField(
                              controller: controller.marcaController,
                              decoration: const InputDecoration(
                                labelText: 'Marca',
                              ),
                            ),
                            TextField(
                              controller: controller.modeloController,
                              decoration: const InputDecoration(
                                labelText: 'Modelo',
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: controller.guardarVehiculo,
                              child: const Text('Agregar nuevo vehículo'),
                            ),
                          ],
                        ],

                        if (!controller.buscando &&
                            controller.clienteEncontrado == null &&
                            controller.cedulaController.text.isNotEmpty) ...[
                          const Text(
                            'Cliente no encontrado',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 255, 161, 155),
                            ),
                          ),
                          const Divider(height: 30),
                          Text(
                            "Registrar nuevo cliente",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          TextField(
                            controller: controller.nombreController,
                            decoration: const InputDecoration(
                              labelText: 'Nombre',
                            ),
                          ),
                          TextField(
                            controller: controller.telefonoController,
                            decoration: const InputDecoration(
                              labelText: 'Teléfono',
                            ),
                          ),
                          TextField(
                            controller: controller.correoController,
                            decoration: const InputDecoration(
                              labelText: 'Correo electrónico',
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () =>
                                controller.registrarClienteNuevo(() {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Cliente registrado'),
                                    ),
                                  );
                                }),
                            child: const Text('Registrar Cliente'),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                if (controller.buscando)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.1),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 128, 220, 238),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
