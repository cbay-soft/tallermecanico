import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../controllers/expediente_controller.dart';
import '../models/vehiculo_model.dart';
import '../models/mantenimiento_model.dart';

class MecanicoExpedienteScreen extends StatelessWidget {
  final String vehiculoId;

  const MecanicoExpedienteScreen({super.key, required this.vehiculoId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExpedienteController()..cargarExpediente(vehiculoId),
      child: Consumer<ExpedienteController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Expediente del Vehículo',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: AppColors.appBarFondo,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => controller.cargarExpediente(vehiculoId),
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
              child: controller.cargando
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : controller.vehiculo == null
                  ? _buildError('Vehículo no encontrado')
                  : _buildExpedienteContent(controller),
            ),
          );
        },
      ),
    );
  }

  Widget _buildError(String mensaje) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.white54),
          const SizedBox(height: 16),
          Text(
            mensaje,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildExpedienteContent(ExpedienteController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Información del vehículo
          _buildInfoVehiculo(controller.vehiculo!),

          const SizedBox(height: 20),

          // Estado actual de mantenimiento
          _buildEstadoActual(controller),

          const SizedBox(height: 20),

          // Historial de mantenimientos
          _buildHistorialMantenimientos(controller),
        ],
      ),
    );
  }

  Widget _buildInfoVehiculo(Vehiculo vehiculo) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.directions_car,
                  color: AppColors.iconoPrincipal,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Información del Vehículo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.white30),
            const SizedBox(height: 12),

            _buildInfoRow('Placa:', vehiculo.placa.toUpperCase()),
            _buildInfoRow('Marca:', vehiculo.marca),
            _buildInfoRow('Modelo:', vehiculo.modelo),
            _buildInfoRow('Año:', vehiculo.anio),
            _buildInfoRow('Kilometraje:', '${vehiculo.kilometraje} km'),
            _buildInfoRow('Cliente:', vehiculo.nombreCliente),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstadoActual(ExpedienteController controller) {
    final mantenimientos = controller.getMantenimientosVehiculo(vehiculoId);

    if (mantenimientos.isEmpty) {
      return Card(
        color: Colors.white.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.build_outlined, color: Colors.grey[400], size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'Estado Actual',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.white30),
              const Text(
                'Sin mantenimientos registrados',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    // Obtener el mantenimiento más reciente
    final ultimoMantenimiento = mantenimientos.first;

    return Card(
      color: Colors.white.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildIconoEstado(ultimoMantenimiento.estado),
                const SizedBox(width: 8),
                const Text(
                  'Estado Actual',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.white30),
            const SizedBox(height: 8),

            _buildChipEstado(ultimoMantenimiento.estado),
            const SizedBox(height: 12),

            if (ultimoMantenimiento.observaciones.isNotEmpty)
              _buildInfoRow(
                'Observaciones:',
                ultimoMantenimiento.observaciones,
              ),

            _buildInfoRow(
              'Fecha:',
              'Fecha no disponible', // Temporalmente hasta agregar fecha al modelo
            ),

            if (ultimoMantenimiento.fotos.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Fotos: ${ultimoMantenimiento.fotos.length}',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHistorialMantenimientos(ExpedienteController controller) {
    final mantenimientos = controller.getMantenimientosVehiculo(vehiculoId);

    return Card(
      color: Colors.white.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.history,
                  color: AppColors.iconoPrincipal,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Historial de Mantenimientos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.white30),
            const SizedBox(height: 12),

            if (mantenimientos.isEmpty)
              const Text(
                'No hay mantenimientos registrados',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              )
            else
              ...mantenimientos
                  .map(
                    (mantenimiento) => _buildMantenimientoCard(mantenimiento),
                  )
                  .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMantenimientoCard(Mantenimiento mantenimiento) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildChipEstado(mantenimiento.estado),
              const Text(
                'Fecha no disponible', // Temporalmente
                style: TextStyle(color: Colors.white60, fontSize: 12),
              ),
            ],
          ),

          if (mantenimiento.observaciones.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              mantenimiento.observaciones,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          if (mantenimiento.fotos.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.photo_camera,
                  color: AppColors.iconoPrincipal,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${mantenimiento.fotos.length} foto${mantenimiento.fotos.length != 1 ? 's' : ''}',
                  style: const TextStyle(
                    color: AppColors.iconoPrincipal,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildIconoEstado(String estado) {
    Color color;
    IconData icono;

    switch (estado) {
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

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icono, color: color, size: 16),
    );
  }

  Widget _buildChipEstado(String estado) {
    Color color;
    String texto;

    switch (estado) {
      case 'pendiente':
        color = AppColors.advertencia;
        texto = 'Pendiente';
        break;
      case 'en_proceso':
        color = Colors.orange;
        texto = 'En Proceso';
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        texto,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
