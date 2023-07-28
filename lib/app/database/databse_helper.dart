// ignore_for_file: unused_element

import 'package:sangati/app/models/profile_model.dart';
import 'package:sangati/app/models/shift_model.dart';
import 'package:sangati/app/models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  //static const _databaseName = "sangatihris.db";
  //static const _databaseVersion = 1;

  static const table = 'users';
  static const columnId = 'id';
  static const columnUser = 'user';
  static const columnPassword = 'password';
  static const columnModelData = 'model_data';
  static const tableUser = 'users';
  static const tableShift = 'shift';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static late Database _database;
  Future<Database> get database async {
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    // Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // String path = join(documentsDirectory.path, _databaseName);
    // return await openDatabase(path,
    //     version: _databaseVersion, onCreate: _onCreate);
  }

  Future<int> insertProfile(
      DataProfile user, List<ShiftData>? shiftData) async {
    Database db = await instance.database;
    int resUser = await db.insert(tableUser, user.toMap());
    //int resShift = await db.insert(tableShift, shift.toMap());
    // int res = await dbClient.insert("User", user.toMap());
    var list = [];
    for (var element in shiftData!) {
      // print("asasasas " + jsonEncode(element));
      list.add(await db.insert(tableShift, element.toMap()));
    }
    return resUser;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnUser TEXT NOT NULL,
            $columnPassword TEXT NOT NULL,
            $columnModelData TEXT NOT NULL
          )
          ''');
  }

  Future<int> insert(User user) async {
    Database db = await instance.database;
    return await db.insert(table, user.toMap());
  }

  Future<List<User>> queryAllUsers() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> users = await db.query(table);
    return users.map((u) => User.fromMap(u)).toList();
  }

  Future<int> deleteAll() async {
    Database db = await instance.database;
    return await db.delete(table);
  }
}
