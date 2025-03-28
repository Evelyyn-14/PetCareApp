import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static DatabaseHelper get instance => _instance;
  static sql.Database? _database;

  DatabaseHelper._internal();

  //opens the database
  Future<sql.Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  //initializes the database
  Future<sql.Database> _initDatabase() async {
    String path = join(await sql.getDatabasesPath(), 'profile.db');
    return await sql.openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await createTables(db); // Ensure all tables are created
      },
    );
  }

  //saves the profile information to the database
  Future<void> saveProfile(Map<String, dynamic> profile) async {
    final db = await database;
    await db.insert(
      'profile',
      {'id': 1, 'nightMode': profile['nightMode'] ? 1 : 0},
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  //gets the profile information from the database
  Future<Map<String, dynamic>?> getProfile() async {
    final db = await database;
    final result = await db.query('profile', where: 'id = ?', whereArgs: [1]);
    if (result.isNotEmpty) {
      return {
        'nightMode': result.first['nightMode'] == 1,
      };
    }
    return null;
  }

  //creates the tables
  static Future<void> createTables(sql.Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS pets (
        id INTEGER PRIMARY KEY,
        name TEXT,
        age REAL,
        gender TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS feedings (
        id INTEGER PRIMARY KEY,
        pet_id INTEGER,
        date TEXT,
        time TEXT,
        food TEXT,
        type TEXT, -- Added 'type' column
        amount REAL,
        unit TEXT,
        FOREIGN KEY (pet_id) REFERENCES pets(id)
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS reminders (
        id INTEGER PRIMARY KEY,
        pet_id INTEGER,
        date TEXT,
        time TEXT,
        title TEXT,
        description TEXT,
        FOREIGN KEY (pet_id) REFERENCES pets(id)
      )
    '''); 
  }

  //gets the profile information by id
  static Future<sql.Database> getStaticDatabase() async {
    return sql.openDatabase(
      'database',
      version: 1,
      onCreate: (sql.Database db, int version) async {
        await createTables(db);
      },
    );
  }

  //inserts data into the database
  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  //queries all rows from the database
  static Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    final db = await DatabaseHelper.instance.database;
    return db.query(table);
  }

  //deletes data from the database
  static Future<void> delete(String table, int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  //updates data in the database
  static Future<void> update(String table, Map<String, Object> data) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(table, data, where: 'id = ?', whereArgs: [data['id']]);
  }

  //gets the profile information by id
  static Future<Map<String, dynamic>?> getProfileById(int id) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query('pets', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  //gets the feedings by pet id
  static Future<List<Map<String, dynamic>>> getFeedingsByPetId(int petId) async {
    final db = await DatabaseHelper.instance.database;
    return db.query('feedings', where: 'pet_id = ?', whereArgs: [petId]);
  }

  //insert feeding logs into the feedings table
  static Future<void> insertFeedingLog(Map<String, Object> feedingLog) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert(
      'feedings',
      feedingLog,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  //deletes feeding log by its ID
  static Future<void> deleteFeedingLog(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(
      'feedings',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //updates feeding log
  static Future<void> updateFeedingLog(Map<String, Object> feedingLog) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'feedings',
      feedingLog,
      where: 'id = ?',
      whereArgs: [feedingLog['id']],
    );
  }

  //inserts reminder into the reminders table
  static Future<void> insertReminder(Map<String, Object> reminder) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert(
      'reminders',
      reminder,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  //gets all reminders by pet_id
  static Future<List<Map<String, dynamic>>> getRemindersByPetId(int petId) async {
    final db = await DatabaseHelper.instance.database;
    return db.query(
      'reminders',
      where: 'pet_id = ?',
      whereArgs: [petId],
    );
  }

  //updates a reminder by its ID
  static Future<void> updateReminder(Map<String, Object> reminder) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'reminders',
      reminder,
      where: 'id = ?',
      whereArgs: [reminder['id']],
    );
  }

  //deletes a reminder by its ID
  static Future<void> deleteReminder(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(
      'reminders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //initializes the database
  Future<void> init() async {
    final db = await DatabaseHelper.instance.database;
    await createTables(db);
  }
}