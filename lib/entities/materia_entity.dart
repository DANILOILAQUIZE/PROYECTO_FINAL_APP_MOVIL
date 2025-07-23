class MateriaEntity {
  int? id;
  String nombre;
  int codigo;
  String descripcion;
  int horas;
  String semestre;
  int fkPeriodoId;

  MateriaEntity({
    this.id,
    required this.nombre,
    required this.codigo,
    required this.descripcion,
    required this.horas,
    required this.semestre,
    required this.fkPeriodoId,
  });

  factory MateriaEntity.fromMap(Map<String, dynamic> map) {
    return MateriaEntity(
      id: map['id'],
      nombre: map['nombre'],
      codigo: map['codigo'],
      descripcion: map['descripcion'],
      horas: map['horas'],
      semestre: map['semestre'],
      fkPeriodoId: map['fk_periodo_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'codigo': codigo,
      'descripcion': descripcion,
      'horas': horas,
      'semestre': semestre,
      'fk_periodo_id': fkPeriodoId,
    };
  }
}
