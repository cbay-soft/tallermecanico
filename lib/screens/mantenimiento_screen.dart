import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tallermecanico/widgets/camera_widget.dart';
import 'package:tallermecanico/widgets/checklist_mantenimiento_widget.dart';
import 'package:tallermecanico/widgets/custom_widgets.dart';
import '../constants/app_colors.dart';
import '../controllers/mantenimiento_controller.dart';
import '../models/vehiculo_model.dart';
import '../models/cliente_model.dart';
import '../services/firebase_service.dart';

class MantenimientoScreen extends StatefulWidget {
  final String vehiculoId;
  final String cedulaId;

  const MantenimientoScreen({
    super.key,
    required this.vehiculoId,
    required this.cedulaId,
  });

  @override
  State<MantenimientoScreen> createState() => _MantenimientoScreenState();
}

class _MantenimientoScreenState extends State<MantenimientoScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _observacionesController =
      TextEditingController();
  Vehiculo? vehiculo;
  Cliente? cliente;
  bool cargando = true;

  // Map para manejar fotos capturadas
  final Map<String, File> _fotosCapturadas = {};

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  @override
  void dispose() {
    _observacionesController.dispose();
    super.dispose();
  }

  Future<void> _cargarDatos() async {
    try {
      // Cargar vehículo
      final vehiculoDoc = await _firebaseService.firestore
          .collection('vehiculos')
          .doc(widget.vehiculoId)
          .get();

      // Cargar cliente
      final clienteQuery = await _firebaseService.firestore
          .collection('clientes')
          .where('cedula', isEqualTo: widget.cedulaId)
          .get();

      if (vehiculoDoc.exists && clienteQuery.docs.isNotEmpty) {
        setState(() {
          vehiculo = Vehiculo.fromMap(vehiculoDoc.id, vehiculoDoc.data()!);
          cliente = Cliente.fromMap(
            clienteQuery.docs.first.id,
            clienteQuery.docs.first.data(),
          );
          cargando = false;
        });
      }
    } catch (e) {
      print('Error cargando datos: $e');
      setState(() {
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MantenimientoController(),
      child: Consumer<MantenimientoController>(
        builder: (context, mantenimientoController, _) {
          return Scaffold(
            appBar: AppBar(
              leading: const BackButton(color: Colors.white),
              title: const Text(
                'Mantenimiento',
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
              child: SafeArea(
                child: cargando
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : (vehiculo == null || cliente == null)
                    ? const Center(
                        child: Text(
                          'No se encontraron los datos',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // USAR SOLO CAMPOS DISPONIBLES DEL VEHÍCULO
                            CustomWidgets.vehiculo(
                              vehiculo!,
                              campos: [
                                'cliente',
                                'placa',
                                'marca',
                                'modelo',
                                'anio',
                                'kilometraje',
                              ],
                              //titulo: 'VEHÍCULO',
                            ),

                            const SizedBox(height: 16),

                            // Indicador de estado del servicio de fotos
                            /*Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: mantenimientoController.fotosListo
                                    ? Colors.green.withOpacity(0.2)
                                    : Colors.orange.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: mantenimientoController.fotosListo
                                      ? Colors.green
                                      : Colors.orange,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    mantenimientoController.fotosListo
                                        ? Icons.photo_camera
                                        : Icons.camera_alt_outlined,
                                    color: mantenimientoController.fotosListo
                                        ? Colors.green
                                        : Colors.orange,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Fotos: ${mantenimientoController.estadoFotos}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                mantenimientoController
                                                    .fotosListo
                                                ? Colors.green.shade800
                                                : Colors.orange.shade800,
                                            fontSize: 12,
                                          ),
                                        ),
                                        if (!mantenimientoController.fotosListo)
                                          const Text(
                                            'Inicializando servicio de fotos...',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  if (!mantenimientoController.fotosListo)
                                    ElevatedButton(
                                      onPressed: () async {
                                        final exito =
                                            await mantenimientoController
                                                .forzarInicializacionFotos();
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                exito
                                                    ? '✅ Fotos listas'
                                                    : '❌ Error iniciando',
                                              ),
                                              backgroundColor: exito
                                                  ? Colors.green
                                                  : Colors.red,
                                              duration: const Duration(
                                                seconds: 2,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                      ),
                                      child: const Text(
                                        'Reintentar',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),*/
                            ChecklistMantenimientoWidget(
                              onChecklistChanged: (checklist) {
                                mantenimientoController.actualizarChecklist(
                                  checklist,
                                );
                              },
                            ),

                            const Text(
                              'Fotos del vehículo',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Indicador de fotos capturadas
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _fotosCapturadas.isNotEmpty
                                    ? AppColors.exito.withOpacity(0.2)
                                    : Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: _fotosCapturadas.isNotEmpty
                                      ? AppColors.exito
                                      : Colors.white.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.photo_camera,
                                    size: 16,
                                    color: _fotosCapturadas.isNotEmpty
                                        ? AppColors.exito
                                        : Colors.white60,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${_fotosCapturadas.length} foto(s) capturada(s)',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _fotosCapturadas.isNotEmpty
                                          ? AppColors.exito
                                          : Colors.white60,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CameraWidget(
                                  vehiculoId: widget.vehiculoId,
                                  tipoFoto: 'frontal',
                                  onFotoCapturada: (File? foto) {
                                    setState(() {
                                      if (foto != null) {
                                        _fotosCapturadas['frontal'] = foto;
                                        print('📸 Foto frontal capturada');
                                      } else {
                                        _fotosCapturadas.remove('frontal');
                                        print('🗑️ Foto frontal eliminada');
                                      }
                                    });
                                  },
                                ),
                                CameraWidget(
                                  vehiculoId: widget.vehiculoId,
                                  tipoFoto: 'lateral',
                                  onFotoCapturada: (File? foto) {
                                    setState(() {
                                      if (foto != null) {
                                        _fotosCapturadas['lateral'] = foto;
                                        print('📸 Foto lateral capturada');
                                      } else {
                                        _fotosCapturadas.remove('lateral');
                                        print('🗑️ Foto lateral eliminada');
                                      }
                                    });
                                  },
                                ),
                                CameraWidget(
                                  vehiculoId: widget.vehiculoId,
                                  tipoFoto: 'interior',
                                  onFotoCapturada: (File? foto) {
                                    setState(() {
                                      if (foto != null) {
                                        _fotosCapturadas['interior'] = foto;
                                        print('📸 Foto interior capturada');
                                      } else {
                                        _fotosCapturadas.remove('interior');
                                        print('🗑️ Foto interior eliminada');
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),

                            const Text(
                              'OBSERVACIONES',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),

                            CustomWidgets.buildMultilineTextField(
                              'Escriba el problema...',
                              controller: _observacionesController,
                            ),
                            const SizedBox(height: 20),

                            Center(
                              child: ElevatedButton(
                                onPressed: () async {
                                  try {
                                    await mantenimientoController
                                        .guardarMantenimientoConFotos(
                                          widget.vehiculoId,
                                          fotosCapturadas: _fotosCapturadas,
                                          observacionAdicional:
                                              _observacionesController.text
                                                  .trim(),
                                        );
                                    if (mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Mantenimiento guardado exitosamente${_fotosCapturadas.isNotEmpty ? " con ${_fotosCapturadas.length} foto(s)" : ""}',
                                          ),
                                          backgroundColor: AppColors.exito,
                                        ),
                                      );
                                      Navigator.pop(context);
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text('Error al guardar: $e'),
                                          backgroundColor: AppColors.error,
                                        ),
                                      );
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    120,
                                    198,
                                    163,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 16,
                                  ),
                                ),
                                child: const Text(
                                  "Guardar Mantenimiento",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
