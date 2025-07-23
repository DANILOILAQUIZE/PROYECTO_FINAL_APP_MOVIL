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
    print('=== DEBUG: Notificacion.toMap() ===');
    print('Fecha original: $fecha');
    print('Tipo de fecha: ${fecha.runtimeType}');
    final fechaStr = fecha.toIso8601String().split('T')[0]; // Solo la fecha (YYYY-MM-DD)
    print('Fecha formateada: $fechaStr');
    
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'prioridad': prioridad,
      'categoria': categoria,
      'fecha': fechaStr,
    };
  }

  // Crea una instancia de Notificacion a partir de un mapa
  factory Notificacion.fromMap(Map<String, dynamic> data) {
    print('=== DEBUG: Notificacion.fromMap() ===');
    print('Datos recibidos: $data');
    
    final fechaStr = data['fecha'] + 'T00:00:00';
    print('Fecha a parsear: $fechaStr');
    
    final fecha = DateTime.parse(fechaStr);
    print('Fecha parseada: $fecha');
    print('Tipo de fecha: ${fecha.runtimeType}');
    
    return Notificacion(
      id: data['id'],
      titulo: data['titulo'],
      descripcion: data['descripcion'],
      prioridad: data['prioridad'] ?? 'media',
      categoria: data['categoria'] ?? 'trabajo',
      fecha: fecha,
    );
  }
}
