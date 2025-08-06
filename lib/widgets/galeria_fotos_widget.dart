import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/fotos_service.dart';

class GaleriaFotosWidget extends StatefulWidget {
  final String vehiculoId;

  const GaleriaFotosWidget({super.key, required this.vehiculoId});

  @override
  State<GaleriaFotosWidget> createState() => _GaleriaFotosWidgetState();
}

class _GaleriaFotosWidgetState extends State<GaleriaFotosWidget> {
  final FotosService _fotosService = FotosService();
  List<Map<String, String>> _fotos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarFotos();
  }

  Future<void> _cargarFotos() async {
    try {
      await _fotosService.initialize();
      final fotos = await _fotosService.obtenerFotosVehiculo(widget.vehiculoId);

      setState(() {
        _fotos = fotos;
        _cargando = false;
      });
    } catch (e) {
      setState(() {
        _cargando = false;
      });
      print('Error cargando fotos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.iconoPrincipal),
      );
    }

    if (_fotos.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 64,
              color: AppColors.textoEtiqueta,
            ),
            SizedBox(height: 16),
            Text(
              'No hay fotos disponibles',
              style: TextStyle(color: AppColors.textoEtiqueta, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: _fotos.length,
      itemBuilder: (context, index) {
        final foto = _fotos[index];
        return _buildFotoCard(foto);
      },
    );
  }

  Widget _buildFotoCard(Map<String, String> foto) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              foto['url']!,
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
                  child: Icon(Icons.error, color: Colors.red, size: 32),
                );
              },
            ),
          ),

          // Overlay con acciones
          Positioned(
            top: 8,
            right: 8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildActionButton(Icons.zoom_in, () => _verFotoCompleta(foto)),
                const SizedBox(width: 4),
                _buildActionButton(
                  Icons.delete,
                  () => _borrarFoto(foto),
                  color: Colors.red,
                ),
              ],
            ),
          ),

          // Nombre de la foto
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Text(
                _extraerTipoFoto(foto['name']!),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, VoidCallback onTap, {Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: (color ?? Colors.white).withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 16,
          color: color == null ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  String _extraerTipoFoto(String nombreArchivo) {
    if (nombreArchivo.contains('frontal')) return 'Frontal';
    if (nombreArchivo.contains('lateral')) return 'Lateral';
    if (nombreArchivo.contains('interior')) return 'Interior';
    return 'Foto';
  }

  void _verFotoCompleta(Map<String, String> foto) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const BackButton(color: Colors.white),
            title: Text(
              _extraerTipoFoto(foto['name']!),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          body: Center(
            child: InteractiveViewer(
              child: Image.network(
                foto['url']!,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.error, color: Colors.red, size: 64),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _borrarFoto(Map<String, String> foto) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Borrar foto'),
        content: Text('¿Borrar la foto ${_extraerTipoFoto(foto['name']!)}?'),
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
        final borrado = await _fotosService.borrarFoto(foto['ruta']!);

        if (borrado) {
          setState(() {
            _fotos.removeWhere((f) => f['id'] == foto['id']);
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Foto borrada de Google Drive'),
                backgroundColor: AppColors.exito,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error borrando foto: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }
}
