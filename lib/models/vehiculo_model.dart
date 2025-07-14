class Vehiculo {
  final String id;
  final String clienteId;
  final String placa;
  final String marca;
  final String modelo;
  final String estado;

  Vehiculo({
    required this.id,
    required this.clienteId,
    required this.placa,
    required this.marca,
    required this.modelo,
    required this.estado,
  });

  factory Vehiculo.fromMap(String id, Map<String, dynamic> data) {
    return Vehiculo(
      id: id,
      clienteId: data['clienteId'] ?? '',
      placa: data['placa'] ?? '',
      marca: data['marca'] ?? '',
      modelo: data['modelo'] ?? '',
      estado: data['estado'] ?? 'pendiente',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'clienteId': clienteId,
      'placa': placa,
      'marca': marca,
      'modelo': modelo,
      'estado': estado,
    };
  }
}
