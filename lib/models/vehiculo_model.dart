class Vehiculo {
  final String id;
  final String clienteId;
  final String nombreCliente;
  final String placa;
  final String marca;
  final String modelo;
  final String anio;
  final String estado;

  Vehiculo({
    required this.id,
    required this.clienteId,
    required this.nombreCliente,
    required this.placa,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.estado,
  });

  factory Vehiculo.fromMap(String id, Map<String, dynamic> data) {
    return Vehiculo(
      id: id,
      clienteId: data['clienteId'] ?? '',
      nombreCliente: data['nombreCliente'] ?? '',
      placa: data['placa'] ?? '',
      marca: data['marca'] ?? '',
      modelo: data['modelo'] ?? '',
      anio: data['anio'] ?? '',
      estado: data['estado'] ?? 'ingresado',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'clienteId': clienteId,
      'nombreCliente': nombreCliente,
      'placa': placa,
      'marca': marca,
      'modelo': modelo,
      'anio': anio,
      'estado': estado,
    };
  }
}
