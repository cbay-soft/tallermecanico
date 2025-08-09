import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../constants/app_colors.dart';

class CameraWidget extends StatefulWidget {
  final String vehiculoId;
  final String tipoFoto;
  final Function(File? foto)? onFotoCapturada;

  const CameraWidget({
    super.key,
    required this.vehiculoId,
    required this.tipoFoto,
    this.onFotoCapturada,
  });

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  final ImagePicker _picker = ImagePicker();

  File? _fotoCapturada; // Foto en memoria, no guardada aún
  bool _tomandoFoto = false;

  @override
  void initState() {
    super.initState();
    _verificarPermisos();
  }

  // Verificar permisos de cámara y almacenamiento
  Future<void> _verificarPermisos() async {
    await [Permission.camera, Permission.storage, Permission.photos].request();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _mostrarOpciones,
      child: Container(
        width: 100,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: _tomandoFoto
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.iconoPrincipal,
                ),
              )
            : _fotoCapturada != null
            ? Stack(
                children: [
                  // Vista previa de la foto capturada
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.file(
                      _fotoCapturada!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  // Botón para quitar la foto
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: _quitarFoto,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  // Indicador de que está en memoria
                  Positioned(
                    bottom: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.iconoPrincipal.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'PREVIEW',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add_a_photo,
                    color: AppColors.iconoPrincipal,
                    size: 30,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.tipoFoto.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.textoEtiqueta,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // Mostrar opciones de cámara o galería
  void _mostrarOpciones() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.fondoPrincipalClaro,
              AppColors.fondoPrincipalOscuro,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Foto ${widget.tipoFoto}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _opcionFoto(Icons.camera_alt, 'Cámara', _tomarFoto),
                _opcionFoto(
                  Icons.photo_library,
                  'Galería',
                  _seleccionarGaleria,
                ),
              ],
            ),

            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _opcionFoto(IconData icono, String texto, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icono, color: AppColors.iconoPrincipal, size: 30),
            const SizedBox(height: 8),
            Text(
              texto,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // Tomar foto con cámara
  Future<void> _tomarFoto() async {
    setState(() {
      _tomandoFoto = true;
    });

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image != null) {
        final File fotoFile = File(image.path);

        setState(() {
          _fotoCapturada = fotoFile;
          _tomandoFoto = false;
        });

        // Notificar que se capturó una foto
        widget.onFotoCapturada?.call(fotoFile);
      }
    } catch (e) {
      _mostrarError('Error tomando foto: $e');
    } finally {
      setState(() {
        _tomandoFoto = false;
      });
    }
  }

  // Seleccionar foto de galería
  Future<void> _seleccionarGaleria() async {
    setState(() {
      _tomandoFoto = true;
    });

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image != null) {
        final File fotoFile = File(image.path);

        setState(() {
          _fotoCapturada = fotoFile;
          _tomandoFoto = false;
        });

        // Notificar que se seleccionó una foto
        widget.onFotoCapturada?.call(fotoFile);
      }
    } catch (e) {
      _mostrarError('Error seleccionando foto: $e');
    } finally {
      setState(() {
        _tomandoFoto = false;
      });
    }
  }

  // Quitar foto capturada
  void _quitarFoto() {
    setState(() {
      _fotoCapturada = null;
    });

    // Notificar que se quitó la foto
    widget.onFotoCapturada?.call(null);
  }

  void _mostrarError(String mensaje) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensaje), backgroundColor: AppColors.error),
      );
    }
  }

  // Método público para obtener la foto capturada
  File? get fotoCapturada => _fotoCapturada;

  // Método público para limpiar la foto
  void limpiarFoto() {
    setState(() {
      _fotoCapturada = null;
    });
  }
}
