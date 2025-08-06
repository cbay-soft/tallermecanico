import 'package:flutter/material.dart';
import '../models/cliente_model.dart';
import '../models/vehiculo_model.dart';
import '../services/firebase_service.dart';
import '../constants/estados_vehiculo.dart';

class RecepcionController extends ChangeNotifier {
  // 👈 OBLIGATORIO extender ChangeNotifier
  final cedulaController = TextEditingController();
  final nombreController = TextEditingController();
  final correoController = TextEditingController();
  final telefonoController = TextEditingController();
  final kilometrajeController = TextEditingController();
  final placaController = TextEditingController();
  final anioController = TextEditingController();
  final marcaController = TextEditingController();
  final modeloController = TextEditingController();

  final FirebaseService servicio = FirebaseService();

  // ✅ AGREGAR esta nueva variable
  bool _seHaBuscado = false;
  bool get seHaBuscado => _seHaBuscado;

  bool buscando = false;
  bool mostrarFormularioVehiculo = false;

  // ✅ Nueva propiedad para controlar cuándo ocultar teclado
  bool _debeOcultarTeclado = false;
  bool get debeOcultarTeclado => _debeOcultarTeclado;

  // ✅ Agregar variable para controlar modales
  bool _modalAbierto = false;
  bool get modalAbierto => _modalAbierto;

  Cliente? clienteEncontrado;
  List<Vehiculo> vehiculosCliente = [];

  Future<void> buscarCliente() async {
    clienteEncontrado = null;
    buscando = true;
    mostrarFormularioVehiculo = false;
    vehiculosCliente.clear();
    _seHaBuscado = true; // Marcar que se ha buscado
    notifyListeners();

    final cliente = await servicio.buscarClientePorCedula(
      cedulaController.text.trim(),
    );
    clienteEncontrado = cliente;

    if (cliente != null) {
      nombreController.text = cliente.nombre.toUpperCase();
      telefonoController.text = cliente.telefono;
      correoController.text = cliente.correo;
      _debeOcultarTeclado = true; // Ocultar teclado si se encuentra el cliente
      await cargarVehiculos();
    } else {
      nombreController.clear();
      telefonoController.clear();
      correoController.clear();
    }

    buscando = false;
    notifyListeners();
  }

  // ✅ AGREGAR método para reset cuando se cambia la cédula
  void resetearBusqueda() {
    _seHaBuscado = false;
    clienteEncontrado = null;
    vehiculosCliente.clear();
    notifyListeners();
  }

  // Método para confirmar que el teclado fue ocultado
  void tecladoOcultado() {
    _debeOcultarTeclado = false;
  }

  // Método para confirmar si el modal está abierto
  void setModalAbierto(bool abierto) {
    _modalAbierto = abierto;

    if (!abierto) {
      // Si el modal se cierra, ocultar teclado
      _debeOcultarTeclado = true;
    }

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

  Future<void> guardarVehiculo(
    BuildContext context,
    TextEditingController marcaController,
    TextEditingController modeloController,
    TextEditingController anioController,
    TextEditingController placaController,
    TextEditingController kilometrajeController,
  ) async {
    if (clienteEncontrado == null) return;

    final nuevo = Vehiculo(
      id: '',
      clienteId: clienteEncontrado!.id,
      nombreCliente: clienteEncontrado!.nombre,
      placa: placaController.text.trim(),
      marca: marcaController.text.trim(),
      modelo: modeloController.text.trim(),
      anio: anioController.text.trim(),
      kilometraje: '0', // Asignar un valor por defecto
      estado: EstadosVehiculo.ingresado,
    );
    await servicio.registrarVehiculo(nuevo);
    placaController.clear();
    marcaController.clear();
    anioController.clear();
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
