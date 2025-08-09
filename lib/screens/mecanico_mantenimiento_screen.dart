import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../controllers/mantenimiento_controller.dart';
import '../models/vehiculo_model.dart';
import '../widgets/camera_widget.dart';

class MecanicoMantenimientoScreen extends StatefulWidget {
  final Vehiculo vehiculo;
  final dynamic mantenimiento;

  const MecanicoMantenimientoScreen({
    super.key,
    required this.vehiculo,
    this.mantenimiento,
  });

  @override
  State<MecanicoMantenimientoScreen> createState() =>
      _MecanicoMantenimientoScreenState();
}

class _MecanicoMantenimientoScreenState
    extends State<MecanicoMantenimientoScreen> {
  final TextEditingController _observacionesController =
      TextEditingController();
  late MantenimientoController _controller;
  bool _guardando = false;

  // Mapa para manejar fotos capturadas en memoria
  final Map<String, File> _fotosCapturadas = {};

  @override
  void initState() {
    super.initState();
    _controller = MantenimientoController();

    // Si hay un mantenimiento existente, cargar sus datos
    if (widget.mantenimiento != null) {
      _observacionesController.text =
          widget.mantenimiento['observaciones'] ?? '';
    }
  }

  @override
  void dispose() {
    _observacionesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Consumer<MantenimientoController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                widget.mantenimiento != null
                    ? 'Mantenimiento'
                    : 'Nuevo Mantenimiento',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: AppColors.appBarFondo,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              actions: [
                if (widget.mantenimiento != null &&
                    widget.mantenimiento['estado'] != 'completado')
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onSelected: (value) => _cambiarEstado(value, controller),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'en_proceso',
                        child: Text('Marcar en proceso'),
                      ),
                      const PopupMenuItem(
                        value: 'completado',
                        child: Text('Marcar completado'),
                      ),
                    ],
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
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Información del vehículo
                          _buildInfoVehiculo(),

                          const SizedBox(height: 20),

                          // Estado del mantenimiento
                          if (widget.mantenimiento != null)
                            _buildEstadoMantenimiento(),

                          const SizedBox(height: 20),

                          // Observaciones
                          _buildObservaciones(),

                          const SizedBox(height: 20),

                          // Cámara para fotos
                          _buildSeccionFotos(controller),
                        ],
                      ),
                    ),
                  ),

                  // Botones de acción
                  _buildBotonesAccion(controller),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoVehiculo() {
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
                  'Vehículo',
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

            Text(
              '${widget.vehiculo.marca} ${widget.vehiculo.modelo}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Placa: ${widget.vehiculo.placa.toUpperCase()}',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            Text(
              'Cliente: ${widget.vehiculo.nombreCliente}',
              style: const TextStyle(color: Colors.white60, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstadoMantenimiento() {
    final estado = widget.mantenimiento['estado'];
    Color color;
    String texto;
    IconData icono;

    switch (estado) {
      case 'pendiente':
        color = AppColors.advertencia;
        texto = 'Pendiente';
        icono = Icons.schedule;
        break;
      case 'en_proceso':
        color = Colors.orange;
        texto = 'En Proceso';
        icono = Icons.build;
        break;
      case 'completado':
        color = AppColors.exito;
        texto = 'Completado';
        icono = Icons.check_circle;
        break;
      default:
        color = Colors.grey;
        texto = 'Desconocido';
        icono = Icons.help_outline;
    }

    return Card(
      color: Colors.white.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(icono, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Estado actual',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                Text(
                  texto,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildObservaciones() {
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
                  Icons.note_add,
                  color: AppColors.iconoPrincipal,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Observaciones',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _observacionesController,
              style: const TextStyle(color: Colors.white),
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Ingrese las observaciones del mantenimiento...',
                hintStyle: const TextStyle(color: Colors.white60),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.iconoPrincipal),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeccionFotos(MantenimientoController controller) {
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
                  Icons.photo_camera,
                  color: AppColors.iconoPrincipal,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Fotos del Mantenimiento',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Widget de cámara
            CameraWidget(
              vehiculoId: widget.vehiculo.id,
              tipoFoto: 'mantenimiento',
              onFotoCapturada: (File? foto) {
                // Manejar foto capturada
                setState(() {
                  if (foto != null) {
                    _fotosCapturadas['mantenimiento'] = foto;
                    print('📸 Foto capturada y guardada en memoria');
                  } else {
                    _fotosCapturadas.remove('mantenimiento');
                    print('🗑️ Foto eliminada de memoria');
                  }
                });
              },
            ),

            const SizedBox(height: 12),

            // Indicador de fotos capturadas
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _fotosCapturadas.isNotEmpty
                    ? AppColors.exito.withOpacity(0.1)
                    : Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _fotosCapturadas.isNotEmpty
                      ? AppColors.exito.withOpacity(0.3)
                      : Colors.blue.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _fotosCapturadas.isNotEmpty
                        ? Icons.photo_camera
                        : Icons.info_outline,
                    color: _fotosCapturadas.isNotEmpty
                        ? AppColors.exito
                        : Colors.lightBlue,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _fotosCapturadas.isNotEmpty
                          ? '${_fotosCapturadas.length} foto(s) capturada(s) - Se guardarán al confirmar'
                          : 'Las fotos se guardan temporalmente hasta que se complete el mantenimiento.',
                      style: TextStyle(
                        color: _fotosCapturadas.isNotEmpty
                            ? AppColors.exito
                            : Colors.lightBlue,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBotonesAccion(MantenimientoController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Botón cancelar
            Expanded(
              child: OutlinedButton(
                onPressed: () => _cancelarMantenimiento(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white60),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Cancelar'),
              ),
            ),

            const SizedBox(width: 16),

            // Botón guardar/completar
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _guardando
                    ? null
                    : () => _guardarMantenimiento(controller),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      widget.mantenimiento?['estado'] == 'completado'
                      ? AppColors.exito
                      : AppColors.iconoPrincipal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _guardando
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        widget.mantenimiento != null
                            ? 'Actualizar'
                            : 'Guardar Mantenimiento',
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _cambiarEstado(
    String nuevoEstado,
    MantenimientoController controller,
  ) async {
    // Aquí podrías implementar la lógica para cambiar el estado del mantenimiento
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Estado cambiado a ${_obtenerTextoEstado(nuevoEstado)}'),
        backgroundColor: AppColors.exito,
      ),
    );
  }

  String _obtenerTextoEstado(String estado) {
    switch (estado) {
      case 'pendiente':
        return 'Pendiente';
      case 'en_proceso':
        return 'En Proceso';
      case 'completado':
        return 'Completado';
      default:
        return 'Desconocido';
    }
  }

  void _cancelarMantenimiento() {
    // Cancelar fotos temporales
    _controller.cancelarFotosTemporales(widget.vehiculo.id);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _guardarMantenimiento(MantenimientoController controller) async {
    if (_observacionesController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingrese las observaciones'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _guardando = true;
    });

    try {
      // Guardar mantenimiento con fotos capturadas
      await controller.guardarMantenimientoConFotos(
        widget.vehiculo.id,
        fotosCapturadas: _fotosCapturadas,
        observacionAdicional: _observacionesController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mantenimiento guardado exitosamente'),
            backgroundColor: AppColors.exito,
          ),
        );

        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _guardando = false;
        });
      }
    }
  }
}
