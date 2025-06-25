import '../entities/materia_entity.dart';
import '../settings/db_connection.dart';

class MateriaRepository {
  static String tableName = "materia";
  static Future<int> insert(Materia materia) async {
    return await DBConnection.insert(tableName, materia.toMap());
  }

  static Future<int> update(Materia materia) async {
    return await DBConnection.update(
      tableName,
      materia.toMap(),
      materia.id as int,
    );
  }

  static Future<int> delete(Materia materia) async {
    return await DBConnection.delete(tableName, materia.id as int);
  }

  static Future<List<Materia>> list() async {
    var result = await DBConnection.list(tableName);
    if (result.isEmpty) {
      return List.empty();
    } else {
      return List.generate(
        result.length,
        (index) => Materia.fromMap(result[index]),
      );
    }
  }
}
