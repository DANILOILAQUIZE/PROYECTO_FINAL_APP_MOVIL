import '../entities/periodo_entity.dart';
import '../settings/db_connection.dart';

class PeriodoRepository {
  static String tableName = 'periodo_academico';

  static Future<int> insert(PeriodoEntity periodo) async {
    return await DBConnection.insert(tableName, periodo.toMap());
  }

  static Future<List<PeriodoEntity>> list() async {
    var result = await DBConnection.list(tableName);
    if (result.isEmpty) {
      return List.empty();
    } else {
      return List.generate(
        result.length,
        (index) => PeriodoEntity.fromMap(result[index]),
      );
    }
  }

  static Future<int> update(PeriodoEntity periodo) async {
    return await DBConnection.update(
      tableName,
      periodo.toMap(),
      periodo.id as int,
    );
  }

  static Future<int> delete(PeriodoEntity periodo) async {
    return await DBConnection.delete(tableName, periodo.id as int);
  }
}
