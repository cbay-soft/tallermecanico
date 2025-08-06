import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/app_colors.dart';
import '../services/fotos_service.dart';

class CameraWidget extends StatefulWidget {
  final String vehiculoId;
  final String tipoFoto;
  final Function(String url)? onFotoSubida;

  const CameraWidget({
    super.key,
    required this.vehiculoId,
    required this.tipoFoto,
    this.onFotoSubida,
  });

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  final ImagePicker _picker = ImagePicker();
  final FotosService _fotosService = FotosService();

  bool _subiendo = false;
  String? _fotoUrl;

  @override
  void initState() {
    super.initState();
    _inicializar();
  }

  Future<void> _inicializar() async {
    try {
      await _fotosService.initialize();
      await _cargarFotoExistente();
    } catch (e) {
      print('Error inicializando: $e');
    }
  }

  Future<void> _cargarFotoExistente() async {
    try {
      final fotos = await _fotosService.obtenerFotosVehiculo(widget.vehiculoId);
      final fotoTipo = fotos
          .where((f) => f['name']!.contains(widget.tipoFoto))
          .firstOrNull;

      if (fotoTipo != null && mounted) {
        setState(() {
          _fotoUrl = fotoTipo['url'];
        });
      }
    } catch (e) {
      print('Error cargando foto: $e');
    }
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
        child: _subiendo
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.iconoPrincipal,
                ),
              )
            : _fotoUrl != null && _fotoUrl!.isNotEmpty
            ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      _fotoUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.iconoPrincipal,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                color: AppColors.iconoPrincipal,
                                size: 30,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'AGREGAR',
                                style: TextStyle(
                                  color: AppColors.textoEtiqueta,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: _borrarFoto,
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

  Future<void> _tomarFoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image != null) {
        await _subirFoto(File(image.path));
      }
    } catch (e) {
      _mostrarError('Error tomando foto: $e');
    }
  }

  Future<void> _seleccionarGaleria() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image != null) {
        await _subirFoto(File(image.path));
      }
    } catch (e) {
      _mostrarError('Error seleccionando foto: $e');
    }
  }

  Future<void> _subirFoto(File foto) async {
    setState(() {
      _subiendo = true;
    });

    try {
      final url = await _fotosService.guardarFotoTemporal(
        foto,
        widget.vehiculoId,
        widget.tipoFoto,
      );

      setState(() {
        _fotoUrl = url;
        _subiendo = false;
      });

      if (url != null) {
        widget.onFotoSubida?.call(url);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Foto ${widget.tipoFoto} lista para subir a tu carpeta compartida',
            ),
            backgroundColor: AppColors.exito,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _subiendo = false;
      });
      _mostrarError('Error subiendo foto: $e');
    }
  }

  Future<void> _borrarFoto() async {
    if (_fotoUrl == null) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Borrar foto'),
        content: Text('¿Borrar la foto ${widget.tipoFoto}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Borrar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      try {
        final borrado = await _fotosService.borrarFoto(_fotoUrl!);

        if (borrado && mounted) {
          setState(() {
            _fotoUrl = null;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Foto borrada'),
              backgroundColor: AppColors.exito,
            ),
          );
        }
      } catch (e) {
        _mostrarError('Error borrando foto: $e');
      }
    }
  }

  void _mostrarError(String mensaje) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensaje), backgroundColor: AppColors.error),
      );
    }
  }
}
