import '../entities/materia_entity.dart';
import '../settings/db_connection.dart';

class MateriaRepository {
  static String tableName = "materia";

  static Future<int> insert(MateriaEntity materia) async {
    return await DBConnection.insert(tableName, materia.toMap());
  }

  static Future<int> update(MateriaEntity materia) async {
    return await DBConnection.update(tableName, materia.toMap(), materia.id!);
  }

  static Future<int> delete(MateriaEntity materia) async {
    return await DBConnection.delete(tableName, materia.id!);
  }

  static Future<List<MateriaEntity>> list() async {
    final result = await DBConnection.list(tableName);
    return result.map((item) => MateriaEntity.fromMap(item)).toList();
  }

  static Future<MateriaEntity?> getById(int id) async {
    final result = await DBConnection.filter(tableName, 'id = ?', [id]);
    if (result.isNotEmpty) {
      return MateriaEntity.fromMap(result.first);
    }
    return null;
  }

  static Future<List<MateriaEntity>> getByPeriodoId(int periodoId) async {
    final result = await DBConnection.filter(tableName, 'fk_periodo_id = ?', [
      periodoId,
    ]);
    return result.map((item) => MateriaEntity.fromMap(item)).toList();
  }
}
