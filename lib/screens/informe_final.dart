import 'package:flutter/material.dart';

class ResumenTrabajoScreen extends StatefulWidget {
  const ResumenTrabajoScreen({super.key});

  @override
  State<ResumenTrabajoScreen> createState() => _ResumenTrabajoScreenState();
}

class _ResumenTrabajoScreenState extends State<ResumenTrabajoScreen> {
  final TextEditingController _clienteController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _kmsController = TextEditingController();
  final TextEditingController _fechaIngresoController = TextEditingController();
  final TextEditingController _fechaSalidaController = TextEditingController();
  final TextEditingController _solicitudesAdicionalesController = TextEditingController();

  bool _cambioAceite = true;
  bool _cambioBanda = true;
  bool _cambioBujias = true;
  bool _ajusteMotor = true;
  bool _revisionInyeccion = true;
  bool _limpiezaInyectores = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        title: const Text('Resumen de trabajo', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB3E5FC), Color(0xFF0288D1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('Datos del cliente y vehículo'),
                    _buildTextField(_clienteController, 'Cliente'),
                    _buildTextField(_placaController, 'Placa'),
                    _buildTextField(_marcaController, 'Marca'),
                    _buildTextField(_kmsController, 'Kilometraje'),
                    _buildTextField(_fechaIngresoController, 'Fecha de ingreso'),
                    _buildTextField(_fechaSalidaController, 'Fecha de salida'),

                    const SizedBox(height: 20),
                    _sectionTitle('Reparaciones realizadas'),
                    _buildCheckbox('Cambio de aceite', _cambioAceite, (val) => setState(() => _cambioAceite = val!)),
                    _buildCheckbox('Cambio de banda', _cambioBanda, (val) => setState(() => _cambioBanda = val!)),
                    _buildCheckbox('Cambio de bujías', _cambioBujias, (val) => setState(() => _cambioBujias = val!)),
                    _buildCheckbox('Ajuste de sincronización en el motor', _ajusteMotor, (val) => setState(() => _ajusteMotor = val!)),
                    _buildCheckbox('Revisión del sistema de inyección de combustible', _revisionInyeccion, (val) => setState(() => _revisionInyeccion = val!)),
                    _buildCheckbox('Limpieza de inyectores', _limpiezaInyectores, (val) => setState(() => _limpiezaInyectores = val!)),

                    const SizedBox(height: 20),
                    _sectionTitle('Solicitudes adicionales del cliente'),
                    _buildTextField(_solicitudesAdicionalesController, 'Ingrese solicitudes', maxLines: 4),

                    const SizedBox(height: 30),
                    _greenButton('Generar factura', () {
                      // Acción generar factura
                    }),
                    const SizedBox(height: 10),
                    _greenButton('Confirmar entrega', () {
                      // Acción confirmar entrega
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset('assets/images/logoTaller.png', width: 50, height: 50),
            _bottomButton(Icons.add_circle_outline, 'Nuevo', () {
              Navigator.pushNamed(context, '/pedido');
            }),
            _bottomButton(Icons.list_alt, 'Listar', () {
              Navigator.pushNamed(context, '/vehiculos_ingresados');
            }),
            _bottomButton(Icons.search, 'Buscar', () {
              Navigator.pushNamed(context, '/busqueda');
            }),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
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

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
      title: Text(title),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.green,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _greenButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.check_circle_outline),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _bottomButton(IconData icon, String label, VoidCallback onPressed) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 24),
          ),
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}