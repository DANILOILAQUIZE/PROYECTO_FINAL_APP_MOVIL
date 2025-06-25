class Tareas {
  int? id;
  String tema;
  String materiaid;
  String descripcion;
  String fechaentrega;
  String horaentrega;
  int estado;

  Tareas({
    this.id,
    required this.tema,
    required this.materiaid,
    required this.descripcion,
    required this.fechaentrega,
    required this.horaentrega,
    required this.estado,
  });
  // transforma de clases a map
  Map<String, dynamic> topMap() {
    return {
      "id": id,
      "tema": tema,
      "materiaid": materiaid,
      "descripcion": descripcion,
      "fechaentrega": fechaentrega,
      "horaentrega": horaentrega,
      "estado": estado,
    };
  }

  //transforma de map  a clases
  factory Tareas.fromMap(Map<String, dynamic> data) {
    return Tareas(
      id: data["id"],
      tema: data["tema"],
      materiaid: data["materiaid"],
      descripcion: data["descripcion"],
      fechaentrega: data["fechaentrega"],
      horaentrega: data["horaentrega"],
      estado: data["estado"],
      
    );
  }
}
