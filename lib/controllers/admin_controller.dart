import 'package:flutter/material.dart';
import '../services/admin_service.dart';

class AdminController with ChangeNotifier {
  final AdminService _adminService = AdminService();

  bool _cargando = false;
  List<Map<String, dynamic>> _usuarios = [];
  Map<String, dynamic> _estadisticas = {};

  bool get cargando => _cargando;
  List<Map<String, dynamic>> get usuarios => _usuarios;
  Map<String, dynamic> get estadisticas => _estadisticas;

  // Verificar si es administrador
  Future<bool> esAdministrador() async {
    return await _adminService.esAdministrador();
  }

  // Crear nuevo usuario
  Future<void> crearUsuario({
    required String nombre,
    required String email,
    required String telefono,
    required String rol,
    required String password,
  }) async {
    _cargando = true;
    notifyListeners();

    try {
      await _adminService.crearUsuario(
        nombre: nombre,
        email: email,
        telefono: telefono,
        rol: rol,
        password: password,
      );

      // Recargar lista de usuarios
      await cargarUsuarios();
    } catch (e) {
      rethrow;
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  // Cargar usuarios
  Future<void> cargarUsuarios() async {
    _cargando = true;
    notifyListeners();

    try {
      _usuarios = await _adminService.obtenerUsuarios();
    } catch (e) {
      print('Error cargando usuarios: $e');
      _usuarios = [];
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  // Cargar estadísticas
  Future<void> cargarEstadisticas() async {
    _cargando = true;
    notifyListeners();

    try {
      _estadisticas = await _adminService.obtenerEstadisticas();
    } catch (e) {
      print('Error cargando estadísticas: $e');
      _estadisticas = {};
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  // Activar/Desactivar usuario
  Future<void> cambiarEstadoUsuario(String uid, bool activo) async {
    try {
      await _adminService.actualizarEstadoUsuario(uid, activo);
      await cargarUsuarios(); // Recargar lista
    } catch (e) {
      rethrow;
    }
  }

  // Obtener rol del usuario actual
  Future<String?> obtenerRolUsuario() async {
    return await _adminService.obtenerRolUsuario();
  }
}
