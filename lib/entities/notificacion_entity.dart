class Notificacion {
  int? id;
  String titulo;
  String descripcion;
  DateTime fechaHora;
  String asignatura; // Nombre de la asignatura relacionada
  String tipo; // Ejemplo: 'tarea', 'recordatorio', 'importante', etc.

  Notificacion({
    this.id,
    required this.titulo,
    required this.descripcion,
    required this.fechaHora,
    required this.asignatura,
    required this.tipo,
  });

  // Convierte la instancia de Notificacion en un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'fechaHora': fechaHora.toIso8601String(),
      'asignatura': asignatura,
      'tipo': tipo,
    };
  }

  // Crea una instancia de Notificacion a partir de un mapa
  factory Notificacion.fromMap(Map<String, dynamic> data) {
    return Notificacion(
      id: data['id'],
      titulo: data['titulo'],
      descripcion: data['descripcion'],
      fechaHora: DateTime.parse(data['fechaHora']),
      asignatura: data['asignatura'] ?? '',
      tipo: data['tipo'],
    );
  }
}
