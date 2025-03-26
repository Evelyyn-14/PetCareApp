import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static Future<void> createTables(sql.Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS pets (
        id INTEGER PRIMARY KEY,
        name TEXT,
        age REAL,
        gender TEXT,
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS feedings (
        id INTEGER PRIMARY KEY,
        pet_id INTEGER,
        date TEXT,
        time TEXT,
        food TEXT,
        amount REAL,
        unit TEXT,
        FOREIGN KEY (pet_id) REFERENCES pets(id)
      )
    ''');
  }

  static Future<sql.Database> database() async {

    return sql. openDatabase(
      'database',
      version:1,
      onCreate: (sql.Database db, int version) async {
        await createTables(db);
      },
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DatabaseHelper.database();
    await db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    final db = await DatabaseHelper.database();
    return db.query(table);
  }

  static Future<void> delete(String table, int id) async {
    final db = await DatabaseHelper.database();
    await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> update(String table, Map<String, Object> data) async {
    final db = await DatabaseHelper.database();
    await db.update(table, data, where: 'id = ?', whereArgs: [data['id']]);
  }

  Future<void> init() async {
    final db = await DatabaseHelper.database();
    await createTables(db);
  }
}