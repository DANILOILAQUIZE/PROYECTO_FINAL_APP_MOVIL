class Tareas {
  int? id;
  String tema;
  String descripcion;
  String fechaentrega;
  String horaentrega;
  int estado;
  int fkMateriaId;

  Tareas({
    this.id,
    required this.tema,
    required this.descripcion,
    required this.fechaentrega,
    required this.horaentrega,
    required this.estado,
    required this.fkMateriaId,
  });
  // transforma de clases a map
  Map<String, dynamic> topMap() {
    return {
      "id": id,
      "tema": tema,
      "descripcion": descripcion,
      "fechaentrega": fechaentrega,
      "horaentrega": horaentrega,
      "estado": estado,
      'fk_materia_id': fkMateriaId,
    };
  }

  //transforma de map  a clases
  factory Tareas.fromMap(Map<String, dynamic> data) {
    return Tareas(
      id: data["id"],
      tema: data["tema"],
      descripcion: data["descripcion"],
      fechaentrega: data["fechaentrega"],
      horaentrega: data["horaentrega"],
      estado: data["estado"],
      fkMateriaId: data['fk_materia_id'],
    );
  }
}
