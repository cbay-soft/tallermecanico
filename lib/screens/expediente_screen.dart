import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/expediente_controller.dart';
import '../constants/app_colors.dart';
import '../models/vehiculo_model.dart';
import '../models/cliente_model.dart';
import 'detalle_vehiculo_screen.dart';

class ExpedienteScreen extends StatefulWidget {
  final String vehiculoId;
  
  const ExpedienteScreen({
    super.key,
    required this.vehiculoId,
  });

  @override
  State<ExpedienteScreen> createState() => _ExpedienteScreenState();
}

class _ExpedienteScreenState extends State<ExpedienteScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExpedienteController()..cargarExpediente(widget.vehiculoId),
      child: Consumer<ExpedienteController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBar(
              leading: const BackButton(color: Colors.white),
              title: const Text(
                'Expediente del Cliente',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: AppColors.appBarFondo,
              elevation: 0,
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
                  : controller.cliente == null
                      ? const Center(
                          child: Text(
                            'No se encontraron datos del cliente',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildClienteInfo(controller.cliente!),
                              const SizedBox(height: 24),
                              _buildVehiculosSection(controller),
                            ],
                          ),
                        ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildClienteInfo(Cliente cliente) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.person_outline,
                color: AppColors.iconoPrincipal,
                size: 28,
              ),
              const SizedBox(width: 12),
              const Text(
                'INFORMACIÓN - CLIENTE',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textoEtiqueta,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            cliente.nombre.toUpperCase(),
            style: const TextStyle(
              color: AppColors.textoTitulo,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          _buildInfoRow('Cédula', cliente.cedula, Icons.badge_outlined),
          _buildInfoRow('Teléfono', cliente.telefono, Icons.phone_outlined),
          _buildInfoRow('Email', cliente.correo, Icons.email_outlined),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: AppColors.iconoSecundario,
          ),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              color: AppColors.textoEtiqueta,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehiculosSection(ExpedienteController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.directions_car_outlined,
              color: AppColors.iconoPrincipal,
              size: 28,
            ),
            const SizedBox(width: 12),
            const Text(
              'VEHÍCULOS DEL CLIENTE',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textoEtiqueta,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.iconoPrincipal.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${controller.vehiculos.length}',
                style: const TextStyle(
                  color: AppColors.iconoPrincipal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...controller.vehiculos.map((vehiculo) => _buildVehiculoCard(vehiculo, controller)),
      ],
    );
  }

  Widget _buildVehiculoCard(Vehiculo vehiculo, ExpedienteController controller) {
    final mantenimientos = controller.getMantenimientosVehiculo(vehiculo.id);
    final ultimoMantenimiento = mantenimientos.isNotEmpty ? mantenimientos.first : null;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.iconoPrincipal.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.directions_car,
            color: AppColors.iconoPrincipal,
            size: 20,
          ),
        ),
        title: Text(
          '${vehiculo.marca} ${vehiculo.modelo} (${vehiculo.anio})',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Placa: ${vehiculo.placa.toUpperCase()}',
              style: const TextStyle(
                color: AppColors.textoEtiqueta,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            _buildEstadoMantenimiento(mantenimientos),
          ],
        ),
        iconColor: Colors.white,
        collapsedIconColor: Colors.white,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (mantenimientos.isEmpty)
                  _buildNoMantenimientos()
                else
                  ...mantenimientos.map((mantenimiento) => 
                    _buildMantenimientoItem(mantenimiento, vehiculo)
                  ),
                const SizedBox(height: 16),
                _buildBotonesAccion(vehiculo),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstadoMantenimiento(List<dynamic> mantenimientos) {
    if (mantenimientos.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'Sin mantenimientos',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    final ultimo = mantenimientos.first;
    final estado = ultimo['estado'] ?? 'pendiente';
    Color color;
    String texto;

    switch (estado) {
      case 'completado':
        color = AppColors.exito;
        texto = 'Último mantenimiento: Completado';
        break;
      case 'en_proceso':
        color = AppColors.advertencia;
        texto = 'Mantenimiento en proceso';
        break;
      default:
        color = AppColors.iconoSecundario;
        texto = 'Mantenimiento pendiente';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        texto,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildNoMantenimientos() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Wrap(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.grey,
            size: 20,
          ),
          SizedBox(width: 12),
          Text(
            'No se ha realizado ningún mantenimiento',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMantenimientoItem(dynamic mantenimiento, Vehiculo vehiculo) {
    final fecha = DateTime.parse(mantenimiento['fecha']);
    final estado = mantenimiento['estado'] ?? 'pendiente';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetalleVehiculoScreen(
                vehiculo: vehiculo,
                mantenimientoId: mantenimiento['id'],
              ),
            ),
          );
        },
        child: Row(
          children: [
            Icon(
              estado == 'completado' ? Icons.check_circle : Icons.schedule,
              color: estado == 'completado' ? AppColors.exito : AppColors.advertencia,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    estado == 'completado' 
                        ? 'Mantenimiento completado'
                        : 'Mantenimiento ${estado.replaceAll('_', ' ')}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${fecha.day}/${fecha.month}/${fecha.year}',
                    style: const TextStyle(
                      color: AppColors.textoEtiqueta,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.iconoSecundario,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBotonesAccion(Vehiculo vehiculo) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetalleVehiculoScreen(
                    vehiculo: vehiculo,
                    mantenimientoId: null,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.visibility_outlined),
            label: const Text('Ver más'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.iconoSecundario,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}