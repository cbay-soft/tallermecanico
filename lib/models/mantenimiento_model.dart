class Mantenimiento {
  final String id;
  final String vehiculoId;
  final String observaciones;
  final List<String> fotos;
  final String estado;

  Mantenimiento({
    required this.id,
    required this.vehiculoId,
    required this.observaciones,
    required this.fotos,
    required this.estado,
  });

  factory Mantenimiento.fromMap(String id, Map<String, dynamic> data) {
    return Mantenimiento(
      id: id,
      vehiculoId: data['vehiculoId'] ?? '',
      observaciones: data['observaciones'] ?? '',
      fotos: List<String>.from(data['fotos'] ?? []),
      estado: data['estado'] ?? 'pendiente',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vehiculoId': vehiculoId,
      'observaciones': observaciones,
      'fotos': fotos,
      'estado': estado,
    };
  }
}
