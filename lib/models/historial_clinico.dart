class Consulta {
  final String fecha;
  final String motivo;
  final String diagnostico;

  Consulta({
    required this.fecha,
    required this.motivo,
    required this.diagnostico,
  });

  factory Consulta.fromJson(Map<String, dynamic> json) => Consulta(
        fecha: json['fecha'] ?? '',
        motivo: json['motivo'] ?? '',
        diagnostico: json['diagnostico'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'fecha': fecha,
        'motivo': motivo,
        'diagnostico': diagnostico,
      };
}

class HistorialClinico {
  final String? id;
  final String pacienteId;
  final String nombrePaciente;
  final List<Consulta> consultas;

  HistorialClinico({
    this.id,
    required this.pacienteId,
    required this.nombrePaciente,
    required this.consultas,
  });

  factory HistorialClinico.fromJson(Map<String, dynamic> json) {
    return HistorialClinico(
      id: json['_id']?['\$oid'] ?? json['_id'],
      pacienteId: json['pacienteId'] ?? '',
      nombrePaciente: json['nombrePaciente'] ?? '',
      consultas: (json['consultas'] as List<dynamic>? ?? [])
          .map((c) => Consulta.fromJson(c))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'pacienteId': pacienteId,
        'nombrePaciente': nombrePaciente,
        'consultas': consultas.map((c) => c.toJson()).toList(),
      };
}