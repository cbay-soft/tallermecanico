import 'package:flutter/material.dart';

class DetallesvehiculoScreen extends StatefulWidget {
  const DetallesvehiculoScreen({super.key});

  @override
  State<DetallesvehiculoScreen> createState() => _DetallesvehiculoScreenState();
}

class _DetallesvehiculoScreenState extends State<DetallesvehiculoScreen> {
  // Definimos las variables para manejar el estado de los checkboxes
  bool _cambioAceite = false;
  bool _cambioBanda = false;
  bool _cambioBujias = false;
  bool _ajusteSincronizacion = false;
  bool _revisionInyeccion = false;
  bool _limpiezaInyectores = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del vehículo'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Datos del cliente
              Text('Datos del cliente', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildTextField('Nombre Completo'),
              _buildTextField('Cedula o RUC'),
              _buildTextField('Teléfono'),
              _buildTextField('Correo electrónico'),

              SizedBox(height: 20),

              // Datos del vehículo
              Text('Datos del vehículo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildTextField('Marca'),
              _buildTextField('Año'),
              _buildTextField('Kilometraje actual'),
              _buildTextField('Fecha de ingreso'),

              SizedBox(height: 20),

              // Guía de mantenimiento
              Text('Guía de mantenimiento', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildCheckbox('Cambio de aceite', _cambioAceite, (newValue) {
                setState(() {
                  _cambioAceite = newValue!;
                });
              }),
              _buildCheckbox('Cambio de banda', _cambioBanda, (newValue) {
                setState(() {
                  _cambioBanda = newValue!;
                });
              }),
              _buildCheckbox('Cambio de bujías', _cambioBujias, (newValue) {
                setState(() {
                  _cambioBujias = newValue!;
                });
              }),
              _buildCheckbox('Ajuste de la sincronización del motor', _ajusteSincronizacion, (newValue) {
                setState(() {
                  _ajusteSincronizacion = newValue!;
                });
              }),
              _buildCheckbox('Revisión del sistema de inyección de combustible', _revisionInyeccion, (newValue) {
                setState(() {
                  _revisionInyeccion = newValue!;
                });
              }),
              _buildCheckbox('Limpieza de inyectores', _limpiezaInyectores, (newValue) {
                setState(() {
                  _limpiezaInyectores = newValue!;
                });
              }),

              SizedBox(height: 20),

              // Descripción del problema
              Text('Descripción del problema', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildTextField('Describe el problema aquí', maxLines: 5),

              SizedBox(height: 20),

              // Fotos del vehículo
              Text('Fotos del vehículo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildImagePicker(),

              SizedBox(height: 20),

              // Botón de envío o acción
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Acción al presionar el botón
                  },
                  child: const Text('Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: onChanged),
        Expanded(child: Text(label)),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(4, (index) {
        return GestureDetector(
          onTap: () {
            // Implement photo picker logic here
          },
          child: Container(
            width: 60,
            height: 60,
            color: Colors.grey[200],
            child: Icon(Icons.add_a_photo, color: Colors.blue),
          ),
        );
      }),
    );
  }
}
