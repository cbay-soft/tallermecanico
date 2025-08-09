import 'dart:io';
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../services/fotos_service.dart';

class MantenimientoController with ChangeNotifier {
  final List<TextEditingController> observaciones = [];
  final Map<String, String> fotos = {}; // Cambiar a Map para URLs
  final FotosService _fotosService = FotosService();

  final FirebaseService _service = FirebaseService();

  MantenimientoController() {
    agregarObservacion();
    _inicializarFotos();
  }

  // Estado del checklist
  Map<String, Map<String, bool>> _checklist = {};
  Map<String, Map<String, bool>> get checklist => _checklist;

  Future<void> _inicializarFotos() async {
    try {
      print('🚀 === INICIALIZANDO SERVICIO DE FOTOS ===');
      await _fotosService.initialize();
      print('📊 Estado: ${_fotosService.estado}');
      notifyListeners();
    } catch (e) {
      print('⚠️ Error inicializando servicio de fotos: $e');
    }
  }

  void actualizarChecklist(Map<String, dynamic> nuevoChecklist) {
    _checklist = nuevoChecklist.map((key, value) {
      if (value is Map<String, dynamic>) {
        return MapEntry(key, value.cast<String, bool>());
      } else if (value is Map<String, bool>) {
        return MapEntry(key, value);
      } else {
        // Fallback para datos inesperados
        return MapEntry(key, <String, bool>{});
      }
    });

    // Usar PostFrameCallback para evitar setState durante build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Obtener resumen del checklist
  Map<String, dynamic> getResumenChecklist() {
    int completados = 0;
    int total = 0;

    _checklist.forEach((categoria, items) {
      total += items.length;
      completados += items.values.where((v) => v).length;
    });

    return {
      'completados': completados,
      'total': total,
      'porcentaje': total > 0 ? (completados / total * 100).round() : 0,
    };
  }

  void agregarObservacion() {
    observaciones.add(TextEditingController());
    notifyListeners();
  }

  void eliminarObservacion(int index) {
    observaciones.removeAt(index);
    notifyListeners();
  }

  // AGREGAR foto con tipo específico
  void agregarFoto(String tipoFoto, String url) {
    fotos[tipoFoto] = url;
    notifyListeners();
  }

  // OBTENER URL de foto específica
  String? obtenerUrlFoto(String tipoFoto) {
    return fotos[tipoFoto];
  }

  Future<void> guardarMantenimiento(
    String vehiculoId, {
    String? observacionAdicional,
  }) async {
    try {
      print('💾 Iniciando guardado de mantenimiento para $vehiculoId');

      // 📸 CONFIRMAR fotos temporales antes de guardar
      final fotosConfirmadas = await _fotosService.confirmarFotosVehiculo(
        vehiculoId,
      );
      print('📷 Fotos confirmadas: ${fotosConfirmadas.length}');

      // Actualizar el mapa de fotos con las rutas finales
      fotos.addAll(fotosConfirmadas);

      final resumen = getResumenChecklist();

      String estadoMantenimiento;
      if (resumen['porcentaje'] == 0) {
        estadoMantenimiento = 'pendiente';
      } else if (resumen['porcentaje'] == 100) {
        estadoMantenimiento = 'completado';
      } else {
        estadoMantenimiento = 'en_proceso';
      }

      List<String> todasLasObservaciones = observaciones
          .map((e) => e.text.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      // AGREGAR la observación adicional si existe
      if (observacionAdicional != null &&
          observacionAdicional.trim().isNotEmpty) {
        todasLasObservaciones.add(observacionAdicional.trim());
      }

      final data = {
        'vehiculoId': vehiculoId,
        'observaciones': todasLasObservaciones,
        'fotos': fotos, // GUARDAR URLs de fotos confirmadas
        'fecha': DateTime.now().toIso8601String(),
        'checklistPlanificado': _checklist,
        'checklistRealizado': <String, Map<String, bool>>{},
        'resumenChecklist': resumen,
        'estado': estadoMantenimiento,
        'porcentajeCompletado': resumen['porcentaje'],
      };

      final documentoId = await _service.registrarMantenimiento(data);
      print('✅ Mantenimiento guardado con ID: $documentoId');
      print('📷 Fotos incluidas: ${fotos.keys.toList()}');
      print('✅ Mantenimiento planificado con ID: $documentoId');
      print('📸 Fotos guardadas: $fotos');
    } catch (e) {
      print('❌ Error: $e');
      throw Exception('Error al guardar mantenimiento: $e');
    }
  }

  // Nuevo método para guardar mantenimiento con fotos capturadas
  Future<void> guardarMantenimientoConFotos(
    String vehiculoId, {
    Map<String, File>? fotosCapturadas,
    String? observacionAdicional,
  }) async {
    try {
      print(
        '💾 Iniciando guardado de mantenimiento con fotos capturadas para $vehiculoId',
      );

      // 📸 Guardar fotos capturadas en la galería
      Map<String, String> fotosGuardadas = {};
      if (fotosCapturadas != null && fotosCapturadas.isNotEmpty) {
        print(
          '🔄 Iniciando proceso de guardado de ${fotosCapturadas.length} fotos',
        );

        // Verificar que el servicio esté inicializado
        await _fotosService.initialize();

        fotosGuardadas = await _fotosService.guardarFotosMantenimiento(
          fotosCapturadas,
          vehiculoId,
        );
        print(
          '📷 Resultado del guardado: ${fotosGuardadas.length} fotos guardadas',
        );
        print('📂 Rutas guardadas: $fotosGuardadas');
      } else {
        print('📷 No hay fotos para guardar');
      }

      // Actualizar el mapa de fotos con las rutas finales
      fotos.addAll(fotosGuardadas);

      // Obtener resumen del checklist
      final resumen = getResumenChecklist();

      // Determinar estado del mantenimiento basado en el checklist
      String estadoMantenimiento;
      if (resumen['porcentaje'] == 0) {
        estadoMantenimiento = 'pendiente';
      } else if (resumen['porcentaje'] == 100) {
        estadoMantenimiento = 'completado';
      } else {
        estadoMantenimiento = 'en_proceso';
      }

      // Crear lista de observaciones
      List<String> todasLasObservaciones = observaciones
          .map((e) => e.text.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      // Agregar la observación adicional si existe
      if (observacionAdicional != null &&
          observacionAdicional.trim().isNotEmpty) {
        todasLasObservaciones.add(observacionAdicional.trim());
      }

      final data = {
        'vehiculoId': vehiculoId,
        'observaciones': todasLasObservaciones,
        'fotos': fotosGuardadas, // Guardar rutas de fotos en galería
        'fecha': DateTime.now().toIso8601String(),
        'checklistPlanificado': _checklist, // ✅ RESTAURADO: Guardar checklist
        'checklistRealizado': <String, Map<String, bool>>{},
        'resumenChecklist': resumen, // ✅ RESTAURADO: Guardar resumen
        'estado': estadoMantenimiento,
        'porcentajeCompletado':
            resumen['porcentaje'], // ✅ RESTAURADO: Guardar porcentaje
        'fechaCompletado': estadoMantenimiento == 'completado'
            ? DateTime.now().toIso8601String()
            : null,
      };

      final documentoId = await _service.registrarMantenimiento(data);

      print('✅ Mantenimiento guardado con ID: $documentoId');
      print('📷 Fotos incluidas: ${fotosGuardadas.keys.toList()}');
      print('📋 Checklist incluido: ${_checklist.keys.toList()}');
      print('📊 Porcentaje completado: ${resumen['porcentaje']}%');
    } catch (e) {
      print('❌ Error: $e');
      throw Exception('Error al guardar mantenimiento: $e');
    }
  }

  @override
  void dispose() {
    for (var controller in observaciones) {
      controller.dispose();
    }
    super.dispose();
  }

  // Método para forzar inicialización del servicio de fotos
  Future<bool> forzarInicializacionFotos() async {
    try {
      await _fotosService.initialize();
      notifyListeners();
      return _fotosService.estaListo;
    } catch (e) {
      print('❌ Error forzando inicialización: $e');
      return false;
    }
  }

  // Verificar estado del servicio de fotos
  bool get fotosListo => _fotosService.estaListo;
  String get estadoFotos => _fotosService.estado;

  // 🗑️ Cancelar fotos temporales
  void cancelarFotosTemporales(String vehiculoId) {
    _fotosService.cancelarFotosTemporales(vehiculoId);
    fotos.clear();
    notifyListeners();
  }
}
