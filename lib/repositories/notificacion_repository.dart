import '../entities/notificacion_entity.dart';
import '../settings/db_connection.dart';

class NotificacionRepository {
  static String tableName = "notificacion";
  
  // Insertar una nueva notificación
  static Future<int> insert(Notificacion notificacion) async {
    return await DBConnection.insert(tableName, notificacion.toMap());
  }

  // Actualizar una notificación existente
  static Future<int> update(Notificacion notificacion) async {
    return await DBConnection.update(
      tableName,
      notificacion.toMap(),
      notificacion.id as int,
    );
  }

  // Eliminar una notificación
  static Future<int> delete(Notificacion notificacion) async {
    return await DBConnection.delete(tableName, notificacion.id as int);
  }

  // Obtener todas las notificaciones
  static Future<List<Notificacion>> list() async {
    var result = await DBConnection.list(tableName);
    if (result.isEmpty) {
      return List.empty();
    } else {
      return List.generate(
        result.length,
        (index) => Notificacion.fromMap(result[index]),
      );
    }
  }

  // Obtener notificaciones por asignatura
  static Future<List<Notificacion>> getPorAsignatura(String asignatura) async {
    var result = await DBConnection.filter(
      tableName,
      'asignatura = ?',
      [asignatura],
    );
    
    if (result.isEmpty) {
      return List.empty();
    } else {
      return List.generate(
        result.length,
        (index) => Notificacion.fromMap(result[index]),
      );
    }
  }
}
