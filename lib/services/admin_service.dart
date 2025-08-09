import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Verificar si el usuario actual es administrador
  Future<bool> esAdministrador() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    return user.email == 'taller@espe.edu.ec';
  }

  // Crear nuevo usuario (solo admin)
  Future<String> crearUsuario({
    required String nombre,
    required String email,
    required String telefono,
    required String rol, // 'recepcionista' o 'mecanico'
    required String password,
  }) async {
    try {
      // Verificar que el usuario actual es admin
      if (!await esAdministrador()) {
        throw Exception('Solo el administrador puede crear usuarios');
      }

      // Crear usuario en Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      // Guardar información del usuario en Firestore
      await _db.collection('usuarios').doc(uid).set({
        'nombre': nombre,
        'email': email,
        'telefono': telefono,
        'rol': rol,
        'activo': true,
        'fechaCreacion': DateTime.now().toIso8601String(),
        'creadoPor': _auth.currentUser!.uid,
      });

      return uid;
    } catch (e) {
      throw Exception('Error creando usuario: $e');
    }
  }

  // Obtener todos los usuarios
  Future<List<Map<String, dynamic>>> obtenerUsuarios() async {
    try {
      if (!await esAdministrador()) {
        throw Exception('Solo el administrador puede ver usuarios');
      }

      final snapshot = await _db.collection('usuarios').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Error obteniendo usuarios: $e');
    }
  }

  // Actualizar estado de usuario (activar/desactivar)
  Future<void> actualizarEstadoUsuario(String uid, bool activo) async {
    try {
      if (!await esAdministrador()) {
        throw Exception('Solo el administrador puede modificar usuarios');
      }

      await _db.collection('usuarios').doc(uid).update({
        'activo': activo,
        'modificadoPor': _auth.currentUser!.uid,
        'fechaModificacion': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Error actualizando usuario: $e');
    }
  }

  // Obtener estadísticas del taller
  Future<Map<String, dynamic>> obtenerEstadisticas() async {
    try {
      if (!await esAdministrador()) {
        throw Exception('Solo el administrador puede ver estadísticas');
      }

      // Obtener conteos
      final vehiculos = await _db.collection('vehiculos').get();
      final clientes = await _db.collection('clientes').get();
      final mantenimientos = await _db.collection('mantenimientos').get();
      final usuarios = await _db.collection('usuarios').get();

      // Mantenimientos por estado
      final mantenimientosPendientes = mantenimientos.docs
          .where((doc) => doc.data()['estado'] == 'pendiente')
          .length;
      final mantenimientosEnProceso = mantenimientos.docs
          .where((doc) => doc.data()['estado'] == 'en_proceso')
          .length;
      final mantenimientosCompletados = mantenimientos.docs
          .where((doc) => doc.data()['estado'] == 'completado')
          .length;

      // Usuarios por rol
      final recepcionistas = usuarios.docs
          .where((doc) => doc.data()['rol'] == 'recepcionista')
          .length;
      final mecanicos = usuarios.docs
          .where((doc) => doc.data()['rol'] == 'mecanico')
          .length;

      return {
        'totalVehiculos': vehiculos.size,
        'totalClientes': clientes.size,
        'totalMantenimientos': mantenimientos.size,
        'totalUsuarios': usuarios.size,
        'mantenimientos': {
          'pendientes': mantenimientosPendientes,
          'enProceso': mantenimientosEnProceso,
          'completados': mantenimientosCompletados,
        },
        'usuarios': {'recepcionistas': recepcionistas, 'mecanicos': mecanicos},
      };
    } catch (e) {
      throw Exception('Error obteniendo estadísticas: $e');
    }
  }

  // Obtener rol del usuario actual
  Future<String?> obtenerRolUsuario() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      // Si es el admin
      if (user.email == 'taller@espe.edu.ec') {
        return 'admin';
      }

      // Buscar en la colección de usuarios
      final doc = await _db.collection('usuarios').doc(user.uid).get();
      if (doc.exists) {
        return doc.data()?['rol'];
      }

      return null;
    } catch (e) {
      print('Error obteniendo rol: $e');
      return null;
    }
  }
}
