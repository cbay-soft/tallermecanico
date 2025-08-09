import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/clientes_controller.dart';
import '../controllers/vehiculos_controller.dart';
import '../constants/app_colors.dart';
import '../models/cliente_model.dart';
import 'expediente_screen.dart';

class ClientesScreen extends StatefulWidget {
  const ClientesScreen({super.key});

  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  final TextEditingController _busquedaController = TextEditingController();

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ClientesController()..cargarClientes(),
      child: Consumer<ClientesController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBar(
              leading: const BackButton(color: Colors.white),
              title: const Text(
                'Clientes Registrados',
                style: TextStyle(color: AppColors.appBarTexto),
              ),
              backgroundColor: AppColors.appBarFondo,
              elevation: 2,
            ),
            body: Container(
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
              child: Column(
                children: [
                  // Sección de búsqueda
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: const Icon(
                            Icons.people_outline,
                            color: AppColors.iconoPrincipal,
                            size: 40,
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
                              controller: _busquedaController,
                              decoration: InputDecoration(
                                filled: true,
                                labelText: 'Buscar por nombre o cédula',
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                labelStyle: const TextStyle(
                                  color: AppColors.textoAzul,
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.textoAzul,
                                  ),
                                ),
                                suffixIcon: _busquedaController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear, color: AppColors.textoAzul),
                                        onPressed: () {
                                          _busquedaController.clear();
                                          controller.filtrarClientes('');
                                          setState(() {});
                                        },
                                      )
                                    : null,
                              ),
                              onChanged: (value) {
                                controller.filtrarClientes(value);
                                setState(() {}); // Para actualizar suffixIcon
                              },
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
                          onPressed: () {
                            controller.filtrarClientes(_busquedaController.text);
                          },
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Estado actual
                  Text(
                    'Total de clientes: ${controller.clientes.length}',
                    style: const TextStyle(
                      color: AppColors.textoEtiqueta,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Lista de clientes
                  Expanded(
                    child: controller.cargando
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.iconoPrincipal,
                            ),
                          )
                        : _buildListaClientes(controller),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListaClientes(ClientesController controller) {
    final clientes = controller.clientes;
    
    if (clientes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.people_outline,
              size: 64,
              color: AppColors.iconoSecundario,
            ),
            const SizedBox(height: 16),
            Text(
              controller.filtroActual.isEmpty 
                  ? 'No hay clientes registrados'
                  : 'No se encontraron clientes',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textoEtiqueta,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.iconoPrincipal,
      onRefresh: controller.refrescar,
      child: ListView.builder(
        itemCount: clientes.length,
        itemBuilder: (context, index) {
          final cliente = clientes[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            color: AppColors.fondoComponente,
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.iconoPrincipal.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.person,
                  color: AppColors.iconoPrincipal,
                ),
              ),
              title: Text(
                cliente.nombre.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.textoTitulo,
                  fontWeight: FontWeight.w600,
                ),
              ), 
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cédula: ${cliente.cedula}',
                    style: const TextStyle(
                      color: AppColors.textoTitulo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Tel: ${cliente.telefono}',
                    style: const TextStyle(
                      color: AppColors.textoEtiqueta,
                      fontSize: 12,
                    ),
                  ),      
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Botón expediente
                  IconButton(
                    onPressed: () => _abrirExpedienteCliente(context, cliente),
                    icon: const Icon(
                      Icons.folder_open_outlined,
                      color: AppColors.iconoPrincipal,
                      size: 24,
                    ),
                    tooltip: 'Ver expediente',
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.iconoSecundario,
                    size: 16,
                  ),
                ],
              ),
              onTap: () {
                _mostrarDetallesCliente(context, cliente);
              },
            ),
          );
        },
      ),
    );
  }

  void _mostrarDetallesCliente(BuildContext context, Cliente cliente) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.fondoPrincipalClaro,
                  AppColors.fondoPrincipalOscuro,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Título
                Row(
                  children: [
                    const Icon(
                      Icons.person,
                      color: AppColors.iconoPrincipal,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'INFORMACIÓN - CLIENTE',
                      style: TextStyle(
                        color: AppColors.textoEtiqueta,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Información del cliente
                _detalleRow(cliente.nombre.toUpperCase(), icon: Icons.person_outline),
                _detalleRow('Cédula: ${cliente.cedula}', icon: Icons.badge_outlined),
                _detalleRow('Teléfono: ${cliente.telefono}', icon: Icons.phone_outlined),
                _detalleRow('Email: ${cliente.correo}', icon: Icons.email_outlined),
                
                const SizedBox(height: 24),
                
                // Botón expediente
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _abrirExpedienteCliente(context, cliente);
                    },
                    icon: const Icon(Icons.folder_open_outlined),
                    label: const Text('Ver Expediente Completo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.iconoPrincipal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Botón cerrar
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textoEtiqueta,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Cerrar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _detalleRow(String value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),  
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 20,
              color: AppColors.iconoPrincipal,
            ),
            const SizedBox(width: 25),
          ],
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textoSutil,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _abrirExpedienteCliente(BuildContext context, Cliente cliente) async {
    // Usar where().firstOrNull en lugar de firstWhere
    try {
      final vehiculosController = VehiculosController();
      await vehiculosController.cargarVehiculos();
      
      final vehiculosDelCliente = vehiculosController.todos.where(
        (vehiculo) => vehiculo.nombreCliente == cliente.nombre,
      ).toList();

      if (vehiculosDelCliente.isNotEmpty) {
        final vehiculoCliente = vehiculosDelCliente.first;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExpedienteScreen(vehiculoId: vehiculoCliente.id),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Este cliente no tiene vehículos registrados'),
            backgroundColor: AppColors.advertencia,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al cargar el expediente'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}