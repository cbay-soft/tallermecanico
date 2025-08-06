import 'package:flutter/foundation.dart';
import '../services/firebase_service.dart';

class DetalleVehiculoController extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  
  List<dynamic> mantenimientos = [];
  List<String> fotos = [];
  bool cargando = false;

  Future<void> cargarDetalle(String vehiculoId, String? mantenimientoId) async {
    cargando = true;
    notifyListeners();

    try {
      final mantenimientosQuery = await _firebaseService.firestore
          .collection('mantenimientos')
          .where('vehiculoId', isEqualTo: vehiculoId)
          .orderBy('fecha', descending: true)
          .get();

      mantenimientos = mantenimientosQuery.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();

      if (mantenimientos.isNotEmpty) {
        final ultimo = mantenimientos.first;
        final fotosData = ultimo['fotos'] as Map<String, dynamic>?;
        if (fotosData != null) {
          fotos = fotosData.values.whereType<String>().toList();
        }
      }
    } catch (e) {
      print('Error: $e');
    }

    cargando = false;
    notifyListeners();
  }
}