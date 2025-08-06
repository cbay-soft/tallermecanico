import 'package:flutter/foundation.dart';
import '../services/firebase_service.dart';
import '../models/cliente_model.dart';

class ClientesController extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  
  List<Cliente> _todosLosClientes = [];
  List<Cliente> _clientesFiltrados = [];
  bool _cargando = false;
  String _filtroActual = '';

  // Getters
  List<Cliente> get clientes => _clientesFiltrados;
  bool get cargando => _cargando;
  String get filtroActual => _filtroActual;

  Future<void> cargarClientes() async {
    _cargando = true;
    notifyListeners();

    try {
      final querySnapshot = await _firebaseService.firestore
          .collection('clientes')
          .orderBy('nombre')
          .get();

      _todosLosClientes = querySnapshot.docs
          .map((doc) => Cliente.fromMap(doc.id, doc.data()))
          .toList();

      _clientesFiltrados = List.from(_todosLosClientes);
    } catch (e) {
      print('Error cargando clientes: $e');
    }

    _cargando = false;
    notifyListeners();
  }

  void filtrarClientes(String filtro) {
    _filtroActual = filtro;
    
    if (filtro.isEmpty) {
      _clientesFiltrados = List.from(_todosLosClientes);
    } else {
      _clientesFiltrados = _todosLosClientes.where((cliente) {
        final nombre = cliente.nombre.toLowerCase();
        final cedula = cliente.cedula.toLowerCase();
        final filtroLower = filtro.toLowerCase();
        
        return nombre.contains(filtroLower) || cedula.contains(filtroLower);
      }).toList();
    }
    
    notifyListeners();
  }

  Future<void> refrescar() async {
    await cargarClientes();
  }
}