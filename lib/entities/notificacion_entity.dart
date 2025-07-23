class Notificacion {
  int? id;
  String titulo;
  String descripcion;
  String prioridad; // 'alta', 'importante', 'media', 'baja'
  String categoria; // 'trabajo', 'personal', 'estudio'
  DateTime fecha; // Fecha específica del día

  Notificacion({
    this.id,
    required this.titulo,
    required this.descripcion,
    required this.prioridad,
    required this.categoria,
    required this.fecha,
  });

  // Convierte la instancia de Notificacion en un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'prioridad': prioridad,
      'categoria': categoria,
      'fecha':
          fecha.toIso8601String().split('T')[0], // Solo la fecha (YYYY-MM-DD)
    };
  }

  // Crea una instancia de Notificacion a partir de un mapa
  factory Notificacion.fromMap(Map<String, dynamic> data) {
    return Notificacion(
      id: data['id'],
      titulo: data['titulo'],
      descripcion: data['descripcion'],
      prioridad: data['prioridad'] ?? 'media',
      categoria: data['categoria'] ?? 'trabajo',
      fecha: DateTime.parse(
        data['fecha'] + 'T00:00:00',
      ), // Convertir a DateTime
    );
  }
}
