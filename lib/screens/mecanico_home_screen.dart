import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../controllers/mecanico_controller.dart';
import '../models/vehiculo_model.dart';
import 'mecanico_expediente_screen.dart';
import 'mecanico_mantenimiento_screen.dart';

class MecanicoHomeScreen extends StatefulWidget {
  const MecanicoHomeScreen({super.key});

  @override
  State<MecanicoHomeScreen> createState() => _MecanicoHomeScreenState();
}

class _MecanicoHomeScreenState extends State<MecanicoHomeScreen> {
  final TextEditingController _busquedaController = TextEditingController();

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MecanicoController()..cargarVehiculosMantenimiento(),
      child: Consumer<MecanicoController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Panel del Mecánico',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: AppColors.appBarFondo,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: controller.refrescar,
                ),
              ],
            ),
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.fondoPrincipalClaro,
                    AppColors.fondoPrincipalOscuro,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Encabezado con estadísticas
                    _buildEncabezadoEstadisticas(controller),

                    // Barra de búsqueda
                    _buildBarraBusqueda(controller),

                    // Lista de vehículos para mantenimiento
                    Expanded(
                      child: controller.cargando
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : _buildListaVehiculos(controller),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEncabezadoEstadisticas(MecanicoController controller) {
    final estadisticas = controller.obtenerEstadisticas();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          const Text(
            'Estado de Mantenimientos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildEstadisticaItem(
                'Pendientes',
                estadisticas['pendientes'].toString(),
                AppColors.advertencia,
                Icons.schedule,
              ),
              _buildEstadisticaItem(
                'En Proceso',
                estadisticas['enProceso'].toString(),
                Colors.orange,
                Icons.build,
              ),
              _buildEstadisticaItem(
                'Completados',
                estadisticas['completados'].toString(),
                AppColors.exito,
                Icons.check_circle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEstadisticaItem(
    String titulo,
    String valor,
    Color color,
    IconData icono,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(icono, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          valor,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          titulo,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildBarraBusqueda(MecanicoController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _busquedaController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Buscar por placa, marca o cliente...',
          hintStyle: const TextStyle(color: Colors.white60),
          prefixIcon: const Icon(Icons.search, color: Colors.white60),
          suffixIcon: _busquedaController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white60),
                  onPressed: () {
                    _busquedaController.clear();
                    controller.filtrarVehiculos('');
                    setState(() {});
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          controller.filtrarVehiculos(value);
          setState(() {});
        },
      ),
    );
  }

  Widget _buildListaVehiculos(MecanicoController controller) {
    final vehiculos = controller.vehiculosFiltrados;

    if (vehiculos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.build_circle_outlined,
              size: 64,
              color: Colors.white54,
            ),
            const SizedBox(height: 16),
            Text(
              controller.filtroActual.isEmpty
                  ? 'No hay vehículos para mantenimiento'
                  : 'No se encontraron vehículos',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.refrescar,
      color: AppColors.iconoPrincipal,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: vehiculos.length,
        itemBuilder: (context, index) {
          final vehiculo = vehiculos[index];
          final mantenimiento = controller.obtenerMantenimientoVehiculo(
            vehiculo.id,
          );

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            color: Colors.white.withOpacity(0.1),
            child: ListTile(
              leading: _buildIconoEstado(mantenimiento),
              title: Text(
                '${vehiculo.marca} ${vehiculo.modelo}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Placa: ${vehiculo.placa.toUpperCase()}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    'Cliente: ${vehiculo.nombreCliente}',
                    style: const TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  _buildChipEstado(mantenimiento),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Botón expediente
                  IconButton(
                    icon: const Icon(
                      Icons.folder_open,
                      color: AppColors.iconoPrincipal,
                    ),
                    onPressed: () => _abrirExpediente(vehiculo),
                    tooltip: 'Ver expediente',
                  ),
                  // Botón trabajar
                  IconButton(
                    icon: Icon(
                      mantenimiento != null &&
                              mantenimiento['estado'] == 'completado'
                          ? Icons.visibility
                          : Icons.build,
                      color: Colors.orange,
                    ),
                    onPressed: () =>
                        _abrirMantenimiento(vehiculo, mantenimiento),
                    tooltip:
                        mantenimiento != null &&
                            mantenimiento['estado'] == 'completado'
                        ? 'Ver mantenimiento'
                        : 'Trabajar',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIconoEstado(dynamic mantenimiento) {
    Color color;
    IconData icono;

    if (mantenimiento == null) {
      color = Colors.grey;
      icono = Icons.help_outline;
    } else {
      switch (mantenimiento['estado']) {
        case 'pendiente':
          color = AppColors.advertencia;
          icono = Icons.schedule;
          break;
        case 'en_proceso':
          color = Colors.orange;
          icono = Icons.build;
          break;
        case 'completado':
          color = AppColors.exito;
          icono = Icons.check_circle;
          break;
        default:
          color = Colors.grey;
          icono = Icons.help_outline;
      }
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(icono, color: color, size: 20),
    );
  }

  Widget _buildChipEstado(dynamic mantenimiento) {
    if (mantenimiento == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'Sin asignar',
          style: TextStyle(color: Colors.grey, fontSize: 10),
        ),
      );
    }

    Color color;
    String texto;

    switch (mantenimiento['estado']) {
      case 'pendiente':
        color = AppColors.advertencia;
        texto = 'Pendiente';
        break;
      case 'en_proceso':
        color = Colors.orange;
        texto = 'En proceso';
        break;
      case 'completado':
        color = AppColors.exito;
        texto = 'Completado';
        break;
      default:
        color = Colors.grey;
        texto = 'Desconocido';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        texto,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _abrirExpediente(Vehiculo vehiculo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MecanicoExpedienteScreen(vehiculoId: vehiculo.id),
      ),
    );
  }

  void _abrirMantenimiento(Vehiculo vehiculo, dynamic mantenimiento) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MecanicoMantenimientoScreen(
          vehiculo: vehiculo,
          mantenimiento: mantenimiento,
        ),
      ),
    );
  }
}
