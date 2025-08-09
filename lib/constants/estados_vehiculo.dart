import 'package:flutter/material.dart'; // Import faltante para Colors

class EstadosVehiculo {
  static const String ingresado = 'ingresado';
  static const String enMantenimiento = 'en_mantenimiento';
  static const String enProceso = 'en_proceso';
  static const String mantenimientoCompletado = 'mantenimiento_completado';
  static const String listo = 'listo_para_entrega';
  static const String entregado = 'entregado';
  
  // Estados que usas en otros lugares
  static const String pendiente = 'pendiente';
  static const String realizado = 'realizado';
  static const String completado = 'completado';

  static const List<String> todosLosEstados = [
    ingresado,
    pendiente,
    enMantenimiento,
    enProceso,
    realizado,
    completado,
    mantenimientoCompletado,
    listo,
    entregado,
  ];

  static String obtenerTextoEstado(String estado) {
    switch (estado) {
      case ingresado:
        return 'Ingresado';
      case pendiente:
        return 'Pendiente';
      case enMantenimiento:
        return 'En Mantenimiento';
      case enProceso:
        return 'En Proceso';
      case realizado:
        return 'Realizado';
      case completado:
        return 'Completado';
      case mantenimientoCompletado:
        return 'Mantenimiento Completado';
      case listo:
        return 'Listo para Entrega';
      case entregado:
        return 'Entregado';
      default:
        return 'Estado Desconocido';
    }
  }

  static Color obtenerColorEstado(String estado) {
    switch (estado) {
      case ingresado:
        return Colors.blue;
      case pendiente:
        return Colors.orange;
      case enMantenimiento:
        return Colors.amber;
      case enProceso:
        return Colors.deepOrange;
      case realizado:
      case completado:
      case mantenimientoCompletado:
        return Colors.green;
      case listo:
        return Colors.teal;
      case entregado:
        return Colors.grey;
      default:
        return Colors.black;
    }
  }
}