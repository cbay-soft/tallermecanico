import 'package:flutter/material.dart';
import '../models/vehiculo_model.dart';
import '../services/firebase_service.dart';

class VehiculosController with ChangeNotifier {
  final FirebaseService _firebase = FirebaseService();

  // Listas base (como las tienes)
  List<Vehiculo> todos = [];
  List<Vehiculo> ingresados = [];
  List<Vehiculo> pendientes = [];
  List<Vehiculo> realizados = [];
  
  // Agrega la lista actual que se muestra en la UI
  List<Vehiculo> _vehiculosActuales = [];
  List<Vehiculo> get vehiculosActuales => _vehiculosActuales;
  
  // Agrega el estado de carga
  bool _cargando = false;
  bool get cargando => _cargando;
  
  // Agrega el término de búsqueda actual
  String _terminoBusqueda = '';

  // Método actual
  Future<void> cargarVehiculos() async {
    _cargando = true;
    notifyListeners();
    
    try {
      final snapshot = await _firebase.firestore.collection('vehiculos').get();
      final todosVehiculos = snapshot.docs
          .map((doc) => Vehiculo.fromMap(doc.id, doc.data()))
          .toList();
      
      todos = todosVehiculos;
      ingresados = todosVehiculos.where((v) => v.estado == 'ingresado').toList();
      pendientes = todosVehiculos.where((v) => v.estado == 'pendiente').toList();
      realizados = todosVehiculos.where((v) => v.estado == 'realizado').toList();
      
      // Inicializa todos los vehículos
      _vehiculosActuales = List.from(todos);
      
      print('✅ Cargados: ${todos.length} vehículos total');
      print('📋 Pendientes: ${pendientes.length}');
      print('✅ Realizados: ${realizados.length}');
      
    } catch (e) {
      print('❌ Error al cargar vehículos: $e');
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  // AGREGAR: Métodos que necesita el screen
  void mostrarTodos() {
    _vehiculosActuales = _aplicarFiltro(todos);
    notifyListeners();
  }

  void mostrarIngresados() {
    _vehiculosActuales = _aplicarFiltro(ingresados);
    notifyListeners();
  }

  void mostrarPendientes() {
    _vehiculosActuales = _aplicarFiltro(pendientes);
    notifyListeners();
  }

  void mostrarRealizados() {
    _vehiculosActuales = _aplicarFiltro(realizados);
    notifyListeners();
  }

  // AGREGAR: Filtrar vehículos por texto
  void filtrarVehiculos(String termino) {
    _terminoBusqueda = termino.toLowerCase();
    
    // Determinar qué lista usar como base
    List<Vehiculo> listaBase;
    if (_vehiculosActuales.isEmpty || _vehiculosActuales.length == todos.length) {
      listaBase = todos;
    } else if (_vehiculosActuales.length == pendientes.length) {
      listaBase = pendientes;
    } else if (_vehiculosActuales.length == ingresados.length) {
      listaBase = ingresados;
    } else {
      listaBase = realizados;
    }
    
    _vehiculosActuales = _aplicarFiltro(listaBase);
    notifyListeners();
  }

  // Aplicar filtro de búsqueda a una lista
  List<Vehiculo> _aplicarFiltro(List<Vehiculo> lista) {
    if (_terminoBusqueda.isEmpty) {
      return List.from(lista);
    }
    
    return lista.where((vehiculo) {
      return vehiculo.placa.toLowerCase().contains(_terminoBusqueda) ||
             vehiculo.marca.toLowerCase().contains(_terminoBusqueda) ||
             vehiculo.modelo.toLowerCase().contains(_terminoBusqueda) ||
             vehiculo.nombreCliente.toLowerCase().contains(_terminoBusqueda);
    }).toList();
  }

  // Limpia los filtros
  void limpiarFiltros() {
    _terminoBusqueda = '';
    _vehiculosActuales = List.from(todos);
    notifyListeners();
  }

  // Refresca datos
  Future<void> refrescar() async {
    await cargarVehiculos();
  }

  // Busca vehículo por ID
  Vehiculo? buscarVehiculoPorId(String id) {
    try {
      return todos.firstWhere((v) => v.id == id);
    } catch (e) {
      return null;
    }
  }
}