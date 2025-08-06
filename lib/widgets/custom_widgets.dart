import 'package:flutter/material.dart';
import 'package:tallermecanico/controllers/recepcion_controller.dart';
import '../constants/app_colors.dart';
import '../models/cliente_model.dart';
import '../models/vehiculo_model.dart';

class CustomWidgets {
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
            fontWeight: FontWeight.bold,
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
    final marcaController = TextEditingController();
    final modeloController = TextEditingController();
    final anioController = TextEditingController();
    final placaController = TextEditingController();
    final kilometrajeController = TextEditingController();

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
                      CustomWidgets.buildTextField(
                        'Kilometraje',
                        controller: kilometrajeController,
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
                                    placaController.text.trim().isEmpty ||
                                    kilometrajeController.text.trim().isEmpty) {
                                  showDialog(
                                    context: modalContext,
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        backgroundColor: AppColors.advertenciaFondo,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18),
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
                                                color: AppColors.advertenciaTexto,
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
                                            onPressed: () => Navigator.of(dialogContext).pop(),
                                            child: const Text(
                                              'Entendido',
                                              style: TextStyle(
                                                color: AppColors.advertenciaTexto,
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
                                  Navigator.pop(modalContext);

                                  await controller.guardarVehiculo(
                                    context,
                                    marcaController,
                                    modeloController,
                                    anioController,
                                    placaController,
                                    kilometrajeController,
                                  );

                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        margin: EdgeInsets.only(
                                          bottom: MediaQuery.of(context).viewInsets.bottom,
                                          left: 50,
                                          right: 50,
                                        ),
                                        content: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
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
                                  ScaffoldMessenger.of(modalContext).showSnackBar(
                                    SnackBar(
                                      content: Text('Error: $e'),
                                      backgroundColor: AppColors.error,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              },
                              child: const Text('Guardar Vehículo', textAlign: TextAlign.center),
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
      controller.setModalAbierto(false);
    });
  }

  // MODAL AGREGAR CLIENTE
  static void mostrarModalAgregarCliente(
    BuildContext context,
    RecepcionController controller,
  ) {
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
                        color: AppColors.botonPrincipalHover.withValues(alpha: 0.2),
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
                                if (nombreController.text.trim().isEmpty ||
                                    cedulaController.text.trim().isEmpty) {
                                  showDialog(
                                    context: modalContext,
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        backgroundColor: AppColors.advertenciaFondo,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18),
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
                                                color: AppColors.advertenciaTexto,
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
                                            onPressed: () => Navigator.of(dialogContext).pop(),
                                            child: const Text(
                                              'Entendido',
                                              style: TextStyle(
                                                color: AppColors.advertenciaTexto,
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
                                  controller.nombreController.text = nombreController.text;
                                  controller.cedulaController.text = cedulaController.text;
                                  controller.telefonoController.text = telefonoController.text;
                                  controller.correoController.text = correoController.text;

                                  controller.setModalAbierto(false);
                                  Navigator.pop(modalContext);

                                  await controller.registrarClienteNuevo(() {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                  ScaffoldMessenger.of(modalContext).showSnackBar(
                                    SnackBar(
                                      content: Text('Error: $e'),
                                      backgroundColor: AppColors.error,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              },
                              child: const Text('Guardar Cliente', textAlign: TextAlign.center),
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
      controller.setModalAbierto(false);
    });
  }

  static Widget buildFloatingHandPointer() {
    return const _FloatingHandPointer();
  }

  // ✅ WIDGET CLIENTE FLEXIBLE - Compatible con todos los casos
  static Widget buildClienteInfo(
    Cliente cliente, {
    bool mostrarNombre = true,
    bool mostrarCedula = true,
    bool mostrarTelefono = false,
    bool mostrarCorreo = false,
    String? titulo,
    bool compacto = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo ?? 'CLIENTE',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textoEtiqueta,
            ),
          ),
          const SizedBox(height: 8),
          
          if (compacto) ...[
            Row(
              children: [
                if (mostrarNombre) 
                  Expanded(
                    child: Text(
                      cliente.nombre.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.textoTitulo,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                if (mostrarCedula)
                  Text(
                    cliente.cedula,
                    style: const TextStyle(
                      color: AppColors.textoEtiqueta,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ] else ...[
            if (mostrarNombre)
              Text(
                cliente.nombre.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.textoTitulo,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (mostrarCedula) ...[
              const SizedBox(height: 4),
              Text(
                'Cédula: ${cliente.cedula}',
                style: const TextStyle(
                  color: AppColors.textoEtiqueta,
                  fontSize: 14,
                ),
              ),
            ],
            if (mostrarTelefono) ...[
              const SizedBox(height: 4),
              Text(
                'Teléfono: ${cliente.telefono}',
                style: const TextStyle(
                  color: AppColors.textoEtiqueta,
                  fontSize: 14,
                ),
              ),
            ],
            if (mostrarCorreo) ...[
              const SizedBox(height: 4),
              Text(
                'Email: ${cliente.correo}',
                style: const TextStyle(
                  color: AppColors.textoEtiqueta,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  // ✅ WIDGET VEHÍCULO FLEXIBLE - Compatible con todos los casos
  static Widget buildVehiculoInfo(
    Vehiculo vehiculo, {
    bool mostrarPlaca = true,
    bool mostrarMarca = true,
    bool mostrarModelo = true,
    bool mostrarAnio = true,
    bool mostrarKilometraje = false,
    bool mostrarCliente = false,
    String? titulo,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo ?? 'VEHÍCULO',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textoEtiqueta,
            ),
          ),
          const SizedBox(height: 12),
          
          if (mostrarCliente)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: buildInfoField('Cliente', vehiculo.nombreCliente),
            ),
          if (mostrarPlaca || mostrarMarca)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  if (mostrarPlaca) Expanded(child: buildInfoField('Placa', vehiculo.placa.toUpperCase())),
                  if (mostrarMarca) Expanded(child: buildInfoField('Marca', vehiculo.marca)),
                ],
              ),
            ),
          if (mostrarModelo || mostrarAnio)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  if (mostrarModelo) Expanded(child: buildInfoField('Modelo', vehiculo.modelo)),
                  if (mostrarAnio) Expanded(child: buildInfoField('Año', vehiculo.anio)),
                ],
              ),
            ),
          if (mostrarKilometraje)
            buildInfoField('Kilometraje', vehiculo.kilometraje ?? 'N/A'),
        ],
      ),
    );
  }

  // Campos específicos para Cliente
  static Widget cliente(
    Cliente cliente, {
    List<String> campos = const ['nombre', 'cedula'],
    String? titulo,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (titulo != null) ...[
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textoEtiqueta,
              ),
            ),
            const SizedBox(height: 8),
          ],
          
          ...campos.map((campo) {
            switch (campo.toLowerCase()) {
              case 'nombre':
                return _buildCampoTexto(cliente.nombre.toUpperCase(), esTitulo: true);
              case 'cedula':
                return _buildCampoTexto('Cédula: ${cliente.cedula}');
              case 'telefono':
                return _buildCampoTexto('Teléfono: ${cliente.telefono}');
              case 'correo':
              case 'email':
                return _buildCampoTexto('Email: ${cliente.correo}');
              default:
                return const SizedBox.shrink();
            }
          }).toList(),
        ],
      ),
    );
  }

  static Widget vehiculo(
    Vehiculo vehiculo, {
    List<String> campos = const ['placa', 'marca', 'modelo', 'anio'],
    String? titulo,
    bool mostrarEnFilas = true,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (titulo != null) ...[
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textoEtiqueta,
              ),
            ),
            const SizedBox(height: 12),
          ],
          
          if (mostrarEnFilas) ...[
            for (int i = 0; i < campos.length; i += 2) ...[
              Row(
                children: [
                  SizedBox(width: 10,),
                  SizedBox(width:160, child: _buildCampoVehiculo(vehiculo, campos[i])),
                  const SizedBox(width: 10),
                  if (i + 1 < campos.length)
                    SizedBox(width:100, child: _buildCampoVehiculo(vehiculo, campos[i + 1]))
                  else
                    const SizedBox(width:20),
                ],
              ),
              if (i + 2 < campos.length) const SizedBox(height: 12),
            ],
          ] else ...[
            ...campos.map((campo) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildCampoVehiculo(vehiculo, campo),
            )).toList(),
          ],
        ],
      ),
    );
  }

  // ✅ MÉTODOS AUXILIARES ESTÁTICOS
  static Widget _buildCampoTexto(String texto, {bool esTitulo = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Center(
        child: Text(
          texto,
          style: TextStyle(
            color: esTitulo ? AppColors.textoTitulo : AppColors.textoEtiqueta,
            fontSize: esTitulo ? 20 : 14,
            fontWeight: esTitulo ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),  
    );
  }

  static Widget _buildCampoVehiculo(Vehiculo vehiculo, String campo) {
    String label, valor;
    
    switch (campo.toLowerCase()) {
      case 'placa':
        label = 'Placa: ${vehiculo.placa.toUpperCase()}';
        valor = vehiculo.placa.toUpperCase();
        break;
      case 'marca':
        label = 'Marca:';
        valor = vehiculo.marca.substring(0, 1).toUpperCase() + vehiculo.marca.substring(1).toLowerCase();
        break;
      case 'modelo':
        label = 'Modelo:';
        valor = vehiculo.modelo.substring(0, 1).toUpperCase() + vehiculo.modelo.substring(1).toLowerCase();
        break;
      case 'anio':
      case 'año':
        label = 'Año:';
        valor = vehiculo.anio;
        break;
      case 'kilometraje':
        label = 'Kilometraje:';
        valor = vehiculo.kilometraje ?? 'km';
        break;
      case 'cliente':
      case 'propietario':
        label = 'Cliente:';
        valor = vehiculo.nombreCliente.toUpperCase();
        break;
      case 'estado':
        label = 'Estado:';
        valor = vehiculo.estado;
        break;
      default:
        return const SizedBox.shrink();
    }
    
    return buildInfoField(label, valor);
  }

  static Widget buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          textAlign: TextAlign.start,
          style: const TextStyle(
            color: AppColors.textoEtiqueta,
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  static Widget buildEstadoMantenimiento(String estado, {DateTime? fecha, Map<String, dynamic>? resumen}) {
    Color color;
    String texto;
    IconData icono;

    switch (estado) {
      case 'completado':
        color = AppColors.exito;
        texto = 'Completado';
        icono = Icons.check_circle;
        break;
      case 'en_proceso':
        color = AppColors.advertencia;
        texto = 'En Proceso';
        icono = Icons.schedule;
        break;
      default:
        color = AppColors.iconoSecundario;
        texto = 'Pendiente';
        icono = Icons.pending;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icono, color: color, size: 24),
              const SizedBox(width: 12),
              Text(
                texto,
                style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          if (fecha != null) ...[
            const SizedBox(height: 8),
            Text(
              'Fecha: ${fecha.day}/${fecha.month}/${fecha.year}',
              style: const TextStyle(color: AppColors.textoEtiqueta, fontSize: 14),
            ),
          ],
          if (resumen != null && resumen.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Progreso: ${resumen['porcentaje'] ?? 0}%',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }
}

// ✅ CLASE SEPARADA PARA ANIMACIÓN
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
            Icons.touch_app,
            color: AppColors.iconoPrincipal,
            size: 30,
          ),
        );
      },
    );
  }
}