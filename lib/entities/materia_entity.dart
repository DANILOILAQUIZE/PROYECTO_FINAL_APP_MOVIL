class Materia {
  int? id;
  String nombre;
  int codigo;
  String descripcion;
  int horas;
  String semestre;

  Materia({
    this.id,
    required this.nombre,
    required this.codigo,
    required this.descripcion,
    required this.horas,
    required this.semestre,
  });

  // Convierte la instancia de Materia en un mapa (útil para bases de datos o APIs)
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nombre": nombre,
      "codigo": codigo,
      "descripcion": descripcion,
      "horas": horas,
      "semestre": semestre,
    };
  }

  // Crea una instancia de Materia a partir de un mapa
  factory Materia.fromMap(Map<String, dynamic> data) {
    return Materia(
      id: data["id"],
      nombre: data["nombre"],
      codigo: data["codigo"],
      descripcion: data["descripcion"],
      horas: data["horas"],
      semestre: data["semestre"],
    );
  }
}
