import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/detalle_vehiculo_controller.dart';
import '../constants/app_colors.dart';
import '../models/vehiculo_model.dart';
import '../widgets/custom_widgets.dart';

class DetalleVehiculoScreen extends StatefulWidget {
  final Vehiculo vehiculo;
  final String? mantenimientoId;
  
  const DetalleVehiculoScreen({
    super.key,
    required this.vehiculo,
    this.mantenimientoId,
  });

  @override
  State<DetalleVehiculoScreen> createState() => _DetalleVehiculoScreenState();
}

class _DetalleVehiculoScreenState extends State<DetalleVehiculoScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DetalleVehiculoController()..cargarDetalle(widget.vehiculo.id, widget.mantenimientoId),
      child: Consumer<DetalleVehiculoController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBar(
              leading: const BackButton(color: Colors.white),
              title: Text(
                'Detalle - ${widget.vehiculo.placa.toUpperCase()}',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: AppColors.appBarFondo,
              elevation: 0,
            ),
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.fondoPrincipalClaro, AppColors.fondoPrincipalOscuro],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: controller.cargando
                  ? const Center(child: CircularProgressIndicator(color: Colors.white))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // ✅ USAR widget existente
                          CustomWidgets.buildVehiculoInfo(widget.vehiculo),
                          const SizedBox(height: 16),
                          // ✅ USAR widget existente
                          _buildEstadoSection(controller),
                          const SizedBox(height: 16),
                          // ✅ USAR widget existente para fotos
                          _buildFotosSection(controller),
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEstadoSection(DetalleVehiculoController controller) {
    if (controller.mantenimientos.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'No tiene mantenimientos pendientes',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final ultimo = controller.mantenimientos.first;
    final estado = ultimo['estado'] ?? 'pendiente';
    final fecha = DateTime.parse(ultimo['fecha']);
    final resumen = ultimo['resumenChecklist'];

    // ✅ USAR widget existente
    return CustomWidgets.buildEstadoMantenimiento(estado, fecha: fecha, resumen: resumen);
  }

  Widget _buildFotosSection(DetalleVehiculoController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          const Text(
            'FOTOS ÚLTIMAS',
            style: TextStyle(color: AppColors.textoEtiqueta, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          if (controller.fotos.isEmpty)
            const Text('No hay fotos disponibles', style: TextStyle(color: Colors.grey))
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // ✅ USAR widget existente
                CustomWidgets.buildImagePlaceholder('Foto 1'),
                CustomWidgets.buildImagePlaceholder('Foto 2'),
                CustomWidgets.buildImagePlaceholder('Foto 3'),
              ],
            ),
        ],
      ),
    );
  }
}