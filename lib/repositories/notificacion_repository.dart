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

  // Obtener notificaciones por categoría
  static Future<List<Notificacion>> getPorCategoria(String categoria) async {
    var result = await DBConnection.filter(tableName, 'categoria = ?', [
      categoria,
    ]);

    if (result.isEmpty) {
      return List.empty();
    } else {
      return List.generate(
        result.length,
        (index) => Notificacion.fromMap(result[index]),
      );
    }
  }

  // Obtener notificaciones por prioridad
  static Future<List<Notificacion>> getPorPrioridad(String prioridad) async {
    var result = await DBConnection.filter(tableName, 'prioridad = ?', [
      prioridad,
    ]);

    if (result.isEmpty) {
      return List.empty();
    } else {
      return List.generate(
        result.length,
        (index) => Notificacion.fromMap(result[index]),
      );
    }
  }

  // Obtener notificaciones por fecha específica
  static Future<List<Notificacion>> getPorFecha(DateTime fecha) async {
    String fechaStr =
        fecha.toIso8601String().split('T')[0]; // Solo la fecha (YYYY-MM-DD)

    var result = await DBConnection.filter(tableName, 'fecha = ?', [fechaStr]);

    if (result.isEmpty) {
      return List.empty();
    } else {
      return List.generate(
        result.length,
        (index) => Notificacion.fromMap(result[index]),
      );
    }
  }

  // Obtener notificaciones por prioridad alta (urgentes)
  static Future<List<Notificacion>> getUrgentes() async {
    var result = await DBConnection.filter(tableName, 'prioridad = ?', [
      'alta',
    ]);

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
