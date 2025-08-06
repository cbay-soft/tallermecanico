import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/vehiculos_controller.dart';
import '../constants/app_colors.dart';
import '../constants/estados_vehiculo.dart';
import '../screens/expediente_screen.dart';
import '../screens/detalle_vehiculo_screen.dart';

enum TaskStatus { all, pending, completed }

class VehiculosScreen extends StatefulWidget {
  const VehiculosScreen({super.key});

  @override
  State<VehiculosScreen> createState() => _VehiculosScreenState();
}

class _VehiculosScreenState extends State<VehiculosScreen> {
  Set<TaskStatus> selection = {TaskStatus.all};
  final TextEditingController _busquedaController = TextEditingController();

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VehiculosController()..cargarVehiculos(),
      child: Consumer<VehiculosController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBar(
              leading: const BackButton(color: Colors.white),
              title: const Text(
                'Vehículos Ingresados',
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
                  // ✅ Sección de búsqueda
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: const Icon(
                            Icons.directions_car_filled_outlined,
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
                                // ✅ QUITAR const
                                filled: true,
                                labelText: 'Buscar por placa o cliente',
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
                                // ✅ CORREGIR: Hacer dinámico el suffixIcon
                                suffixIcon: _busquedaController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(
                                          Icons.clear,
                                          color: AppColors.textoAzul,
                                        ),
                                        onPressed: () {
                                          _busquedaController.clear();
                                          controller.limpiarFiltros();
                                          setState(() {}); // ✅ Actualizar UI
                                        },
                                      )
                                    : null,
                              ),
                              onChanged: (value) {
                                controller.filtrarVehiculos(value);
                                setState(() {}); // ✅ Para actualizar suffixIcon
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
                            controller.filtrarVehiculos(
                              _busquedaController.text,
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ✅ SegmentedButton
                  SegmentedButton<TaskStatus>(
                    segments: const <ButtonSegment<TaskStatus>>[
                      ButtonSegment<TaskStatus>(
                        value: TaskStatus.all,
                        label: Text('Todos'),
                        icon: Icon(Icons.list),
                      ),
                      ButtonSegment<TaskStatus>(
                        value: TaskStatus.pending,
                        label: Text('Pendientes'),
                        icon: Icon(Icons.hourglass_empty),
                      ),
                      ButtonSegment<TaskStatus>(
                        value: TaskStatus.completed,
                        label: Text('Realizados'),
                        icon: Icon(Icons.check_circle),
                      ),
                    ],
                    selected: selection,
                    onSelectionChanged: (Set<TaskStatus> newSelection) {
                      setState(() {
                        selection = newSelection;
                        _filtrarPorEstado(controller, newSelection.first);
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  // ✅ Estado actual
                  Text(
                    'Mostrando: ${_getEstadoTexto(selection.first)} (${_getConteo(controller, selection.first)})',
                    style: const TextStyle(
                      color: AppColors.textoEtiqueta,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ✅ Lista de vehículos
                  Expanded(
                    child: controller.cargando
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.iconoPrincipal,
                            ),
                          )
                        : _buildListaVehiculos(controller),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ✅ Método para filtrar por estado
  void _filtrarPorEstado(VehiculosController controller, TaskStatus estado) {
    switch (estado) {
      case TaskStatus.all:
        controller.mostrarTodos();
        break;
      case TaskStatus.pending:
        controller.mostrarPendientes();
        break;
      case TaskStatus.completed:
        controller.mostrarRealizados();
        break;
    }
  }

  // Obtener texto del estado
  String _getEstadoTexto(TaskStatus estado) {
    switch (estado) {
      case TaskStatus.all:
        return 'Todos';
      case TaskStatus.pending:
        return 'Pendientes';
      case TaskStatus.completed:
        return 'Realizados';
    }
  }

  int _getConteo(VehiculosController controller, TaskStatus estado) {
    switch (estado) {
      case TaskStatus.all:
        return controller.todos.length;
      case TaskStatus.pending:
        return controller.pendientes.length;
      case TaskStatus.completed:
        return controller.realizados.length;
    }
  }

  // Construir lista de vehículos
  Widget _buildListaVehiculos(VehiculosController controller) {
    final vehiculos = controller.vehiculosActuales;

    if (vehiculos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.directions_car_outlined,
              size: 64,
              color: AppColors.iconoSecundario,
            ),
            const SizedBox(height: 16),
            Text(
              'No hay vehículos ${_getEstadoTexto(selection.first).toLowerCase()}',
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
        itemCount: vehiculos.length,
        itemBuilder: (context, index) {
          final vehiculo = vehiculos[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            color: AppColors.fondoComponente,
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getColorEstado(
                    vehiculo.estado,
                  ).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  Icons.directions_car,
                  color: AppColors.iconoPrincipal,
                ),
              ),
              title: Text(
                '${vehiculo.nombreCliente.toUpperCase()} ',
                style: TextStyle(
                  color: AppColors.textoTitulo,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${vehiculo.placa.toUpperCase()} - ${vehiculo.marca} ${vehiculo.modelo}',
                    style: const TextStyle(
                      color: AppColors.textoTitulo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${vehiculo.estado.toUpperCase()} ',
                    style: TextStyle(
                      color: _getColorEstado(vehiculo.estado),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.iconoSecundario,
                size: 16,
              ),
              onTap: () {
                _mostrarDetallesVehiculo(context, vehiculo);
              },
            ),
          );
        },
      ),
    );
  }

  // Método _getColorEstado
  Color _getColorEstado(String estado) {
    return EstadosVehiculo.obtenerColorEstado(estado);
  }

  void _mostrarDetallesVehiculo(BuildContext context, dynamic vehiculo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: AppColors.fondoPrincipalClaro, // ✅ Usar tu color de fondo
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.fondoPrincipalClaro,
                    AppColors.fondoPrincipalOscuro,
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ✅ Estado y número
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getColorEstado(
                            vehiculo.estado,
                          ).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          vehiculo.estado.toUpperCase(),
                          style: TextStyle(
                            color: _getColorEstado(vehiculo.estado),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '#001',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textoEtiqueta,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Información del vehículo con íconos
                  _detalleRow(
                    vehiculo.nombreCliente.toUpperCase(),
                    icon: Icons.person_outline,
                  ),
                  _detalleRow(
                    '${vehiculo.marca.toUpperCase()} ${vehiculo.modelo.toUpperCase()} ${vehiculo.anio}',
                    icon: Icons.directions_car_outlined,
                  ),
                  _detalleRow(
                    vehiculo.placa.toUpperCase(),
                    icon: Icons.confirmation_number_outlined,
                  ),
                  _detalleRow(
                    vehiculo.anio.toString(),
                    icon: Icons.calendar_today_outlined,
                  ),

                  const SizedBox(height: 24),

                  // Botones de acción en la parte inferior
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _actionButton(
                        Icons.visibility_outlined,
                        'Ver más',
                        AppColors.iconoSecundario,
                        () {
                          Navigator.pop(context);
                          _verDetalleCompleto(context, vehiculo);
                        },
                      ),

                      _actionButton(
                        Icons.build_outlined,
                        'Historial',
                        AppColors.advertencia,
                        () {
                          Navigator.pop(context);
                          _verHistorialMantenimiento(context, vehiculo);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ✅ Botón cerrar
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
          ),
        );
      },
    );
  }

  // Widget para detalles con ícono (versión simple)
  Widget _detalleRow(String value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: AppColors.iconoPrincipal),
            const SizedBox(width: 25),
          ],
          Expanded(
            child: Text(
              value,
              style: TextStyle(
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

  // Widget para botones de acción
  Widget _actionButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.borde.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // Método para formatear fecha
  String _formatearFecha(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
  }

  void _verHistorialMantenimiento(BuildContext context, dynamic vehiculo) {
    // Navega al historial de mantenimientos
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Historial de mantenimientos de ${vehiculo.placa}'),
        backgroundColor: AppColors.advertencia,
      ),
    );
  }

  void _verFotosVehiculo(BuildContext context, dynamic vehiculo) {
    // Navega a galería de fotos del vehículo
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Fotos del vehículo ${vehiculo.placa}'),
        backgroundColor: AppColors.exito,
      ),
    );
  }

  // Funciones para las acciones de los botones
  void _abrirExpediente(BuildContext context, dynamic vehiculo) {
    // ✅ CAMBIAR: Navegar al expediente en lugar de SnackBar
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExpedienteScreen(vehiculoId: vehiculo.id),
      ),
    );
  }

  void _verDetalleCompleto(BuildContext context, dynamic vehiculo) {
    // ✅ CAMBIAR: Navegar al detalle en lugar de SnackBar
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DetalleVehiculoScreen(vehiculo: vehiculo, mantenimientoId: null),
      ),
    );
  }
}
