import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:intermediate_flutter/model/response/login_result.dart';

class DatabaseRepository {
  late Database _database;

  Future<Database> get database async {
    _database = await _initDb();
    return _database;
  }

  Future<Database> _initDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/story.db',
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE userToken (
        userId STRING PRIMARY KEY,
        name TEXT,
        token TEXT
      )''');
      },
      version: 1,
    );
    return db;
  }

  Future<void> insertToDB(Map<String, dynamic> data) async {
    var db = await database;
    await db.insert(
      'userToken',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete() async {
    var db = await database;
    await db.delete('userToken');
  }

  Future<bool> isLoggedIn() async {
    var db = await database;
    var result = await db.query('userToken');
    return result.isNotEmpty;
  }

  Future<LoginResult> getUserToken() async {
    var db = await database;
    var result = await db.query('userToken');
    return LoginResult.fromJson(result.first);
  }
}
