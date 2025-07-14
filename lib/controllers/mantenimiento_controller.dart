import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class MantenimientoController with ChangeNotifier {
  final List<TextEditingController> observaciones = [];
  final List<String> fotos = [];

  final FirebaseService _service = FirebaseService();

  MantenimientoController() {
    agregarObservacion(); // inicial
  }

  void agregarObservacion() {
    observaciones.add(TextEditingController());
    notifyListeners();
  }

  void eliminarObservacion(int index) {
    observaciones.removeAt(index);
    notifyListeners();
  }

  void agregarFoto(String url) {
    fotos.add(url);
    notifyListeners();
  }

  Future<void> subirFotoMock() async {
    // 🔁 simula que subiste una imagen a Firebase
    agregarFoto("https://fakeurl.com/foto.jpg");
  }

  Future<void> guardarMantenimiento(String vehiculoId) async {
    final data = {
      'vehiculoId': vehiculoId,
      'observaciones':
          observaciones.map((e) => e.text.trim()).where((e) => e.isNotEmpty).toList(),
      'fotos': fotos,
      'fecha': DateTime.now().toIso8601String(),
    };
    await _service.registrarMantenimiento(data);
  }
}
