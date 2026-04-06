class Paciente {
  final int? id;
  final String nombre;
  final String dni;
  final int edad;
  final String telefono;

  Paciente({
    this.id,
    required this.nombre,
    required this.dni,
    required this.edad,
    required this.telefono,
  });

  factory Paciente.fromMap(Map<String, dynamic> map) {
    return Paciente(
      id: map['id'],
      nombre: map['nombre'],
      dni: map['dni'],
      edad: map['edad'],
      telefono: map['telefono'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'dni': dni,
      'edad': edad,
      'telefono': telefono,
    };
  }
}