import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cliente_model.dart';
import '../models/vehiculo_model.dart';

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

  Future<void> registrarMantenimiento(
    Map<String, dynamic> mantenimiento,
  ) async {
    await _db.collection('mantenimientos').add(mantenimiento);
  }
}
