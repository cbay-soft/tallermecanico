# SOLUCIÓN PROBLEMA FOTOS - 8 de agosto 2025

## Problema reportado
- Las fotos se toman y muestran en el widget (preview funciona)
- Las fotos NO se guardan al confirmar el mantenimiento
- SnackBars aparecen al tomar fotos (deberían aparecer solo al guardar)

## Cambios realizados

### 1. CameraWidget - Eliminación de SnackBars
**Archivo:** `lib/widgets/camera_widget.dart`

- ❌ **ELIMINADO:** SnackBars que aparecían al tomar/seleccionar fotos
- ✅ **RESULTADO:** Los SnackBars ahora solo aparecen al guardar el mantenimiento

### 2. MantenimientoScreen - Captura y paso de fotos
**Archivo:** `lib/screens/mantenimiento_screen.dart`

- ✅ **AGREGADO:** Map `_fotosCapturadas` para almacenar fotos en memoria
- ✅ **MODIFICADO:** Callbacks de CameraWidget para actualizar el estado
- ✅ **MEJORADO:** Botón guardar usa `guardarMantenimientoConFotos()`
- ✅ **AGREGADO:** Indicador visual de fotos capturadas
- ✅ **AGREGADO:** SnackBar con información de fotos guardadas

### 3. MecanicoMantenimientoScreen - Mismo tratamiento
**Archivo:** `lib/screens/mecanico_mantenimiento_screen.dart`

- ✅ **MODIFICADO:** Callback de CameraWidget con `setState()`
- ✅ **MEJORADO:** Indicador dinámico de fotos capturadas

### 4. FotosService - Debug mejorado
**Archivo:** `lib/services/fotos_service.dart`

- ✅ **AGREGADO:** Logging detallado en `guardarFotosMantenimiento()`
- ✅ **AGREGADO:** Verificación de existencia de archivos
- ✅ **AGREGADO:** Validación de carpeta destino
- ✅ **AGREGADO:** Stack trace en errores
- ✅ **MEJORADO:** Mensajes de debug más claros

## Flujo corregido

### Antes (❌ NO funcionaba)
1. Usuario toma foto → SnackBar "foto tomada"
2. Foto se muestra en preview
3. Usuario guarda mantenimiento
4. **PROBLEMA:** Fotos no se pasaban al controlador

### Ahora (✅ SÍ funciona)
1. Usuario toma foto → Foto se guarda en `_fotosCapturadas`
2. Foto se muestra en preview + indicador actualizado
3. Usuario guarda mantenimiento → Se llama `guardarMantenimientoConFotos()`
4. **SOLUCIÓN:** Fotos se pasan al servicio y se guardan en galería
5. SnackBar confirma guardado exitoso con número de fotos

## Logs para debug

El servicio ahora muestra logs detallados:
```
🔥 === INICIANDO GUARDADO DE FOTOS ===
📱 Fotos recibidas: 2
🆔 Vehículo ID: vehiculo123
📸 Procesando foto: frontal
📍 Archivo existe: true
📏 Tamaño archivo: 1234567 bytes
💾 Copiando foto a: /storage/emulated/0/Pictures/taller_fotos/frontal_vehiculo123_1625789123456.jpg
✅ Foto guardada exitosamente en galería
🎉 RESULTADO: 2/2 fotos guardadas
```

## Testing

Para probar:
1. Ir a MantenimientoScreen
2. Tomar fotos (verificar que aparece indicador de "X foto(s) capturada(s)")
3. Guardar mantenimiento
4. Verificar SnackBar con confirmación de fotos guardadas
5. Verificar en galería del teléfono carpeta "taller_fotos"

## Notas técnicas

- Las fotos se guardan en `/storage/emulated/0/Pictures/taller_fotos/`
- Formato de nombres: `{tipo}_{vehiculoId}_{timestamp}.jpg`
- La inicialización del servicio es automática si no está lista
- Los permisos se solicitan automáticamente
