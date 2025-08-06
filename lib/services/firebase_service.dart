import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cliente_model.dart';
import '../models/vehiculo_model.dart';
import '../constants/estados_vehiculo.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  FirebaseFirestore get firestore => _db;

  Future<void> registrarVehiculo(Vehiculo vehiculo) async {
    await _db.collection('vehiculos').add(vehiculo.toMap());
  }

  Future<List<Vehiculo>> obtenerVehiculosPorCliente(String clienteId) async {
    final snapshot = await _db
        .collection('vehiculos')
        .where('clienteId', isEqualTo: clienteId)
        .get();

    return snapshot.docs
        .map((doc) => Vehiculo.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<void> eliminarVehiculo(String vehiculoId) async {
    await _db.collection('vehiculos').doc(vehiculoId).delete();
  }

  Future<Cliente?> buscarClientePorCedula(String cedula) async {
    final snapshot = await _db
        .collection('clientes')
        .where('cedula', isEqualTo: cedula)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final doc = snapshot.docs.first;
      return Cliente.fromMap(doc.id, doc.data());
    }
    return null;
  }

  Future<void> registrarCliente(Cliente cliente) async {
    await _db.collection('clientes').add(cliente.toMap());
  }

  Future<String> registrarMantenimiento(
    Map<String, dynamic> mantenimiento,
  ) async {
    try {
      final vehiculoId = mantenimiento['vehiculoId'] as String;
      
      // ✅ Guardar mantenimiento
      final docRef = await _db.collection('mantenimientos').add(mantenimiento);
      
      // ✅ Actualizar estado del vehículo usando las constantes
      String nuevoEstado;
      switch (mantenimiento['estado']) {
        case 'pendiente':
          nuevoEstado = EstadosVehiculo.enMantenimiento;
          break;
        case 'en_proceso':
          nuevoEstado = EstadosVehiculo.enProceso;
          break;
        case 'completado':
          nuevoEstado = EstadosVehiculo.mantenimientoCompletado;
          break;
        default:
          nuevoEstado = EstadosVehiculo.enMantenimiento;
      }
      
      // Actualizar estado del vehículo
      await _db.collection('vehiculos').doc(vehiculoId).update({
        'estado': nuevoEstado,
      });
      
      return docRef.id;
      
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }
}