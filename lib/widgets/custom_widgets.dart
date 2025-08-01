import 'package:flutter/material.dart';
import 'package:tallermecanico/controllers/recepcion_controller.dart';
import '../constants/app_colors.dart';

class CustomWidgets {
  // ========================================
  // 🎨 CAMPOS DE TEXTO
  // ========================================

  static Widget buildTextField(
    String label, {
    TextEditingController? controller,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: AppColors.textoOscuro, fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.textoPlaceholder),
          floatingLabelStyle: const TextStyle(
            color: AppColors.textoPlaceholder,
            fontSize: 12,
            fontWeight: FontWeight.bold, // ✅ Más bold para mejor contraste
          ),
          filled: true,
          fillColor: AppColors.fondoInput,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.borde, width: 1),
          ),
          enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: AppColors.borde, width: 1),
          ),
          focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(
              color: AppColors.fondoPrincipalClaro,
              width: 6,
            ),
          ),
        ),
      ),
    );
  }

  static Widget buildMultilineTextField(
    String hint, {
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      maxLines: 5,
      style: const TextStyle(color: AppColors.textoOscuro, fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textoPlaceholder),
        filled: true,
        fillColor: AppColors.fondoInput,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borde),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.bordeActivo, width: 2),
        ),
      ),
    );
  }

  static Widget buildImagePlaceholder(String label) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.fondoComponente,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borde, width: 1),
          ),
          child: Icon(Icons.image, size: 40, color: AppColors.iconoSecundario),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: AppColors.textoEtiqueta, fontSize: 12),
        ),
      ],
    );
  }

  // MODAL AGREGAR VEHÍCULO
  static void mostrarModalAgregarVehiculo(
    BuildContext context,
    RecepcionController controller,
  ) {
    // ✅ CONTROLADORES LOCALES E INDEPENDIENTES
    final marcaController = TextEditingController();
    final modeloController = TextEditingController();
    final anioController = TextEditingController();
    final placaController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext modalContext) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.fondoPrincipalClaro,
                AppColors.fondoPrincipalOscuro,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(80),
            ),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 30,
            right: 30,
            top: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header del modal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Agregar Nuevo Vehículo',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textoTitulo,
                        ),
                      ),
                      Text(
                        'Complete los datos del vehículo',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textoEtiqueta,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.iconoPrincipal,
                      size: 28,
                    ),
                    onPressed: () {
                      controller.setModalAbierto(false);
                      Navigator.pop(modalContext);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Información del cliente
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.fondoComponente,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: AppColors.borde.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.botonPrincipalHover.withValues(
                          alpha: 0.2,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Icon(
                        Icons.directions_car,
                        color: AppColors.iconoPrincipal,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cliente:',
                            style: TextStyle(
                              color: AppColors.textoEtiqueta,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            controller.clienteEncontrado!.nombre,
                            style: const TextStyle(
                              color: AppColors.textoTitulo,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.verified, color: AppColors.exito, size: 20),
                  ],
                ),
              ),

              // Formulario
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 3),
                      CustomWidgets.buildTextField(
                        'Marca *',
                        controller: marcaController,
                      ),
                      CustomWidgets.buildTextField(
                        'Modelo *',
                        controller: modeloController,
                      ),
                      CustomWidgets.buildTextField(
                        'Placa *',
                        controller: placaController,
                      ),
                      CustomWidgets.buildTextField(
                        'Año',
                        controller: anioController,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),

                      // Botones
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.botonSecundario,
                                foregroundColor: AppColors.botonSecundarioTexto,
                                minimumSize: const Size.fromHeight(50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                controller.setModalAbierto(false);
                                Navigator.pop(modalContext);
                              },
                              child: const Text('Cancelar'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.botonPrincipalHover
                                    .withValues(alpha: 0.4),
                                foregroundColor: AppColors.botonPrincipalTexto,
                                minimumSize: const Size.fromHeight(50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () async {
                                // Validar campos obligatorios
                                if (marcaController.text.trim().isEmpty ||
                                    modeloController.text.trim().isEmpty ||
                                    placaController.text.trim().isEmpty) {
                                  // USAR DIÁLOGO en lugar de SnackBar
                                  showDialog(
                                    context: modalContext,
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        backgroundColor:
                                            AppColors.advertenciaFondo,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                        ),
                                        title: Row(
                                          children: [
                                            Icon(
                                              Icons.warning,
                                              color: AppColors.textoOscuro,
                                              size: 60,
                                            ),
                                            const SizedBox(width: 8),
                                            const Text(
                                              'Campos requeridos',
                                              style: TextStyle(
                                                color:
                                                    AppColors.advertenciaTexto,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                        content: const Text(
                                          'Complete todos los campos obligatorios (*)',
                                          style: TextStyle(
                                            color: AppColors.advertenciaTexto,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(
                                              dialogContext,
                                            ).pop(),
                                            child: const Text(
                                              'Entendido',
                                              style: TextStyle(
                                                color:
                                                    AppColors.advertenciaTexto,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  return;
                                }
                                try {
                                  controller.setModalAbierto(false);
                                  Navigator.pop(
                                    modalContext,
                                  ); // Cerrar modal primero

                                  // 2. Usar método del controller directamente
                                  await controller.guardarVehiculo(
                                    context,
                                    marcaController,
                                    modeloController,
                                    anioController,
                                    placaController,
                                  );

                                  // 3. Mostrar mensaje de éxito
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,
                                          left: 50,
                                          right: 50,
                                        ),
                                        content: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              color: AppColors.textoAzul,
                                              size: 15,
                                            ),
                                            const SizedBox(width: 8),
                                            const Text(
                                              'Vehículo agregado exitosamente',
                                              style: TextStyle(
                                                color: AppColors.textoAzul,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        backgroundColor: AppColors.exitoClaro,
                                        behavior: SnackBarBehavior.floating,
                                        duration: const Duration(seconds: 3),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(modalContext,).showSnackBar(
                                    SnackBar(
                                      content: Text('Error: $e'),
                                      backgroundColor: AppColors.error,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              },
                              child: const Text('Guardar Vehículo', textAlign: TextAlign.center,),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).then((_) {
      // Asegurar que se marca como cerrado si se cierra por swipe o back
      controller.setModalAbierto(false);
    });
  }

  // MODAL AGREGAR CLIENTE
  static void mostrarModalAgregarCliente(
    BuildContext context,
    RecepcionController controller,
  ) {
    // ✅ CONTROLADORES LOCALES E INDEPENDIENTES
    final nombreController = TextEditingController();
    final cedulaController = TextEditingController();
    final telefonoController = TextEditingController();
    final correoController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext modalContext) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.fondoPrincipalClaro,
                AppColors.fondoPrincipalOscuro,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(80),
            ),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 30,
            right: 30,
            top: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header del modal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Agregar Nuevo Cliente',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textoTitulo,
                        ),
                      ),
                      Text(
                        'Complete la información del cliente',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textoEtiqueta,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.iconoPrincipal,
                      size: 28,
                    ),
                    onPressed: () {
                      controller.setModalAbierto(false);
                      Navigator.pop(modalContext);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Icono destacado
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: AppColors.fondoComponente,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.botonPrincipalHover.withValues(
                          alpha: 0.2,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Icons.person_add,
                        color: AppColors.iconoPrincipal,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Registrar nuevo cliente',
                            style: TextStyle(
                              color: AppColors.textoTitulo,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Los campos con * son obligatorios',
                            style: TextStyle(
                              color: AppColors.textoEtiqueta,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Formulario
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomWidgets.buildTextField(
                        'Nombre completo *',
                        controller: nombreController,
                      ),
                      CustomWidgets.buildTextField(
                        'Cédula o RUC *',
                        controller: cedulaController,
                        keyboardType: TextInputType.number,
                      ),
                      CustomWidgets.buildTextField(
                        'Teléfono',
                        controller: telefonoController,
                        keyboardType: TextInputType.number,
                      ),
                      CustomWidgets.buildTextField(
                        'Correo electrónico',
                        controller: correoController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),

                      // Botones
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.botonSecundario,
                                foregroundColor: AppColors.botonSecundarioTexto,
                                minimumSize: const Size.fromHeight(50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                controller.setModalAbierto(false);
                                Navigator.pop(modalContext);
                              },
                              child: const Text('Cancelar'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.botonPrincipalHover
                                    .withValues(alpha: 0.4),
                                foregroundColor: AppColors.botonPrincipalTexto,
                                minimumSize: const Size.fromHeight(50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () async {
                                // ✅ Validar campos obligatorios
                                if (nombreController.text.trim().isEmpty ||
                                    cedulaController.text.trim().isEmpty) {
                                  showDialog(
                                    context: modalContext,
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        backgroundColor:
                                            AppColors.advertenciaFondo,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                        ),
                                        title: Row(
                                          children: [
                                            Icon(
                                              Icons.warning,
                                              color: AppColors.textoOscuro,
                                              size: 60,
                                            ),
                                            const SizedBox(width: 8),
                                            const Text(
                                              'Campos requeridos',
                                              style: TextStyle(
                                                color:
                                                    AppColors.advertenciaTexto,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                        content: const Text(
                                          'Complete todos los campos obligatorios (*)',
                                          style: TextStyle(
                                            color: AppColors.advertenciaTexto,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(
                                              dialogContext,
                                            ).pop(),
                                            child: const Text(
                                              'Entendido',
                                              style: TextStyle(
                                                color:
                                                    AppColors.advertenciaTexto,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  return;
                                }

                                try {
                                  // 1. Asignar valores a los controladores del controller
                                  controller.nombreController.text =
                                      nombreController.text;
                                  controller.cedulaController.text =
                                      cedulaController.text;
                                  controller.telefonoController.text =
                                      telefonoController.text;
                                  controller.correoController.text =
                                      correoController.text;

                                  // 2. Cerrar modal primero
                                  controller.setModalAbierto(
                                    false,
                                  ); // Marcar como cerrado
                                  Navigator.pop(modalContext);

                                  // 3. Usar método del controller directamente
                                  await controller.registrarClienteNuevo(() {
                                    // 4. Mostrar mensaje de éxito
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.check_circle,
                                                color: AppColors.textoAzul,
                                              ),
                                              const SizedBox(width: 8),
                                              const Text(
                                                'Cliente registrado exitosamente',
                                                style: TextStyle(
                                                  color: AppColors.textoAzul,
                                                ),
                                              ),
                                            ],
                                          ),
                                          backgroundColor: AppColors.exito,
                                          behavior: SnackBarBehavior.floating,
                                          duration: const Duration(seconds: 3),
                                        ),
                                      );
                                    }
                                  });
                                } catch (e) {
                                  ScaffoldMessenger.of(
                                    modalContext,
                                  ).showSnackBar(
                                    SnackBar(
                                      content: Text('Error: $e'),
                                      backgroundColor: AppColors.error,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              },
                              child: const Text('Guardar Cliente', textAlign: TextAlign.center,),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).then((_) {
      // Asegurar que se marca como cerrado si se cierra por swipe o back
      controller.setModalAbierto(false);
    });
  }

  static Widget buildFloatingHandPointer() {
    return const _FloatingHandPointer();
  }

}

class _FloatingHandPointer extends StatefulWidget {
  const _FloatingHandPointer();

  @override
  State<_FloatingHandPointer> createState() => _FloatingHandPointerState();
}

class _FloatingHandPointerState extends State<_FloatingHandPointer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: const Icon(
            Icons.touch_app, // ✅ Ícono de mano apuntando
            color: AppColors.iconoPrincipal,
            size: 30,
          ),
        );
      },
    );
  }
}