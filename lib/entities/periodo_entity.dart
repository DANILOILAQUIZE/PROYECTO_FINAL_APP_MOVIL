class PeriodoEntity {
  int? id;
  String nombre;
  int fechaInicio;
  int fechaFin;
  bool activo;
  String? descripcion;

  PeriodoEntity({
    this.id,
    required this.nombre,
    required this.fechaInicio,
    required this.fechaFin,
    required this.activo,
    this.descripcion,
  });

  // Convertir el objeto a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'fechaInicio': fechaInicio,
      'fechaFin': fechaFin,
      'activo': activo ? 1 : 0,
      'descripcion': descripcion,
    };
  }

  // Convertir el mapa a un objeto
  factory PeriodoEntity.fromMap(Map<String, dynamic> data) {
    return PeriodoEntity(
      id: data['id'],
      nombre: data['nombre'],
      fechaInicio: data['fechaInicio'],
      fechaFin: data['fechaFin'],
      activo: data['activo'] == 1,
      descripcion: data['descripcion'],
    );
  }
}