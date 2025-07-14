import 'package:flutter/material.dart';
import '../models/cliente_model.dart';
import '../models/vehiculo_model.dart';
import '../services/firebase_service.dart';

class RecepcionController extends ChangeNotifier {
  // 👈 OBLIGATORIO extender ChangeNotifier
  final cedulaController = TextEditingController();
  final nombreController = TextEditingController();
  final correoController = TextEditingController();
  final telefonoController = TextEditingController();

  final placaController = TextEditingController();
  final marcaController = TextEditingController();
  final modeloController = TextEditingController();

  final FirebaseService servicio = FirebaseService();
  

  bool buscando = false;
  bool mostrarFormularioVehiculo = false;

  Cliente? clienteEncontrado;
  List<Vehiculo> vehiculosCliente = [];

  Future<void> buscarCliente() async {
    clienteEncontrado = null;
    buscando = true;
    mostrarFormularioVehiculo = false;
    vehiculosCliente.clear();
    notifyListeners();

    final cliente = await servicio.buscarClientePorCedula(
      cedulaController.text.trim(),
    );
    clienteEncontrado = cliente;

    if (cliente != null) {
      nombreController.text = cliente.nombre;
      telefonoController.text = cliente.telefono;
      correoController.text = cliente.correo;
      await cargarVehiculos();
    } else {
      nombreController.clear();
      telefonoController.clear();
      correoController.clear();
    }

    buscando = false;
    notifyListeners();
  }

  Future<void> cargarVehiculos() async {
    if (clienteEncontrado != null) {
      vehiculosCliente = await servicio.obtenerVehiculosPorCliente(
        clienteEncontrado!.id,
      );
      notifyListeners();
    }
  }

  Future<void> registrarClienteNuevo(VoidCallback onSuccess) async {
    final nuevo = Cliente(
      id: '',
      nombre: nombreController.text.trim(),
      cedula: cedulaController.text.trim(),
      correo: correoController.text.trim(),
      telefono: telefonoController.text.trim(),
    );
    await servicio.registrarCliente(nuevo);
    onSuccess();
    await buscarCliente();
  }

  Future<void> guardarVehiculo() async {
    if (clienteEncontrado == null) return;

    final nuevo = Vehiculo(
      id: '',
      clienteId: clienteEncontrado!.id,
      placa: placaController.text.trim(),
      marca: marcaController.text.trim(),
      modelo: modeloController.text.trim(),
      estado: 'pendiente',
    );
    await servicio.registrarVehiculo(nuevo);
    placaController.clear();
    marcaController.clear();
    modeloController.clear();
    await cargarVehiculos();
  }

  Future<void> eliminarVehiculo(String id) async {
    await servicio.eliminarVehiculo(id);
    await cargarVehiculos();
  }

  void toggleFormularioVehiculo() {
    mostrarFormularioVehiculo = !mostrarFormularioVehiculo;
    notifyListeners();
  }
}
