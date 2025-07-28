import 'package:flutter/material.dart';


class OrdenTrabajoScreen extends StatefulWidget {
  const OrdenTrabajoScreen({super.key});

  @override
  State<OrdenTrabajoScreen> createState() => _OrdenTrabajoScreenState();
}

class _OrdenTrabajoScreenState extends State<OrdenTrabajoScreen> {
  final TextEditingController _clienteController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _kmsController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _costoController = TextEditingController();

  // Checkboxes
  bool _cambioAceite = false;
  bool _cambioBanda = false;
  bool _cambioBujias = false;
  bool _ajusteMotor = false;
  bool _revisionInyeccion = false;
  bool _limpiezaInyectores = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orden de Trabajo'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 3,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB3E5FC), Color(0xFF0288D1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            color: Colors.white,
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel('Cliente'),
                  _buildTextField(_clienteController, 'Nombre completo'),

                  const SizedBox(height: 16),
                  _sectionLabel('Datos del Vehículo'),
                  _buildTextField(_marcaController, 'Marca'),
                  _buildTextField(_modeloController, 'Modelo'),
                  _buildTextField(_placaController, 'Placa'),
                  _buildTextField(_kmsController, 'Kilometraje actual'),
                  _buildTextField(_fechaController, 'Fecha de ingreso'),

                  const SizedBox(height: 16),
                  _sectionLabel('Guía de Mantenimiento'),
                  _buildCheckbox('Cambio de aceite', _cambioAceite, (val) {
                    setState(() => _cambioAceite = val!);
                  }),
                  _buildCheckbox('Cambio de banda', _cambioBanda, (val) {
                    setState(() => _cambioBanda = val!);
                  }),
                  _buildCheckbox('Cambio de bujías', _cambioBujias, (val) {
                    setState(() => _cambioBujias = val!);
                  }),
                  _buildCheckbox('Ajuste de sincronización del motor', _ajusteMotor, (val) {
                    setState(() => _ajusteMotor = val!);
                  }),
                  _buildCheckbox('Revisión del sistema de inyección', _revisionInyeccion, (val) {
                    setState(() => _revisionInyeccion = val!);
                  }),
                  _buildCheckbox('Limpieza de inyectores', _limpiezaInyectores, (val) {
                    setState(() => _limpiezaInyectores = val!);
                  }),

                  const SizedBox(height: 16),
                  _sectionLabel('Descripción del Problema'),
                  _buildTextField(_descripcionController, 'Describe el problema', maxLines: 4),

                  const SizedBox(height: 16),
                  _sectionLabel('Costos de Reparación'),
                  _buildTextField(_costoController, 'Valor estimado (\$)', keyboardType: TextInputType.number),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Guardar lógica
                      },
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text(
                        'Finalizar Reparación',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Icon(Icons.home, size: 28, color: Colors.black87),
              Icon(Icons.add_circle_outline, size: 28, color: Colors.black87),
              Icon(Icons.list_alt, size: 28, color: Colors.black87),
              Icon(Icons.search, size: 28, color: Colors.black87),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox(String title, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.blue,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }
}
