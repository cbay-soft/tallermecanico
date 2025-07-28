import 'package:flutter/material.dart';


class DetallesvehiculoScreen extends StatefulWidget {
  const DetallesvehiculoScreen({super.key});

  @override
  State<DetallesvehiculoScreen> createState() => _DetallesvehiculoScreenState();
}

class _DetallesvehiculoScreenState extends State<DetallesvehiculoScreen> {
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
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Detalles del vehículo',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF89CFF0), Color(0xFF4682B4)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Datos del cliente'),
                _buildTextField('Nombre completo'),
                _buildTextField('Cédula o RUC'),
                _buildTextField('Teléfono'),
                _buildTextField('Correo electrónico'),
                const SizedBox(height: 20),

                _buildSectionTitle('Datos del vehículo'),
                _buildTextField('Marca'),
                _buildTextField('Año'),
                _buildTextField('Kilometraje actual'),
                _buildTextField('Fecha de ingreso'),
                const SizedBox(height: 20),

                _buildSectionTitle('Guía de mantenimiento'),
                _buildCheckbox('Cambio de aceite', _cambioAceite, (val) {
                  setState(() => _cambioAceite = val!);
                }),
                _buildCheckbox('Cambio de banda', _cambioBanda, (val) {
                  setState(() => _cambioBanda = val!);
                }),
                _buildCheckbox('Cambio de bujías', _cambioBujias, (val) {
                  setState(() => _cambioBujias = val!);
                }),
                _buildCheckbox('Ajuste de la sincronización del motor', _ajusteSincronizacion, (val) {
                  setState(() => _ajusteSincronizacion = val!);
                }),
                _buildCheckbox('Revisión del sistema de inyección de combustible', _revisionInyeccion, (val) {
                  setState(() => _revisionInyeccion = val!);
                }),
                _buildCheckbox('Limpieza de inyectores', _limpiezaInyectores, (val) {
                  setState(() => _limpiezaInyectores = val!);
                }),
                const SizedBox(height: 20),

                _buildSectionTitle('Descripción del problema'),
                _buildTextField('Describe el problema aquí', maxLines: 5),
                const SizedBox(height: 20),

                _buildSectionTitle('Fotos del vehículo'),
                _buildImagePicker(),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                    ),
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
      ),
    );
  }

  Widget _buildTextField(String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            checkColor: Colors.white,
            activeColor: Colors.green,
          ),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildImagePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (index) {
        return Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.image, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text('Foto ${index + 1}', style: const TextStyle(color: Colors.white)),
          ],
        );
      }),
    );
  }
}