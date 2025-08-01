import 'package:flutter/material.dart';

class AppColors {
  // ========================================
  // 🔘 FONDO PRINCIPAL - GRIS PROFESIONAL
  // ========================================
  
  // Gradiente principal gris elegante
  static const Color fondoPrincipalClaro = Color(0xFF90A4AE);     // Gris claro profesional
  static const Color fondoPrincipalOscuro = Color(0xFF455A64);    // Gris oscuro sofisticado
  
  // AppBar coordinado con el fondo
  static const Color appBarFondo = Color(0xFF37474F);             // Gris más oscuro que el fondo
  static const Color appBarTexto = Color(0xFFFFFFFF);             // Blanco puro
  static const Color appBarIconos = Color(0xFFFFFFFF);            // Iconos blancos

  // ========================================
  // 🔘 TEXTOS - OPTIMIZADOS PARA FONDO GRIS
  // ========================================
  
  // Textos principales sobre fondo gris
  static const Color textoTitulo = Color.fromARGB(255, 255, 255, 255);             // Blanco puro (máximo contraste)
  static const Color textoEtiqueta = Color.fromARGB(255, 218, 217, 217);           // Gris muy claro (etiquetas)
  static const Color textoSutil = Color(0xFFCFD8DC);              // Gris claro (texto secundario)
  
  // Textos sobre componentes blancos/claros
  static const Color textoOscuro = Color(0xFF263238);             // Gris muy oscuro
  static const Color textoMedio = Color(0xFF37474F);              // Gris medio
  static const Color textoPlaceholder = Color(0xFF78909C);        // Placeholder en inputs
  static const Color textoAzul = Color(0xFF335C75);              // Azul

  // ========================================
  // 🟠 NARANJAS - ACENTOS CÁLIDOS PARA ACCIÓN
  // ========================================
  
  // Botones principales - Naranja que contrasta con gris
  static const Color botonPrincipal = Color(0xFFFF6F00);          // Naranja vibrante
  static const Color botonPrincipalHover = Color.fromARGB(255, 120, 255, 176);    // Naranja más claro para hover
  static const Color botonPrincipalTexto = Color(0xFFFFFFFF);     // Texto blanco
  static const Color botonPrincipalPresionado = Color(0xFFE65100); // Naranja más oscuro
  static const Color botonPrincipalSombra = Color(0x4DFF6F00);    // Sombra naranja suave
  
  // Advertencias que resaltan sobre gris
  static const Color advertencia = Color(0xFFFFB300);             // Ámbar brillante
  static const Color advertenciaTexto = Color(0xFF263238);        // Texto oscuro sobre ámbar
  static const Color advertenciaFondo = Color.fromARGB(255, 255, 204, 86);        // Fondo ámbar translúcido

  // ========================================
  // 🟢 VERDES - ÉXITO VISIBLE SOBRE GRIS
  // ========================================
  
  // Estados de éxito que contrastan con gris
  static const Color exito = Color.fromARGB(255, 207, 255, 227);                   // Verde brillante
  static const Color exitoTexto = Color(0xFFFFFFFF);              // Texto blanco sobre verde
  static const Color exitoClaro = Color(0xFF69F0AE);              // Verde claro para hover
  static const Color exitoFondo = Color(0x1A00C853);              // Fondo verde translúcido
  
  // Iconos de confirmación
  static const Color iconoExito = Color.fromARGB(255, 120, 255, 176);              // Verde confirmación

  // ========================================
  // 🔴 ROJOS - ERROR CONTRASTANTE
  // ========================================
  
  // Errores que se vean claramente sobre gris
  static const Color error = Color.fromARGB(255, 255, 199, 210);                   // Rojo brillante
  static const Color errorTexto = Color(0xFFFFFFFF);              // Texto blanco sobre rojo
  static const Color errorClaro = Color(0xFFFF8A80);              // Rojo suave
  static const Color errorFondo = Color(0x1AFF1744);              // Fondo rojo translúcido
  
  // Iconos de eliminación
  static const Color iconoEliminar = Color(0xFFB0BEC5);           // Gris suave (neutro)
  static const Color iconoEliminarActivo = Color.fromARGB(255, 255, 130, 155);     // Rojo cuando está activo

  // ========================================
  // 🔵 AZULES - INFORMACIÓN Y NAVEGACIÓN
  // ========================================
  
  // Azules que complementan el gris
  static const Color informacion = Color(0xFF2196F3);             // Azul información
  static const Color informacionTexto = Color(0xFFFFFFFF);        // Texto blanco sobre azul
  static const Color informacionClaro = Color(0xFF64B5F6);        // Azul claro
  static const Color informacionFondo = Color(0x1A2196F3);        // Fondo azul translúcido

  // ========================================
  // 🔘 ELEMENTOS DE INTERFAZ
  // ========================================
  
  // Botones secundarios que armonizan con el gris
  static const Color botonSecundario = Color(0xFF546E7A);         // Gris azulado
  static const Color botonSecundarioTexto = Color(0xFFFFFFFF);    // Texto blanco
  static const Color botonSecundarioHover = Color(0xFF607D8B);    // Hover más claro
  
  // Iconos optimizados para fondo gris
  static const Color iconoPrincipal = Color(0xFFFFFFFF);          // Iconos principales blancos
  static const Color iconoSecundario = Color(0xFFCFD8DC);         // Iconos secundarios grises
  static const Color iconoAccion = Color(0xFFFF6F00);             // Iconos de acción naranjas
  static const Color iconoNavegacion = Color(0xFF2196F3);         // Iconos de navegación azules
  
  // Superficies y componentes
  static const Color fondoCard = Color(0xFFFFFFFF);               // Cards blancas sobre gris
  static const Color fondoInput = Color(0xFFFFFFFF);              // Inputs blancos
  static const Color fondoModal = Color(0x80000000);              // Overlay oscuro
  static const Color fondoComponente = Color(0x1AFFFFFF);         // Componente translúcido
  
  // Bordes y divisores para fondo gris
  static const Color divisor = Color(0xFFFFFFFF);                 // Divisores blancos
  static const Color borde = Color.fromARGB(255, 208, 231, 240);                   // Bordes sutiles
  static const Color bordeActivo = Color(0xFFFF6F00);             // Bordes activos naranjas
  static const Color bordeError = Color(0xFFFF1744);              // Bordes de error rojos

  // ========================================
  // 🚗 ESPECÍFICOS PARA TALLER MECÁNICO
  // ========================================
  
  // Estados de vehículos sobre fondo gris
  static const Color vehiculoActivo = Color(0xFF00C853);          // Verde brillante
  static const Color vehiculoPendiente = Color(0xFFFFB300);       // Ámbar
  static const Color vehiculoCompletado = Color(0xFF2196F3);      // Azul
  static const Color vehiculoInactivo = Color(0xFF78909C);        // Gris medio
  
  // Indicadores de carga para fondo gris
  static const Color carga = Color(0xFFFF6F00);                   // Naranja dinámico
  static const Color cargaFondo = Color(0x4D000000);              // Overlay oscuro translúcido
  
  // Prioridades de trabajo
  static const Color prioridadAlta = Color(0xFFFF1744);           // Rojo urgente
  static const Color prioridadMedia = Color(0xFFFFB300);          // Ámbar medio
  static const Color prioridadBaja = Color(0xFF2196F3);           // Azul tranquilo

  // ========================================
  // 🎨 ACENTOS COMPLEMENTARIOS
  // ========================================
  
  // Colores de acento que funcionan con gris
  static const Color acentoPrimario = Color(0xFFFF6F00);          // Naranja principal
  static const Color acentoSecundario = Color(0xFF2196F3);        // Azul complementario
  static const Color acentoTerciario = Color(0xFF00C853);         // Verde de acento
  
  // Sombras y elevaciones
  static const Color sombraClara = Color(0x1A000000);             // Sombra suave
  static const Color sombraMedia = Color(0x33000000);             // Sombra media
  static const Color sombraOscura = Color(0x4D000000);            // Sombra profunda
}