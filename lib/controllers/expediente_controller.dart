import 'package:flutter/foundation.dart';
import '../models/cliente_model.dart';
import '../models/vehiculo_model.dart';
import '../services/firebase_service.dart';

class ExpedienteController extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  // ✅ VARIABLES PRINCIPALES
  Cliente? cliente;
  Vehiculo? vehiculo; // ✅ AGREGAR esta variable que faltaba
  List<Vehiculo> vehiculos = [];
  List<dynamic> mantenimientos = []; // ✅ AGREGAR esta variable que faltaba
  bool cargando = false;

  Future<void> cargarExpediente(String vehiculoId) async {
    cargando = true;
    notifyListeners();

    try {
      print('🔍 Cargando expediente para vehículo: $vehiculoId'); // Debug

      // ✅ Cargar vehículo primero
      final vehiculoDoc = await _firebaseService.firestore
          .collection('vehiculos')
          .doc(vehiculoId)
          .get();

      if (vehiculoDoc.exists) {
        vehiculo = Vehiculo.fromMap(vehiculoDoc.id, vehiculoDoc.data()!);
        print('✅ Vehículo cargado: ${vehiculo!.placa}'); // Debug

        // ✅ Cargar cliente usando el clienteId del vehículo
        final clienteDoc = await _firebaseService.firestore
            .collection('clientes')
            .doc(vehiculo!.clienteId)
            .get();

        if (clienteDoc.exists) {
          cliente = Cliente.fromMap(clienteDoc.id, clienteDoc.data()!);
          print('✅ Cliente cargado: ${cliente!.nombre}'); // Debug
        }

        // ✅ Cargar TODOS los vehículos del cliente
        final vehiculosQuery = await _firebaseService.firestore
            .collection('vehiculos')
            .where('clienteId', isEqualTo: vehiculo!.clienteId)
            .get();

        vehiculos = vehiculosQuery.docs
            .map((doc) => Vehiculo.fromMap(doc.id, doc.data()))
            .toList();

        print('✅ Vehículos del cliente: ${vehiculos.length}'); // Debug

        // ✅ Cargar mantenimientos para TODOS los vehículos del cliente
        mantenimientos.clear();

        for (final vehiculoItem in vehiculos) {
          print(
            '🔍 Buscando mantenimientos para: ${vehiculoItem.placa}',
          ); // Debug

          final mantenimientosQuery = await _firebaseService.firestore
              .collection('mantenimientos')
              .where('vehiculoId', isEqualTo: vehiculoItem.id)
              .get(); // Sin orderBy por ahora

          final mantenimientosVehiculo = mantenimientosQuery.docs
              .map((doc) => {'id': doc.id, ...doc.data()})
              .toList();

          print(
            '📝 Mantenimientos encontrados para ${vehiculoItem.placa}: ${mantenimientosVehiculo.length}',
          ); // Debug
          mantenimientos.addAll(mantenimientosVehiculo);
        }

        // ✅ Ordenar todos los mantenimientos por fecha (si existe)
        mantenimientos.sort((a, b) {
          try {
            final fechaA = a['fecha'] != null
                ? DateTime.parse(a['fecha'])
                : DateTime(1900);
            final fechaB = b['fecha'] != null
                ? DateTime.parse(b['fecha'])
                : DateTime(1900);
            return fechaB.compareTo(fechaA);
          } catch (e) {
            print('⚠️ Error ordenando por fecha: $e');
            return 0;
          }
        });

        print(
          '✅ Total mantenimientos cargados: ${mantenimientos.length}',
        ); // Debug
      } else {
        print('❌ No se encontró el vehículo con ID: $vehiculoId'); // Debug
      }
    } catch (e) {
      print('❌ Error cargando expediente: $e');
    }

    cargando = false;
    notifyListeners();
  }

  // ✅ MÉTODO ÚNICO para obtener mantenimientos de un vehículo específico
  List<dynamic> getMantenimientosVehiculo(String vehiculoId) {
    final resultado = mantenimientos
        .where((mantenimiento) => mantenimiento['vehiculoId'] == vehiculoId)
        .toList();

    print(
      '🔍 Mantenimientos para vehículo $vehiculoId: ${resultado.length}',
    ); // Debug
    return resultado;
  }
}
