import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Future<sql.Database> _database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'moods.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_moods(datetime TEXT PRIMARY KEY, mood TEXT, image TEXT,activityImage TEXT, activityName TEXT,date TEXT)');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper._database();
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("Data saved in DB");
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper._database();
    var res = await db.rawQuery("SELECT * FROM $table");
    return res.toList();
  }

  static Future<void> delete(String datetime) async {
    final db = await DBHelper._database();
    await db.rawDelete('DELETE FROM user_moods WHERE datetime = ?', [datetime]);
  }
}
