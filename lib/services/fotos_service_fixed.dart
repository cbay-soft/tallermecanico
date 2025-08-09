import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FotosService {
  // 📁 Carpeta local para guardar fotos
  static const String _carpetaLocal = 'taller_fotos';

  bool _inicializado = false;
  String? _rutaCarpeta;

  // 🧠 Memoria temporal para fotos antes de guardar mantenimiento
  final Map<String, File> _fotosTemporales = {};
  final Map<String, String> _rutasFinales = {};

  FotosService() {
    print('📱 Servicio de fotos configurado para almacenamiento LOCAL');
  }

  Future<void> initialize() async {
    if (_inicializado) return;

    try {
      // Solicitar permisos de almacenamiento
      final permission = await Permission.storage.request();
      if (!permission.isGranted) {
        print('⚠️ Permisos de almacenamiento denegados');
      }

      // Obtener directorio externo base
      final directorioExterno = await getExternalStorageDirectory();
      if (directorioExterno == null) {
        print('❌ No se pudo acceder al almacenamiento externo');
        _inicializado = false;
        return;
      }

      // Crear ruta a la carpeta Pictures pública
      final rutaBase = directorioExterno.path.split('/Android/data/')[0];
      _rutaCarpeta = '$rutaBase/Pictures/$_carpetaLocal';

      // Crear carpeta si no existe
      final carpeta = Directory(_rutaCarpeta!);
      if (!await carpeta.exists()) {
        await carpeta.create(recursive: true);
        print('📁 Carpeta creada en Pictures: $_rutaCarpeta');
      }

      print('✅ Fotos se guardarán en GALERÍA: $_rutaCarpeta');
      _inicializado = true;
    } catch (e) {
      print('❌ Error al crear carpeta pública: $e');
      _inicializado = false;
    }
  }

  bool get estaListo => _inicializado;
  String get estado =>
      _inicializado ? 'Fotos guardándose localmente' : 'No inicializado';

  Future<bool> inicializar() async {
    await initialize();
    return _inicializado;
  }

  // Método simplificado para guardar una foto directamente en la galería
  Future<String?> guardarFotoEnGaleria(
    File foto,
    String vehiculoId,
    String tipoMantenimiento,
  ) async {
    print('🔄 Guardando foto individual: $tipoMantenimiento');

    if (!_inicializado) {
      print('❌ Servicio no inicializado para guardar foto');
      return null;
    }

    try {
      print('📁 Verificando que el archivo existe: ${await foto.exists()}');
      if (!await foto.exists()) {
        print('❌ El archivo de foto no existe');
        return null;
      }

      print('📂 Verificando carpeta destino: $_rutaCarpeta');
      final carpeta = Directory(_rutaCarpeta!);
      if (!await carpeta.exists()) {
        print('📁 Creando carpeta destino...');
        await carpeta.create(recursive: true);
      }

      // Generar nombre único para la foto
      final timeStamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '${tipoMantenimiento}_${vehiculoId}_$timeStamp.jpg';
      final rutaFinal = '$_rutaCarpeta/$fileName';

      print('💾 Copiando foto a: $rutaFinal');

      // Copiar foto a la galería
      final fotoGuardada = await foto.copy(rutaFinal);

      print('✔️ Verificando que se copió correctamente...');
      if (await fotoGuardada.exists()) {
        final tamano = await fotoGuardada.length();
        print(
          '✅ Foto guardada exitosamente en galería: $rutaFinal ($tamano bytes)',
        );
        return rutaFinal;
      } else {
        print('❌ Error: archivo no se guardó correctamente');
        return null;
      }
    } catch (e) {
      print('❌ Error guardando foto en galería: $e');
      print('Stack trace: ${StackTrace.current}');
      return null;
    }
  }

  // Guardar múltiples fotos de un mantenimiento
  Future<Map<String, String>> guardarFotosMantenimiento(
    Map<String, File> fotosTemporales,
    String vehiculoId,
  ) async {
    print('🔥 === INICIANDO GUARDADO DE FOTOS ===');
    print('📱 Fotos recibidas: ${fotosTemporales.length}');
    print('🆔 Vehículo ID: $vehiculoId');
    print('🔍 Servicio inicializado: $_inicializado');
    print('📂 Ruta carpeta: $_rutaCarpeta');

    if (!_inicializado) {
      print('❌ Servicio no inicializado - intentando inicializar...');
      await initialize();
      if (!_inicializado) {
        print('❌ Error: No se pudo inicializar el servicio');
        return {};
      }
    }

    final fotosGuardadas = <String, String>{};

    for (final entry in fotosTemporales.entries) {
      final tipoFoto = entry.key;
      final archivo = entry.value;

      print('📸 Procesando foto: $tipoFoto');
      print('📍 Archivo existe: ${await archivo.exists()}');
      if (await archivo.exists()) {
        print('📏 Tamaño archivo: ${await archivo.length()} bytes');
      }

      final rutaGuardada = await guardarFotoEnGaleria(
        archivo,
        vehiculoId,
        tipoFoto,
      );

      if (rutaGuardada != null) {
        fotosGuardadas[tipoFoto] = rutaGuardada;
        print('✅ $tipoFoto guardada exitosamente');
      } else {
        print('❌ Error guardando $tipoFoto');
      }
    }

    print(
      '🎉 RESULTADO: ${fotosGuardadas.length}/${fotosTemporales.length} fotos guardadas',
    );
    print('📋 Fotos guardadas: ${fotosGuardadas.keys.toList()}');
    return fotosGuardadas;
  }

  // Método para confirmar y guardar todas las fotos del vehículo
  Future<Map<String, String>> confirmarFotosVehiculo(String vehiculoId) async {
    final fotosGuardadas = <String, String>{};

    try {
      print('💾 Confirmando fotos para vehículo: $vehiculoId');

      // Buscar todas las fotos temporales de este vehículo
      final clavesVehiculo = _fotosTemporales.keys
          .where((clave) => clave.startsWith(vehiculoId))
          .toList();

      for (final clave in clavesVehiculo) {
        final fotoTemp = _fotosTemporales[clave]!;
        final rutaFinal = _rutasFinales[clave]!;

        // Copiar foto a ubicación final
        final fotoGuardada = await fotoTemp.copy(rutaFinal);

        if (await fotoGuardada.exists()) {
          // Extraer tipo de mantenimiento de la clave
          final tipoMantenimiento = clave.split('_').skip(1).join('_');
          fotosGuardadas[tipoMantenimiento] = rutaFinal;

          print('✅ Foto confirmada: $tipoMantenimiento -> $rutaFinal');
        }
      }

      // Limpiar memoria temporal para este vehículo
      _limpiarFotosTemporales(vehiculoId);

      print('🎉 ${fotosGuardadas.length} fotos confirmadas para $vehiculoId');
      return fotosGuardadas;
    } catch (e) {
      print('❌ Error confirmando fotos: $e');
      return {};
    }
  }

  // Limpiar fotos temporales de un vehículo
  void _limpiarFotosTemporales(String vehiculoId) {
    final clavesAEliminar = _fotosTemporales.keys
        .where((clave) => clave.startsWith(vehiculoId))
        .toList();

    for (final clave in clavesAEliminar) {
      _fotosTemporales.remove(clave);
      _rutasFinales.remove(clave);
    }

    print('🧹 Memoria temporal limpiada para $vehiculoId');
  }

  // Cancelar fotos temporales (cuando el usuario cancela)
  void cancelarFotosTemporales(String vehiculoId) {
    print('❌ Cancelando fotos temporales para $vehiculoId');
    _limpiarFotosTemporales(vehiculoId);
  }

  Future<List<Map<String, String>>> obtenerFotosVehiculo(
    String vehiculoId,
  ) async {
    if (!_inicializado) return [];

    try {
      final carpeta = Directory(_rutaCarpeta!);
      final archivos = await carpeta.list().toList();

      final fotos = <Map<String, String>>[];

      for (final archivo in archivos) {
        if (archivo is File && archivo.path.contains(vehiculoId)) {
          final nombre = archivo.path.split('/').last;
          fotos.add({
            'nombre': nombre,
            'ruta': archivo.path,
            'tipo': _extraerTipoDeNombre(nombre),
          });
        }
      }

      return fotos;
    } catch (e) {
      print('❌ Error buscando fotos: $e');
      return [];
    }
  }

  String _extraerTipoDeNombre(String nombreArchivo) {
    if (nombreArchivo.contains('frontal')) return 'frontal';
    if (nombreArchivo.contains('lateral')) return 'lateral';
    if (nombreArchivo.contains('interior')) return 'interior';
    return 'otra';
  }

  Future<bool> borrarFoto(String rutaFoto) async {
    try {
      final archivo = File(rutaFoto);
      if (await archivo.exists()) {
        await archivo.delete();
        print('🗑️ Foto borrada: $rutaFoto');
        return true;
      }
      return false;
    } catch (e) {
      print('❌ Error borrando foto: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> obtenerEstadisticas() async {
    if (!_inicializado) {
      return {'fotos': 0, 'tamaño': '0 MB'};
    }

    try {
      final carpeta = Directory(_rutaCarpeta!);
      final archivos = await carpeta.list().toList();

      int totalFotos = 0;
      int tamano = 0;

      for (final archivo in archivos) {
        if (archivo is File && archivo.path.endsWith('.jpg')) {
          totalFotos++;
          final stat = await archivo.stat();
          tamano += stat.size;
        }
      }

      final tamanoMB = (tamano / (1024 * 1024)).toStringAsFixed(2);

      return {
        'fotos': totalFotos,
        'tamaño': '$tamanoMB MB',
        'ruta': _rutaCarpeta,
      };
    } catch (e) {
      return {'fotos': 0, 'tamaño': '0 MB'};
    }
  }

  void dispose() {
    _inicializado = false;
    print('🧹 FotosService limpiado');
  }
}
