import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBConnection {
  static const version = 1;
  static const dbName = 'agenda_academica_clean.db';

  static Future<Database> _createDatabase(String path, int version) async {
    return await openDatabase(
      path,
      version: version,
      onCreate: (db, version) {
        return _onCreate(db, version);
      },
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    // Crear tabla de periodos académicos
    await db.execute('''
      CREATE TABLE periodo_academico(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        fecha_inicio TEXT NOT NULL,
        fecha_fin TEXT NOT NULL,
        estado TEXT NOT NULL
      )
    ''');

    // Crear tabla de notificaciones - ESTRUCTURA LIMPIA
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

    // Crear tabla de materias
    await db.execute('''
      CREATE TABLE materia(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        codigo INTEGER NOT NULL,
        descripcion TEXT NOT NULL,
        horas INTEGER NOT NULL,
        semestre TEXT NOT NULL
      )
    ''');

    // Crear tabla de tareas
    await db.execute('''
      CREATE TABLE tareas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tema TEXT,
        materiaid TEXT,
        descripcion TEXT,
        fechaentrega TEXT,
        horaentrega TEXT,
        estado INTEGER
      )
    ''');
  }

  static Future<Database> getDb() async {
    final path = join(await getDatabasesPath(), dbName);
    return _createDatabase(path, version);
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
    // obtener la configuracion de la base de datos
    final db = await getDb();
    return db.update(
      tableName,
      data,
      where: 'id = ?',
      whereArgs: [id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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
