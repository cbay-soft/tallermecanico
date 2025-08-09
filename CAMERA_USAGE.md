# 📸 Sistema de Cámara Mejorado - Taller Mecánico

## 🎯 Características Principales

### Vista previa en memoria
- Las fotos capturadas se muestran **inmediatamente** en el widget de cámara
- **NO se guardan** en la galería hasta confirmar el mantenimiento
- Indicador visual "PREVIEW" muestra que la foto está en memoria

### Guardado inteligente
- Las fotos se guardan **solo cuando se confirma el mantenimiento**
- Se almacenan en la galería del teléfono en la carpeta `Pictures/taller_fotos/`
- Nombres únicos con timestamp para evitar duplicados

### Manejo de errores mejorado
- Verificación automática de permisos de cámara y almacenamiento
- Mensajes informativos para el usuario
- Opción de eliminar fotos antes de guardar

## 🛠️ Cómo funciona

### 1. Capturar foto
```dart
CameraWidget(
  vehiculoId: vehiculo.id,
  tipoFoto: 'mantenimiento',
  onFotoCapturada: (File? foto) {
    if (foto != null) {
      // Foto capturada exitosamente
      fotosTemporales['mantenimiento'] = foto;
    } else {
      // Foto eliminada
      fotosTemporales.remove('mantenimiento');
    }
  },
)
```

### 2. Guardar mantenimiento
```dart
await controller.guardarMantenimientoConFotos(
  vehiculoId,
  fotosCapturadas: fotosTemporales,
  observacionAdicional: observaciones,
);
```

### 3. Resultado
- Fotos guardadas en galería: `/Pictures/taller_fotos/`
- Referencias guardadas en Firebase
- Mantenimiento completado

## 📁 Estructura de archivos

### Ubicación de fotos guardadas:
```
/storage/emulated/0/Pictures/taller_fotos/
├── mantenimiento_vehiculo123_1234567890.jpg
├── frontal_vehiculo456_1234567891.jpg
└── lateral_vehiculo789_1234567892.jpg
```

### Formato de nombres:
```
{tipoFoto}_{vehiculoId}_{timestamp}.jpg
```

## 🔧 Configuración de permisos

### Android (android/app/src/main/AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

### Verificación automática
El widget verifica automáticamente los permisos al inicializarse.

## 🎨 Estados visuales

### Sin foto capturada
- Icono de cámara con texto del tipo de foto
- Fondo semitransparente

### Foto capturada (preview)
- Vista previa de la imagen
- Botón "X" para eliminar
- Etiqueta "PREVIEW" indicando que está en memoria

### Tomando foto
- Indicador de carga circular
- Bloquea la interfaz durante la captura

## 🚀 Ejemplo de uso completo

```dart
class MiPantallaMantenimiento extends StatefulWidget {
  @override
  _MiPantallaMantenimientoState createState() => _MiPantallaMantenimientoState();
}

class _MiPantallaMantenimientoState extends State<MiPantallaMantenimiento> {
  final Map<String, File> fotosCapturadas = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Widget de cámara
        CameraWidget(
          vehiculoId: widget.vehiculo.id,
          tipoFoto: 'mantenimiento',
          onFotoCapturada: (File? foto) {
            setState(() {
              if (foto != null) {
                fotosCapturadas['mantenimiento'] = foto;
              } else {
                fotosCapturadas.remove('mantenimiento');
              }
            });
          },
        ),
        
        // Botón guardar
        ElevatedButton(
          onPressed: () async {
            await controller.guardarMantenimientoConFotos(
              widget.vehiculo.id,
              fotosCapturadas: fotosCapturadas,
              observacionAdicional: observaciones.text,
            );
            
            // Limpiar fotos después de guardar
            setState(() {
              fotosCapturadas.clear();
            });
          },
          child: Text('Guardar Mantenimiento'),
        ),
      ],
    );
  }
}
```

## ⚡ Mejoras implementadas

1. **Rendimiento**: Las fotos no se copian múltiples veces
2. **UX**: Vista previa inmediata sin esperas
3. **Almacenamiento**: Fotos organizadas en carpeta específica
4. **Seguridad**: Verificación de permisos automática
5. **Limpieza**: No quedan archivos temporales sin usar

## 🐛 Solución de problemas

### La foto no se muestra
- Verificar permisos de cámara
- Comprobar que el archivo existe en la ruta

### Error al guardar
- Verificar permisos de almacenamiento
- Comprobar espacio disponible en el dispositivo

### La app se cierra al tomar foto
- Verificar que todos los permisos están concedidos
- Revisar logs para errores específicos
