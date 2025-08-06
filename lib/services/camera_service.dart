import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraService {
  static final ImagePicker _picker = ImagePicker();
  
  // Verificar permisos
  static Future<bool> verificarPermisos() async {
    final cameraStatus = await Permission.camera.status;
    final storageStatus = await Permission.storage.status;
    
    if (!cameraStatus.isGranted) {
      final result = await Permission.camera.request();
      if (!result.isGranted) return false;
    }
    
    if (!storageStatus.isGranted) {
      final result = await Permission.storage.request();
      if (!result.isGranted) return false;
    }
    
    return true;
  }
  
  // Tomar foto con cámara
  static Future<File?> tomarFoto() async {
    try {
      if (!await verificarPermisos()) {
        throw Exception('Permisos de cámara no concedidos');
      }
      
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );
      
      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('❌ Error tomando foto: $e');
      rethrow;
    }
  }
  
  // Seleccionar foto de galería
  static Future<File?> seleccionarDeGaleria() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );
      
      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('❌ Error seleccionando foto: $e');
      rethrow;
    }
  }
  
  // Guardar foto en directorio temporal
  static Future<File> guardarFotoTemporal(File foto, String nombreArchivo) async {
    try {
      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/$nombreArchivo';
      return await foto.copy(path);
    } catch (e) {
      print('❌ Error guardando foto temporal: $e');
      rethrow;
    }
  }
}