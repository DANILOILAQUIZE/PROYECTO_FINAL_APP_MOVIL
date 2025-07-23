import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBConnection {
  static const version =
      3; // Incrementado para reflejar cambios en el esquema (agregar tabla notificaciones)
  static const dbName = 'agenda_academica.db';
  static Future<Database> getDb() async {
    //final dbPath = await getDatabasesPath();

    //final path = join(dbPath, dbName);
    //await deleteDatabase(path);
    final path = join(await getDatabasesPath(), dbName);
    return openDatabase(
      path,
      version: version,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE periodo_academico(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            fechaInicio INTEGER NOT NULL,
            fechaFin INTEGER NOT NULL,
            activo BOOLEAN NOT NULL DEFAULT 0,
            descripcion TEXT
          )
        ''');

        // Crear tabla de materias
        await db.execute('''
            CREATE TABLE materia(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nombre TEXT NOT NULL,
              codigo INTEGER NOT NULL,
              descripcion TEXT NOT NULL,
              horas INTEGER NOT NULL,
              semestre TEXT NOT NULL,
              fk_periodo_id INTEGER NOT NULL,
              FOREIGN KEY(fk_periodo_id) REFERENCES periodo_academico(id)
            )
 
        ''');

        // DATOS INICIALES
        final fechaInicio = DateTime(2025, 1, 12); // 12 de enero de 2025
        final fechaFin = DateTime(2025, 6, 26); // 26 de junio de 2025
        await db.insert('periodo_academico', {
          'nombre': '8vo semestre',
          'fechaInicio': fechaInicio.millisecondsSinceEpoch,
          'fechaFin': fechaFin.millisecondsSinceEpoch,
          'activo': 1,
          'descripcion': 'Periodo académico actual',
        });

        await db.insert('materia', {
          'nombre': 'Desarrollo Móvil',
          'codigo': 8001,
          'descripcion': 'Desarrollo de aplicaciones móviles con Flutter',
          'horas': 64,
          'semestre': '8vo Semestre',
          'fk_periodo_id': 1,
        });

        // Crear tabla de notificaciones
        await db.execute('''
          CREATE TABLE notificacion(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL,
            descripcion TEXT NOT NULL,
            prioridad TEXT NOT NULL,
            categoria TEXT NOT NULL,
            fecha TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE tareas(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tema TEXT,
            descripcion TEXT,
            fechaentrega INTEGER,
            horaentrega TEXT,
            estado TEXT,
            fk_materia_id INTEGER NOT NULL,
            FOREIGN KEY(fk_materia_id) REFERENCES materia(id)
          )
        ''');

        final List<Map<String, dynamic>> materias = await db.query('materia');
        final int materiaId = materias.first['id'];
        final fechaentrega = DateTime(2025, 1, 12);

        await db.insert('tareas', {
          'tema': 'Programación',
          'descripcion': 'Lógica de Programación',
          'fechaentrega': fechaentrega.millisecondsSinceEpoch,
          'horaentrega': '10:30',
          'estado': 'Pendiente',
          'fk_materia_id': materiaId,
        });
      },
    );
  }

  static Future<int> insert(String tableName, dynamic data) async {
    // obtener la configuracion de la base de datos
    final db = await getDb();
    return db.insert(
      tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<int> update(String tableName, dynamic data, int id) async {
    final db = await getDb();
    return db.update(tableName, data, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> delete(String tableName, int id) async {
    // obtener la configuracion de la base de datos
    final db = await getDb();
    return db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> list(String tableName) async {
    // obtener la configuracion de la base de datos
    final db = await getDb();
    return db.query(tableName);
  }

  static Future<List<Map<String, dynamic>>> filter(
    String tableName,
    String where,
    dynamic whereArgs,
  ) async {
    // obtener la configuracion de la base de datos
    final db = await getDb();
    return db.query(tableName, where: where, whereArgs: whereArgs);
  }
}
