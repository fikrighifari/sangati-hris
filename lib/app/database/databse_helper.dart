// ignore_for_file: depend_on_referenced_packages, prefer_is_empty, unused_local_variable, unnecessary_new

import 'dart:io';

import 'package:path/path.dart';
import 'package:sangati/app/models/absensi_offline_model.dart';
import 'package:sangati/app/models/home_model.dart';
import 'package:sangati/app/models/profile_model.dart';
import 'package:sangati/app/models/shift_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "sangatihris.db";
  static const _databaseVersion = 1;

  static const tableUser = 'users';
  static const tableShift = 'shift';
  static const tableCategory = 'category';
  static const tableAttendOnday = 'attendOnday';
  static const tableAbsensi = 'absensi';

  static const columnId = 'id';
  static const columnUser = 'user';
  static const columnPassword = 'password';
  static const columnModelData = 'model_data';
  static const columnFullName = 'fullName';
  static const columnPhone = 'phone';
  static const columnEmail = 'email';
  static const columnCompanyId = 'companyId';
  static const columnCompanyName = 'companyName';
  static const columnDeptId = 'deptId';
  static const columnDeptName = 'deptName';
  static const columnPlacementCode = 'placementCode';
  static const columnPlacementName = 'placementName';
  static const columnFotoUrl = 'fotoUrl';
  static const columnStatusAccountId = 'statusAccountId';
  static const columnStatusAccountName = 'statusAccountName';
  static const columnStatusVerifId = 'statusVerifId';
  static const columnStatusVerifName = 'statusVerifName';

  static const columnShiftIn = 'shiftIn';
  static const columnShiftOut = 'shiftOut';
  static const columnDiffHour = 'diffHour';
  static const columnRadius = 'radius';
  static const columnInLat = 'inLat';
  static const columnInLong = 'inLong';
  static const columnOutLat = 'outLat';
  static const columnOutLong = 'outLong';
  static const columnTanggal = 'tanggal';
  static const columnTime = 'waktu';
  static const columnSlug = 'slug';
  static const columnStatus = 'status';
  static const columnIcon = 'icon';
  static const columnName = 'name';

  static const columnDayDate = 'dayDate';
  static const columnStatusAbsen = 'statusAbsen';
  static const columnTimeIn = 'timeIn';
  static const columnTimeOut = 'timeOut';
  static const columnNamelate = 'late';
  static const columnEarly = 'early';
  static const columnAbsent = 'absent';
  static const columntotalAttendance = 'totalAttendance';
  static const columnKeterangan = 'keterangan';
  static const columnUid = 'uid';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static late Database _database;

  Future<Database> get database async {
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableUser (
             $columnUid INTEGER,
            $columnFullName TEXT,
            $columnPhone INTEGER,
            $columnEmail TEXT,
            $columnCompanyId INTEGER,
            $columnCompanyName TEXT,
            $columnDeptId INTEGER,
            $columnDeptName TEXT,
            $columnPlacementCode TEXT,
            $columnPlacementName TEXT,
            $columnFotoUrl TEXT,
            $columnStatusAccountId INTEGER,
            $columnStatusAccountName TEXT,
            $columnStatusVerifId INTEGER,
            $columnStatusVerifName TEXT,
            $columnModelData TEXT
            
          )
          ''');
    await db.execute('''
          CREATE TABLE $tableShift (
            $columnShiftIn TEXT NOT NULL,
            $columnShiftOut TEXT NOT NULL,
            $columnDiffHour TEXT NOT NULL,
            $columnRadius TEXT NOT NULL,
            $columnInLat TEXT NOT NULL,
            $columnInLong TEXT NOT NULL,
            $columnOutLat TEXT NOT NULL,
            $columnOutLong TEXT NOT NULL
            
          )
          ''');
    await db.execute('''
          CREATE TABLE $tableCategory (
            $columnId INTEGER,
            $columnName TEXT NOT NULL,
            $columnSlug TEXT NOT NULL,
            $columnStatus INTEGER,
            $columnIcon TEXT NOT NULL

          )
          ''');
    await db.execute('''
          CREATE TABLE $tableAttendOnday (
            $columnDayDate TEXT NOT NULL,
            $columnStatusAbsen INTEGER,
            $columnTimeIn TEXT,
            $columnTimeOut TEXT,
            $columnNamelate TEXT,
            $columnEarly TEXT,
            $columnAbsent TEXT,
            $columntotalAttendance TEXT

          )
          ''');

    await db.execute('''
          CREATE TABLE $tableAbsensi (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnDayDate TEXT NOT NULL,
            $columnStatusAbsen INTEGER,
            $columnTime TEXT,
            $columnInLat TEXT,
            $columnInLong TEXT,
            $columnFotoUrl TEXT,
            $columnStatus INTEGER,
            $columnKeterangan TEXT

          )
          ''');
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

  Future<int> insertProfileUser(DataProfile user) async {
    Database db = await instance.database;
    int resUser = await db.insert(tableUser, user.toMap());
    return resUser;
  }

  // Future<int> insertShift(ShiftData shiftData) async {
  //   Database db = await instance.database;
  //   int resShift = await db.insert(tableShift, shiftData.toMap());
  //   return resShift;
  // }

  Future<dynamic> insertShift(List<ShiftData> shiftData) async {
    Database db = await instance.database;
    // int resCategory = await db.insert(tableCategory, categoryMenu.toMap());
    var list = [];
    for (var element in shiftData) {
      // print("asasasas " + jsonEncode(element));
      list.add(await db.insert(tableShift, element.toMap()));
    }

    return list;
  }

  Future<int> insertCategory(
      List<Category> categoryMenu, AttendOnday attendOnday) async {
    Database db = await instance.database;
    // int resCategory = await db.insert(tableCategory, categoryMenu.toMap());
    var list = [];
    for (var element in categoryMenu) {
      // print("asasasas " + jsonEncode(element));
      list.add(await db.insert(tableCategory, element.toMap()));
    }
    int resShift = await db.insert(tableAttendOnday, attendOnday.toMap());

    return resShift;
  }

  // Future<int> deleteSingleUser(int id) async {
  //   var dbClient = await db;
  //   Future<int> res =
  //       dbClient.delete("User", where: '"id" = ?', whereArgs: [id]);
  //   return res;
  // }
  // Future<int> insertAbsensi(AbsensiOffline absensiOffline) async {
  //   Database db = await instance.database;
  //   int absensiOff = await db.insert(tableAbsensi, absensiOffline.toMap());
  //   return absensiOff;
  // }

  Future<int> updateAttendOnday(
      AttendOnday attendOnday, AbsensiOffline absensiOffline) async {
    Database db = await instance.database;
    int resShift = await db.update(tableAttendOnday, attendOnday.toMap());
    int absensiOff = await db.insert(tableAbsensi, absensiOffline.toMap());

    return absensiOff;
  }

  Future<int> updateAttendOndayOnli(AttendOnday attendOnday) async {
    Database db = await instance.database;
    int resShift = await db.update(tableAttendOnday, attendOnday.toMap());

    return resShift;
  }

  Future<int> updateProfile(List? faceData, int uid) async {
    Database db = await instance.database;
    // int resShift = await db.update(tableUser, dataProfile.toMap());
    int resShift = await db.rawUpdate(
        'UPDATE users SET model_data = ? WHERE uid = ?', [faceData, uid]);
    return resShift;
  }

  Future<int> deleteAbsensiOffline(int id) async {
    Database db = await instance.database;
    int absensiOffDell =
        await db.delete(tableAbsensi, where: '"id" = ?', whereArgs: [id]);
    return absensiOffDell;
  }

  // Future<List<DataProfile>> queryAllUsers() async {
  //   Database db = await instance.database;
  //   final data = await db.query(tableUser);
  //   List<DataProfile> result = data.map((e) => DataProfile.fromMap(e)).toList();
  //   return result;
  // }

  Future<DataProfile> gelUserData() async {
    Database db = await instance.database;

    List<Map<String, dynamic>> res = await db.query(tableUser);
    for (var row in res) {
      //print(row['id']);
      return new Future<DataProfile>.value(DataProfile.fromMap(row));
    }
    return new Future<DataProfile>.error("Unable to find User");
  }

  Future<List<ShiftData>?> getShiftData() async {
    Database db = await instance.database;
    final data = await db.query(tableShift);
    List<ShiftData> result = data.map((e) => ShiftData.fromMap(e)).toList();
    return result;
    // List<Map<String, dynamic>> res = await db.query(tableShift);
    // for (var row in res) {
    //   return new Future<ShiftData>.value(ShiftData.fromMap(row));
    // }
    // return new Future<ShiftData>.error("Unable to find User");
  }

  Future<List<Category>?> getCategory() async {
    Database db = await instance.database;
    final data = await db.query(tableCategory);
    List<Category> result = data.map((e) => Category.fromMap(e)).toList();
    return result;
  }

  Future<AttendOnday> getAttendOnday() async {
    Database db = await instance.database;

    List<Map<String, dynamic>> res = await db.query(tableAttendOnday);
    for (var row in res) {
      //print(row['id']);
      return new Future<AttendOnday>.value(AttendOnday.fromMap(row));
    }
    return new Future<AttendOnday>.error("Unable to find User");
  }

  Future<List<AbsensiOffline>?> getAbsensi() async {
    Database db = await instance.database;
    final data = await db.query(tableAbsensi);
    List<AbsensiOffline> result =
        data.map((e) => AbsensiOffline.fromMap(e)).toList();
    return result;
  }

  Future<int> deleteAll() async {
    Database db = await instance.database;
    int tableUser1 = await db.delete(tableUser);
    int tableShift1 = await db.delete(tableShift);

    return tableShift1;
  }

  Future<int> deleteTableUser() async {
    Database db = await instance.database;
    return await db.delete(tableUser);
  }

  Future<int> deleteTableShift() async {
    Database db = await instance.database;
    return await db.delete(tableShift);
  }

  Future<int> deleteTableCategory() async {
    Database db = await instance.database;
    int dellCategory = await db.delete(tableCategory);
    int dellAttendOnday = await db.delete(tableAttendOnday);
    return dellAttendOnday;
  }
}
