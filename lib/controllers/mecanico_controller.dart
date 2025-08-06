import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vehiculo_model.dart';

class MecanicoController extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<Vehiculo> _vehiculos = [];
  List<Vehiculo> _vehiculosFiltrados = [];
  Map<String, dynamic> _mantenimientos = {};
  bool _cargando = false;
  String _filtroActual = '';
  String? _error;

  // Getters
  List<Vehiculo> get vehiculos => _vehiculos;
  List<Vehiculo> get vehiculosFiltrados => _vehiculosFiltrados;
  Map<String, dynamic> get mantenimientos => _mantenimientos;
  bool get cargando => _cargando;
  String get filtroActual => _filtroActual;
  String? get error => _error;

  /// Carga todos los vehículos que tienen mantenimientos asignados
  Future<void> cargarVehiculosMantenimiento() async {
    try {
      _cargando = true;
      _error = null;
      notifyListeners();

      // 1. Cargar todos los mantenimientos activos
      final mantenimientosQuery = await _db
          .collection('mantenimientos')
          .where('estado', whereIn: ['pendiente', 'en_proceso', 'completado'])
          .orderBy('fechaCreacion', descending: true)
          .get();

      _mantenimientos.clear();
      Set<String> vehiculosIds = {};

      for (var doc in mantenimientosQuery.docs) {
        final data = doc.data();
        final vehiculoId = data['vehiculoId'] as String?;

        if (vehiculoId != null) {
          _mantenimientos[vehiculoId] = {'id': doc.id, ...data};
          vehiculosIds.add(vehiculoId);
        }
      }

      // 2. Cargar información de los vehículos
      _vehiculos.clear();

      if (vehiculosIds.isNotEmpty) {
        // Firebase tiene límite de 10 elementos en whereIn, procesamos en chunks
        final chunks = _chunkList(vehiculosIds.toList(), 10);

        for (var chunk in chunks) {
          final vehiculosQuery = await _db
              .collection('vehiculos')
              .where(FieldPath.documentId, whereIn: chunk)
              .get();

          for (var doc in vehiculosQuery.docs) {
            try {
              final vehiculo = Vehiculo.fromMap(doc.id, doc.data());
              _vehiculos.add(vehiculo);
            } catch (e) {
              debugPrint('Error al crear vehículo ${doc.id}: $e');
            }
          }
        }
      }

      // 3. Ordenar por prioridad de mantenimiento
      _vehiculos.sort((a, b) {
        final mantA = _mantenimientos[a.id];
        final mantB = _mantenimientos[b.id];

        if (mantA == null && mantB == null) return 0;
        if (mantA == null) return 1;
        if (mantB == null) return -1;

        // Orden: pendiente -> en_proceso -> completado
        final prioridadA = _obtenerPrioridadEstado(mantA['estado']);
        final prioridadB = _obtenerPrioridadEstado(mantB['estado']);

        if (prioridadA != prioridadB) {
          return prioridadA.compareTo(prioridadB);
        }

        // Si tienen el mismo estado, ordenar por fecha de creación
        final fechaA = mantA['fechaCreacion'] as Timestamp?;
        final fechaB = mantB['fechaCreacion'] as Timestamp?;

        if (fechaA != null && fechaB != null) {
          return fechaA.compareTo(fechaB);
        }

        return 0;
      });

      _vehiculosFiltrados = List.from(_vehiculos);

      debugPrint(
        '✅ Cargados ${_vehiculos.length} vehículos con mantenimientos',
      );
    } catch (e) {
      _error = 'Error al cargar vehículos: $e';
      debugPrint('❌ Error en cargarVehiculosMantenimiento: $e');
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  /// Divide una lista en chunks de tamaño específico
  List<List<T>> _chunkList<T>(List<T> list, int chunkSize) {
    List<List<T>> chunks = [];
    for (int i = 0; i < list.length; i += chunkSize) {
      chunks.add(
        list.sublist(
          i,
          (i + chunkSize < list.length) ? i + chunkSize : list.length,
        ),
      );
    }
    return chunks;
  }

  /// Obtiene la prioridad numérica de un estado para ordenamiento
  int _obtenerPrioridadEstado(String? estado) {
    switch (estado) {
      case 'pendiente':
        return 1;
      case 'en_proceso':
        return 2;
      case 'completado':
        return 3;
      default:
        return 4;
    }
  }

  /// Filtra vehículos por texto de búsqueda
  void filtrarVehiculos(String filtro) {
    _filtroActual = filtro.toLowerCase();

    if (_filtroActual.isEmpty) {
      _vehiculosFiltrados = List.from(_vehiculos);
    } else {
      _vehiculosFiltrados = _vehiculos.where((vehiculo) {
        return vehiculo.placa.toLowerCase().contains(_filtroActual) ||
            vehiculo.marca.toLowerCase().contains(_filtroActual) ||
            vehiculo.modelo.toLowerCase().contains(_filtroActual) ||
            vehiculo.nombreCliente.toLowerCase().contains(_filtroActual);
      }).toList();
    }

    notifyListeners();
  }

  /// Obtiene el mantenimiento actual de un vehículo
  dynamic obtenerMantenimientoVehiculo(String vehiculoId) {
    return _mantenimientos[vehiculoId];
  }

  /// Obtiene estadísticas de mantenimientos
  Map<String, int> obtenerEstadisticas() {
    final stats = {'pendientes': 0, 'enProceso': 0, 'completados': 0};

    for (var mantenimiento in _mantenimientos.values) {
      switch (mantenimiento['estado']) {
        case 'pendiente':
          stats['pendientes'] = (stats['pendientes'] ?? 0) + 1;
          break;
        case 'en_proceso':
          stats['enProceso'] = (stats['enProceso'] ?? 0) + 1;
          break;
        case 'completado':
          stats['completados'] = (stats['completados'] ?? 0) + 1;
          break;
      }
    }

    return stats;
  }

  /// Actualiza el estado de un mantenimiento
  Future<bool> actualizarEstadoMantenimiento(
    String vehiculoId,
    String nuevoEstado,
  ) async {
    try {
      final mantenimiento = _mantenimientos[vehiculoId];
      if (mantenimiento == null) return false;

      await _db.collection('mantenimientos').doc(mantenimiento['id']).update({
        'estado': nuevoEstado,
        'fechaActualizacion': FieldValue.serverTimestamp(),
      });

      // Actualizar estado local
      _mantenimientos[vehiculoId]['estado'] = nuevoEstado;

      // Reordenar lista si es necesario
      _vehiculos.sort((a, b) {
        final mantA = _mantenimientos[a.id];
        final mantB = _mantenimientos[b.id];

        if (mantA == null && mantB == null) return 0;
        if (mantA == null) return 1;
        if (mantB == null) return -1;

        final prioridadA = _obtenerPrioridadEstado(mantA['estado']);
        final prioridadB = _obtenerPrioridadEstado(mantB['estado']);

        return prioridadA.compareTo(prioridadB);
      });

      // Actualizar filtro
      filtrarVehiculos(_filtroActual);

      debugPrint('✅ Estado actualizado: $vehiculoId -> $nuevoEstado');
      return true;
    } catch (e) {
      debugPrint('❌ Error al actualizar estado: $e');
      return false;
    }
  }

  /// Refresca todos los datos
  Future<void> refrescar() async {
    await cargarVehiculosMantenimiento();
    filtrarVehiculos(_filtroActual);
  }

  /// Limpia el error
  void limpiarError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    // Limpiar recursos si es necesario
    super.dispose();
  }
}
