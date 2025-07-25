import 'package:flutter/material.dart';

class BusquedaScreen extends StatefulWidget {
  const BusquedaScreen({super.key});

  @override
  State<BusquedaScreen> createState() => _BusquedaScreenState();
}

class _BusquedaScreenState extends State<BusquedaScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Búsqueda de vehículos'),
        leading: const Icon(Icons.menu),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text('Nombre del cliente'),
            const SizedBox(height: 5),
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Campo de texto',
              ),
            ),
            const SizedBox(height: 20),
            const Text('Placa del carro'),
            const SizedBox(height: 5),
            TextField(
              controller: _placaController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Campo de texto',
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Acción al presionar "Buscar"
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                ),
                child: const Text('Buscar'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Logo", style: TextStyle(fontWeight: FontWeight.bold)),
              _buildBottomIcon(Icons.add_circle_outline, "Nuevo"),
              _buildBottomIcon(Icons.list, "Listar"),
              _buildBottomIcon(Icons.search, "Buscar"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomIcon(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon),
        Text(label),
      ],
    );
  }
}
