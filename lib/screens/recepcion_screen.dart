import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_widgets.dart';
import '../controllers/recepcion_controller.dart';

class RecepcionScreen extends StatelessWidget {
  const RecepcionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RecepcionController(),
      child: Consumer<RecepcionController>(
        builder: (context, controller, _) {
          // AGREGAR esta lógica para manejar el foco al cerrar modal
          if (controller.debeOcultarTeclado) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              FocusScope.of(context).unfocus();
              controller.tecladoOcultado();
            });
          }
          return Scaffold(
            appBar: AppBar(
              leading: const BackButton(color: Colors.white),
              title: const Text(
                'Nuevo Pedido',
                style: TextStyle(color: AppColors.appBarTexto),
              ),
              backgroundColor: AppColors.appBarFondo,
              elevation: 2,
            ),
            body: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.fondoPrincipalClaro,
                        AppColors.fondoPrincipalOscuro,
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Buscar Cliente",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: AppColors.textoTitulo,
                                ),
                              ),
                            ),
                            Expanded(
                              child: IconButton(
                                alignment: Alignment.topRight,
                                icon: const Icon(
                                  Icons.person_add_alt_1,
                                  color: AppColors.iconoPrincipal,
                                ),
                                onPressed: () {
                                  controller.setModalAbierto(
                                    true,
                                  ); //Marca que el modal se abre
                                  CustomWidgets.mostrarModalAgregarCliente(
                                    context,
                                    controller,
                                  );
                                },
                              ),
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
                                  'assets/images/clienteLogo2.png',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextField(
                                    style: const TextStyle(
                                      color: AppColors.textoAzul,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.left,
                                    controller: controller.cedulaController,
                                    decoration: const InputDecoration(
                                      filled: true,
                                      labelText: 'Cédula del Cliente',
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      labelStyle: TextStyle(
                                        color: AppColors.textoAzul,
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.textoAzul,
                                        ), // línea cuando NO está enfocado
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                alignment: Alignment.topRight,
                                icon: const Icon(
                                  Icons.search,
                                  color: AppColors.iconoPrincipal,
                                ),
                                onPressed: () async {
                                  await controller.buscarCliente();
                                },
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 5, color: Colors.white),
                        if (controller.clienteEncontrado != null) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Cliente Verificado:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.exito,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.check_circle,
                                color: AppColors.exito,
                                size: 17,
                              ),
                            ],
                          ),
                          const Divider(height: 5, color: Colors.white),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Cliente ${controller.clienteEncontrado!.nombre.toUpperCase()}',
                                style: const TextStyle(
                                  color: AppColors.textoTitulo,
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Vehículos:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textoEtiqueta,
                                ),
                              ),
                              SizedBox(
                                width: 60,
                                height: 60,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    // Centrar el IconButton dentro del Stack
                                    Center(
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.add_circle_outline,
                                          color: AppColors.iconoPrincipal,
                                          size: 28,
                                        ),
                                        onPressed: () {  
                                          if (controller.clienteEncontrado !=null) {
                                            controller.setModalAbierto(true);
                                            CustomWidgets.mostrarModalAgregarVehiculo(
                                              context,
                                              controller,
                                            );
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Primero debe buscar un cliente',
                                                ),
                                                backgroundColor: Colors.orange,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    // Mano flotante posicionada SOBRE el ícono (no lo desplaza)
                                    if (controller.vehiculosCliente.isEmpty)
                                      Positioned(
                                        top: 35,
                                        right: 14,
                                        child:
                                            CustomWidgets.buildFloatingHandPointer(),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // Mensaje indicando que no tiene vehículo el cliente verificados
                          if (controller.vehiculosCliente.isEmpty) ...[
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.fondoComponente.withValues(
                                  alpha: 0.3,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.borde.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: AppColors.iconoPrincipal,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Este cliente no tiene vehículos registrados. ¡Agrega uno!',
                                      style: TextStyle(
                                        color: AppColors.textoOscuro,
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],

                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.vehiculosCliente.length,
                            itemBuilder: (context, index) {
                              final v = controller.vehiculosCliente[index];
                              return ListTile(
                                title: Text(
                                  "${v.placa.toUpperCase()} - ${v.marca.toUpperCase()} ${v.modelo.toUpperCase()}",
                                  style: const TextStyle(
                                    color: Color.fromRGBO(
                                      58,
                                      96,
                                      120,
                                      1,
                                    ), // Blanco sobre fondo gris
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    backgroundColor: AppColors.textoEtiqueta,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete_forever,
                                    color: AppColors.iconoEliminar,
                                  ),
                                  onPressed: () =>
                                      controller.eliminarVehiculo(v.id),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/mantenimiento',
                                    arguments: {
                                      'vehiculoId': v.id,
                                      'cedulaId': controller.clienteEncontrado!.cedula,
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ],
                        if (!controller.buscando &&
                            controller.seHaBuscado &&
                            controller.clienteEncontrado == null &&
                            controller.cedulaController.text.isNotEmpty) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Cliente no encontrado',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.error,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.close,
                                color: AppColors.iconoEliminarActivo,
                              ),
                            ],
                          ),
                          const Divider(height: 5, color: Colors.white),
                        ],
                      ],
                    ),
                  ),
                ),
                if (controller.buscando)
                  Positioned.fill(
                    child: Container(
                      color: Color.fromARGB(255, 255, 255, 255,).withValues(alpha: 0.1),
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
