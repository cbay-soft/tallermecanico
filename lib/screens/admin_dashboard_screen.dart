import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/admin_controller.dart';
import '../constants/app_colors.dart';
import 'admin_usuarios_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminController()..cargarEstadisticas(),
      child: Consumer<AdminController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Dashboard Administrativo',
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
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título de bienvenida
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                            ),
                            child: const Column(
                              children: [
                                Icon(
                                  Icons.admin_panel_settings,
                                  color: AppColors.iconoPrincipal,
                                  size: 48,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Panel de Administración',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Taller Mecánico ESPE',
                                  style: TextStyle(
                                    color: AppColors.textoEtiqueta,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Estadísticas generales
                          _buildEstadisticasGenerales(controller.estadisticas),

                          const SizedBox(height: 24),

                          // Botones de acciones
                          _buildBotonesAccion(context),

                          const SizedBox(height: 24),

                          // Estadísticas de mantenimientos
                          _buildEstadisticasMantenimientos(
                            controller.estadisticas,
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

  Widget _buildEstadisticasGenerales(Map<String, dynamic> estadisticas) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Estadísticas Generales',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            _buildEstadisticaCard(
              'Clientes',
              estadisticas['totalClientes']?.toString() ?? '0',
              Icons.people,
              AppColors.iconoPrincipal,
            ),
            _buildEstadisticaCard(
              'Vehículos',
              estadisticas['totalVehiculos']?.toString() ?? '0',
              Icons.directions_car,
              AppColors.exito,
            ),
            _buildEstadisticaCard(
              'Mantenimientos',
              estadisticas['totalMantenimientos']?.toString() ?? '0',
              Icons.build,
              AppColors.advertencia,
            ),
            _buildEstadisticaCard(
              'Usuarios',
              estadisticas['totalUsuarios']?.toString() ?? '0',
              Icons.person_add,
              AppColors.iconoSecundario,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEstadisticaCard(
    String titulo,
    String valor,
    IconData icono,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icono, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            valor,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            titulo,
            style: const TextStyle(
              color: AppColors.textoEtiqueta,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotonesAccion(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Acciones Administrativas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminUsuariosScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.people_alt),
                label: const Text('Gestionar Usuarios'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.iconoPrincipal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEstadisticasMantenimientos(Map<String, dynamic> estadisticas) {
    final mantenimientos = estadisticas['mantenimientos'] ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          children: [
            Expanded(
              child: _buildEstadisticaCard(
                'Pendientes',
                mantenimientos['pendientes']?.toString() ?? '0',
                Icons.schedule,
                AppColors.advertencia,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildEstadisticaCard(
                'En Proceso',
                mantenimientos['enProceso']?.toString() ?? '0',
                Icons.build,
                AppColors.iconoSecundario,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildEstadisticaCard(
                'Completados',
                mantenimientos['completados']?.toString() ?? '0',
                Icons.check_circle,
                AppColors.exito,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
