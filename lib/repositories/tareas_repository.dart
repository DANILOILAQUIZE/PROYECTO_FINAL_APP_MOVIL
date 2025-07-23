import '../entities/tareas_entity.dart';
import '../settings/db_connection.dart';

class TareaRepository {
  static String tableName = "tareas";

  static Future<int> insert(Tareas tareas) async {
    return await DBConnection.insert(tableName, tareas.topMap());
  }

  static Future<int> update(Tareas tareas) async {
    return await DBConnection.update(
      tableName,
      tareas.topMap(),
      tareas.id as int,
    );
  }

  static Future<int> delete(Tareas tareas) async {
    return await DBConnection.delete(tableName, tareas.id as int);
  }

  static Future<List<Tareas>> list() async {
    var result = await DBConnection.list(tableName);
    if (result.isEmpty) {
      return List.empty();
    } else {
      return List.generate(
        result.length,
        (index) => Tareas.fromMap(result[index]),
      );
    }
  }

  static Future<Tareas?> getById(int id) async {
    final result = await DBConnection.filter(tableName, 'id = ?', [id]);
    if (result.isNotEmpty) {
      return Tareas.fromMap(result.first);
    }
    return null;
  }

  static Future<List<Tareas>> getByMateriaId(int materiaId) async {
    final result = await DBConnection.filter(tableName, 'fk_materia_id = ?', [
      materiaId,
    ]);
    return result.map((item) => Tareas.fromMap(item)).toList();
  }
}
