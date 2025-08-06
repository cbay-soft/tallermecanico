import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ChecklistMantenimientoWidget extends StatefulWidget {
  final Function(Map<String, Map<String, bool>>) onChecklistChanged;
  
  const ChecklistMantenimientoWidget({
    super.key,
    required this.onChecklistChanged,
  });

  @override
  State<ChecklistMantenimientoWidget> createState() => _ChecklistMantenimientoWidgetState();
}

class _ChecklistMantenimientoWidgetState extends State<ChecklistMantenimientoWidget> {
  
  // Datos del checklist organizados por categorías
  final Map<String, Map<String, bool>> _checklist = {
    'MOTOR': {
      'Cambio de aceite del motor': false,
      'Limpiar o Cambiar Filtro de Aire': false,
      'Verificar fugas de Aceite, Agua o Combustible': false,
      'Revisar y completar niveles de fluidos': false,
      'Ajustar Tensión de las Correas': false,
      'Verificar el estado de las Mangueras': false,
      'Revisión y cambio de filtro combustible/gas/gasolina': false,
      'Revisar Sistema del Aire Acondicionado': false,
    },
    'CAJA DE CAMBIO Y TRANSMISIÓN': {
      'Verificar niveles de aceite': false,
      'Crucetas': false,
      'Cambio de aceite de caja': false,
      'Cambio de aceite de transmisión': false,
      'Cambio de aceite de dirección': false,
    },
    'SISTEMA DE FRENOS': {
      'Revisar el revestimiento de las zapatas': false,
      'Revisar sistema de tubería de aire': false,
      'Calibración de ruedas': false,
      'Revisión de presión de aire de frenos': false,
      'Revisión de tensión de frenos de mano': false,
    },
    'SISTEMA ELÉCTRICO': {
      'Revisar los manómetros del Tablero': false,
      'Revisar faros, guías, luces': false,
      'Revisión de sistema de encendido': false,
      'Revisar las Baterías': false,
      'Inspección de faros de nieblas': false,
      'Inspección de claxo (Corneta)': false,
    },
    'SUSPENSIÓN Y LLANTAS': {
      'Revisión de amortiguadores': false,
      'Revisar paquetes o muelles de ballesta': false,
      'Revisar regularmente pines y bocines (suspensión delantera)': false,
      'Revisar barra de la dirección y terminales': false,
      'Inspección de rótulas': false,
      'Inspección de bujes': false,
      'Inspección de condiciones de los neumáticos': false,
      'Inspección presión de neumáticos': false,
      'Inspección cauchos de repuesto': false,
    },
    'SISTEMA DE REFRIGERACIÓN': {
      'Inspección del radiador': false,
      'Inspección de mangueras del radiador': false,
      'Inspección del electroventilador': false,
      'Inspección presión tapa del radiador': false,
      'Inspección caudal de frío A/C': false,
      'Inspección del compresor A/C': false,
    },
    'EQUIPOS DE SEGURIDAD': {
      'Inspección de extintores': false,
      'Inspección de cinturón y triángulos de seguridad': false,
      'Inspección de espejos retrovisores': false,
    },
  };

  @override
  void initState() {
    super.initState();
    // Solo notifica items completados inicialmente
    widget.onChecklistChanged(_getCompletedItemsOnly());
  }

  // Método para filtrar los elegidos
  Map<String, Map<String, bool>> _getCompletedItemsOnly() {
    Map<String, Map<String, bool>> completedOnly = {};
    
    _checklist.forEach((categoria, items) {
      Map<String, bool> completedItems = {};
      
      items.forEach((item, isCompleted) {
        if (isCompleted) {
          completedItems[item] = true;
        }
      });
      
      // Solo agregar categoría si tiene items completados
      if (completedItems.isNotEmpty) {
        completedOnly[categoria] = completedItems;
      }
    });
    
    return completedOnly;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado del checklist
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.iconoPrincipal.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.checklist_outlined,
                  color: AppColors.iconoPrincipal,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'CHECKLIST DE MANTENIMIENTO',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Contador de progreso
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.exito.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_getCompletedCount()}/${_getTotalCount()}',
                    style: TextStyle(
                      color: AppColors.exito,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Lista de categorías expansibles
          ...List.generate(
            _checklist.keys.length,
            (index) {
              final categoria = _checklist.keys.elementAt(index);
              final items = _checklist[categoria]!;
              
              return _buildCategoriaExpansible(categoria, items);
            },
          ),
        ],
      ),
    );
  }

  // Widget para cada categoría expansible
  Widget _buildCategoriaExpansible(String categoria, Map<String, bool> items) {
    final completados = items.values.where((v) => v).length;
    final total = items.length;
    final progreso = total > 0 ? completados / total : 0.0;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: progreso == 1.0 
                ? AppColors.exito.withValues(alpha: 0.2)
                : AppColors.iconoPrincipal.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getCategoriaIcon(categoria),
            color: progreso == 1.0 ? AppColors.exito : AppColors.iconoPrincipal,
            size: 20,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              categoria,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            // Barra de progreso minimalista
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progreso,
                child: Container(
                  decoration: BoxDecoration(
                    color: progreso == 1.0 ? AppColors.exito : AppColors.iconoPrincipal,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ],
        ),
        trailing: Text(
          '$completados/$total',
          style: TextStyle(
            color: progreso == 1.0 ? AppColors.exito : Colors.white70,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        iconColor: Colors.white,
        collapsedIconColor: Colors.white70,
        children: [
          ...items.entries.map((entry) {
            return _buildChecklistItem(categoria, entry.key, entry.value);
          }).toList(),
        ],
      ),
    );
  }

  // Widget para cada item del checklist
  Widget _buildChecklistItem(String categoria, String item, bool isChecked) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isChecked 
            ? AppColors.exito.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isChecked 
              ? AppColors.exito.withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Checkbox personalizado
          GestureDetector(
            onTap: () => _toggleItem(categoria, item),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isChecked ? AppColors.exito : Colors.transparent,
                border: Border.all(
                  color: isChecked ? AppColors.exito : Colors.white54,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: isChecked
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          // ✅ Texto del item
          Expanded(
            child: Text(
              item,
              style: TextStyle(
                color: isChecked ? AppColors.exito : Colors.white,
                fontSize: 13,
                fontWeight: isChecked ? FontWeight.w500 : FontWeight.normal,
                decoration: isChecked ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Alternar estado de un item
  void _toggleItem(String categoria, String item) {
    setState(() {
      _checklist[categoria]![item] = !_checklist[categoria]![item]!;
    });
    
    // Solo enviar los items marcados como true
    widget.onChecklistChanged(_getCompletedItemsOnly());
  }

  // Obtener ícono para cada categoría
  IconData _getCategoriaIcon(String categoria) {
    switch (categoria) {
      case 'MOTOR':
        return Icons.precision_manufacturing_outlined;
      case 'CAJA DE CAMBIO Y TRANSMISIÓN':
        return Icons.settings_outlined;
      case 'SISTEMA DE FRENOS':
        return Icons.disc_full_outlined;
      case 'SISTEMA ELÉCTRICO':
        return Icons.electrical_services_outlined;
      case 'SUSPENSIÓN Y LLANTAS':
        return Icons.tire_repair_outlined;
      case 'SISTEMA DE REFRIGERACIÓN':
        return Icons.ac_unit_outlined;
      case 'EQUIPOS DE SEGURIDAD':
        return Icons.security_outlined;
      default:
        return Icons.build_outlined;
    }
  }

  // Contar items completados
  int _getCompletedCount() {
    int count = 0;
    _checklist.forEach((categoria, items) {
      count += items.values.where((v) => v).length;
    });
    return count;
  }

  // Contar total de items
  int _getTotalCount() {
    int count = 0;
    _checklist.forEach((categoria, items) {
      count += items.length;
    });
    return count;
  }
}