import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/admin_controller.dart';
import '../constants/app_colors.dart';

class AdminUsuariosScreen extends StatefulWidget {
  const AdminUsuariosScreen({super.key});

  @override
  State<AdminUsuariosScreen> createState() => _AdminUsuariosScreenState();
}

class _AdminUsuariosScreenState extends State<AdminUsuariosScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminController()..cargarUsuarios(),
      child: Consumer<AdminController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Gestión de Usuarios',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: AppColors.appBarFondo,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
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
                  // Botón para crear usuario
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            _mostrarDialogoCrearUsuario(context, controller),
                        icon: const Icon(Icons.person_add),
                        label: const Text('Crear Nuevo Usuario'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.textoEtiqueta,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ),

                  // Lista de usuarios
                  Expanded(
                    child: controller.cargando
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : controller.usuarios.isEmpty
                        ? const Center(
                            child: Text(
                              'No hay usuarios registrados',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: controller.usuarios.length,
                            itemBuilder: (context, index) {
                              final usuario = controller.usuarios[index];
                              return _buildUsuarioCard(usuario, controller);
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUsuarioCard(
    Map<String, dynamic> usuario,
    AdminController controller,
  ) {
    final esActivo = usuario['activo'] ?? true;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: esActivo
              ? Colors.white.withValues(alpha: 0.2)
              : Colors.red.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Ícono según el rol
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getColorPorRol(usuario['rol']).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getIconoPorRol(usuario['rol']),
                  color: _getColorPorRol(usuario['rol']),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),

              // Información del usuario
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      usuario['nombre'] ?? 'Sin nombre',
                      style: TextStyle(
                        color: esActivo ? Colors.white : Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      usuario['email'] ?? 'Sin email',
                      style: TextStyle(
                        color: esActivo ? AppColors.textoEtiqueta : Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Switch de estado
              Switch(
                value: esActivo,
                onChanged: (valor) async {
                  try {
                    await controller.cambiarEstadoUsuario(usuario['id'], valor);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          valor ? 'Usuario activado' : 'Usuario desactivado',
                        ),
                        backgroundColor: AppColors.exito,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                },
                activeColor: AppColors.exito,
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Información adicional
          Row(
            children: [
              Expanded(
                child: Text(
                  'Rol: ${_getNombreRol(usuario['rol'])}',
                  style: const TextStyle(
                    color: AppColors.textoEtiqueta,
                    fontSize: 12,
                  ),
                ),
              ),
              if (usuario['telefono'] != null)
                Text(
                  'Tel: ${usuario['telefono']}',
                  style: const TextStyle(
                    color: AppColors.textoEtiqueta,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getColorPorRol(String? rol) {
    switch (rol) {
      case 'recepcionista':
        return AppColors.iconoPrincipal;
      case 'mecanico':
        return AppColors.advertencia;
      default:
        return AppColors.iconoSecundario;
    }
  }

  IconData _getIconoPorRol(String? rol) {
    switch (rol) {
      case 'recepcionista':
        return Icons.person_outline;
      case 'mecanico':
        return Icons.build;
      default:
        return Icons.person;
    }
  }

  String _getNombreRol(String? rol) {
    switch (rol) {
      case 'recepcionista':
        return 'Recepcionista';
      case 'mecanico':
        return 'Mecánico';
      default:
        return 'Usuario';
    }
  }

  void _mostrarDialogoCrearUsuario(
    BuildContext context,
    AdminController controller,
  ) {
    final nombreController = TextEditingController();
    final emailController = TextEditingController();
    final telefonoController = TextEditingController();
    final passwordController = TextEditingController();
    String rolSeleccionado = 'recepcionista';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Crear Nuevo Usuario'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre completo',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: telefonoController,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: rolSeleccionado,
                  decoration: const InputDecoration(
                    labelText: 'Rol',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'recepcionista',
                      child: Text('Recepcionista'),
                    ),
                    DropdownMenuItem(
                      value: 'mecanico',
                      child: Text('Mecánico'),
                    ),
                  ],
                  onChanged: (valor) {
                    setState(() {
                      rolSeleccionado = valor!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nombreController.text.isEmpty ||
                    emailController.text.isEmpty ||
                    passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Por favor complete todos los campos obligatorios',
                      ),
                      backgroundColor: AppColors.error,
                    ),
                  );
                  return;
                }

                try {
                  await controller.crearUsuario(
                    nombre: nombreController.text,
                    email: emailController.text,
                    telefono: telefonoController.text,
                    rol: rolSeleccionado,
                    password: passwordController.text,
                  );

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Usuario creado exitosamente'),
                      backgroundColor: AppColors.exito,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
              child: const Text('Crear'),
            ),
          ],
        ),
      ),
    );
  }
}
