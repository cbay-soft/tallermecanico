class Cliente {
  final String id;
  final String nombre;
  final String cedula;
  final String correo;
  final String telefono;

  Cliente({required this.id, required this.nombre, required this.cedula, required this.correo, required this.telefono});

  factory Cliente.fromMap(String id, Map<String, dynamic> data) {
    return Cliente(
      id: id,
      nombre: data['nombre'] ?? '',
      cedula: data['cedula'] ?? '',
      correo: data['correo'] ?? '',
      telefono: data['telefono'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'cedula': cedula,
      'correo': correo,
      'telefono': telefono,
    };
  }
}