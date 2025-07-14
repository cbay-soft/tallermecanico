import 'package:flutter/material.dart';
import '../models/vehiculo_model.dart';
import '../services/firebase_service.dart';

class VehiculosController with ChangeNotifier {
  final FirebaseService _firebase = FirebaseService();

  List<Vehiculo> todos = [];
  List<Vehiculo> pendientes = [];
  List<Vehiculo> realizados = [];

  Future<void> cargarVehiculos() async {
    final snapshot = await _firebase.firestore.collection('vehiculos'). get();
    final todosVehiculos = snapshot.docs
        .map((doc) => Vehiculo.fromMap(doc.id, doc.data()))
        .toList();

    todos = todosVehiculos;
    pendientes = todosVehiculos.where((v) => v.estado == 'pendiente').toList();
    realizados = todosVehiculos.where((v) => v.estado == 'realizado').toList();
    notifyListeners();
  }
}
