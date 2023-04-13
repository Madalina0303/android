// import 'package:flutter/foundation.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// class UserDB {
//   static final UserDB instance = UserDB._init();
//   static Database? _database;
//   UserDB._init();
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDB('users.db');
//     return _database!;
//   }

//   Future<Database> _initDB(String filePath) async {
//     final dbPath = await getDatabasesPath(); // android data/data/databases
//     final path = join(dbPath, filePath);
//     return await openDatabase(path, version: 1, onCreate: _createDB);
//   }

//   Future _createDB(Database db, int version) async {}
//   Future close() async {
//     final db = await instance.database;
//     db.close();
//   }
// }
import 'package:bloodochallenge/model/model.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:bloodochallenge/model/model_istoric.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DbHelper {
  static Database? _db;

  static const String DB_Name = 'test2.db';
  static const String Table_User = 'user2';
  static const int Version = 2;

  static const String C_UserID = 'user_id';
  static const String C_UserName = 'user_name';
  static const String C_Password = 'password';
  static const String C_Punctaj = 'punctaj';
  static const String Table_istoric = 'istoric2';
  static const String C_Centru = 'centru';
  static const String C_Tip = 'tip';
  static const String C_Data = 'data';
  static const String C_Brat = 'brat';
  Future<Database> get db async {
    print("se intra pe get vreodata ?");
    if (_db != null) {
      print("are ceva de returnat");
      return _db!;
    }
    print("va intra pe init");
    _db = await initDb();
    return _db!;
  }

  initDb() async {
    print("intra pe init");
    // io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // String path = join(documentsDirectory.path, DB_Name);
    //final dbPath = await getDatabasesPath(); // android data/data/databases
    // print("Path ul de la db folder este $dbPath");
    final path = join("D:/invigator/bloodo/DB", DB_Name);
    print("Path ul de la db este $path");
    var db = await openDatabase(path, version: Version, onCreate: _onCreate);
    var isto = await db
        .query('sqlite_master', where: 'name = ?', whereArgs: [Table_istoric]);
    if (isto.length == 0) {
      print("Se va crea istoric ");
      _CreateTableIstoric(db, Version);
      populate_istoric();
    } else {
      // populate_db();
      print("hai nu mi spune ca e ceva variabila aia, $isto ??");
    }
    // print("Se creeaza vreodata baza de date ?");
    return db;
  }

  _onCreate(Database db, int intVersion) async {
    await db.execute("CREATE TABLE $Table_User ("
        " $C_UserID INTEGER, "
        " $C_UserName TEXT, "
        " $C_Password TEXT, "
        " $C_Punctaj INTEGER, "
        " PRIMARY KEY ($C_UserID)"
        ")");
  }

  // _onOpen() {
  //   print("Baza de date exista, deja ");
  // }

  //Future<Map<String, int>>
  Future<List<Map<String, Object?>>> clasament() async {
    var dbClient = await db;
    var mp = Map<String, int>();
    var res = await dbClient.rawQuery(
        "SELECT $C_UserName, $C_Punctaj FROM $Table_User ORDER BY $C_Punctaj DESC");

    print("Uite rezultatul $res");
    // if (res.length > 0) {
    //   for (var i = 0; i < res.length; i++) {
    //     mp[res[i]['user_name'] as String] = res[i]['punctaj'] as int;
    //   }
    // }
    return res;
  }

  Future<int> saveData(UserModel user) async {
    print("se intra pe saveadata ?????");
    var dbClient = await db;
    var res = await dbClient.insert(Table_User, user.toMap());
    print("A reusit inserarea ??");
    print("Uite cat este rezultatul inserarii $res");
    return res;
  }

  void populate_db() async {
    var dbClient = await db;
    var usr2 = UserModel(2, "user2", "user2", 50);
    var usr3 = UserModel(3, "user3", "user3", 60);
    var usr4 = UserModel(4, "user4", "user4", 100);
    saveData(usr2);
    saveData(usr3);
    saveData(usr4);
  }

  Future<UserModel> getLoginUser(String usr, String pas) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery("SELECT * FROM $Table_User WHERE "
        "$C_UserName = '$usr' AND "
        "$C_Password = '$pas'");

    if (res.length > 0) {
      print("Uite ce returneaza ca a gasit $res");
      print("Zice ca a gasit ceva dar ce ?");
      return UserModel.fromMap(res.first);
    }
    print("Va returna -1");
    return UserModel(0, '', '', -1);
  }

  Future<UserModel> getall() async {
    var dbClient = await db;
    var res = await dbClient.rawQuery("SELECT * FROM $Table_User ");
    print("Hai Doamne ajuta");
    if (res.length > 0) {
      return UserModel.fromMap(res.first);
    }

    return UserModel(0, '', '', -1);
  }

  Future<int> last_id() async {
    var dbClient = await db;
    int? count = Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT max($C_UserID) FROM $Table_User"));
    print('Ultimul id este : $count');
    if (count == null) {
      print("Uite aici returnam ceva , gen 1 ca sa fie primul");
      return 1;
    } else {
      print("Uite aici returnam altceva");
      return count + 1;
    }
  }

  Future<int> updateUser(UserModel user) async {
    var dbClient = await db;
    var res = await dbClient.update(Table_User, user.toMap(),
        where: '$C_UserID = ?', whereArgs: [user.user_id]);
    return res;
  }

  Future<int> deleteUser(String user_id) async {
    var dbClient = await db;
    var res = await dbClient
        .delete(Table_User, where: '$C_UserID = ?', whereArgs: [user_id]);
    return res;
  }

  Future<int?> Position(int punctaj) async {
    var dbClient = await db;
    int? pos = Sqflite.firstIntValue(await dbClient.rawQuery(
        "SELECT count(*) FROM $Table_User where $C_Punctaj >=$punctaj"));
    print("Hai vtm $pos");
    if (pos != null) return pos;
  }

  _CreateTableIstoric(Database db, int intVersion) async {
    print("Creare iSTORIC");
    await db.execute("CREATE TABLE $Table_istoric ("
        " $C_UserID INTEGER, "
        " $C_Centru TEXT, "
        " $C_Tip TEXT, "
        " $C_Brat  TEXT, "
        " $C_Data TEXT "
        ")");
  }

  Future<int> saveDataIstoric(IstoricModel user) async {
    print("se intra pe saveadata ?????");
    var dbClient = await db;
    var res = await dbClient.insert(Table_istoric, user.toMap());
    print("A reusit inserarea ??");
    print("Uite cat este rezultatul inserarii $res");
    return res;
  }

  Future<List<IstoricModel>?> getIstoricUser(int userid) async {
    print("INtra pe getistoric user");
    var dbClient = await db;
    var res = await dbClient.rawQuery(
        "SELECT * FROM $Table_istoric WHERE $C_UserID = $userid ORDER BY $C_Data DESC");
    List<IstoricModel> lsrez = [];
    if (res.length > 0) {
      print("Uite ce returneaza ca a gasit $res");
      print("Zice ca a gasit ceva dar ce ?");

      for (var i = 0; i < res.length; i++) {
        lsrez.add(IstoricModel.fromMap(res[i]));
      }
      // } else {
      //   print("Nimic pe istoric user ala ");
      //   lsrez.add(IstoricModel(0, '', '', "2022-03-30", ''));
      // }
      return lsrez;
    }
  }

  void populate_istoric() async {
    var u2_1 = IstoricModel(
        2, "Centrul de transfuzii Iasi", "Sange", "2022-05-01", "stang");
    var u3_1 = IstoricModel(
        3, "Centrul de transfuzii Oradea", "Sange", "2022-05-01", "drept");
    var u3_2 = IstoricModel(
        3, "Centrul de transfuzii Oradea", "Trombocite", "2022-04-12", "drept");
    var u4_1 = IstoricModel(
        4, "Centrul de transfuzii Galati", "Sange", "2022-05-01", "drept");
    var u4_2 = IstoricModel(
        4, "Centrul de transfuzii Galati", "Sange", "2022-04-01", "stang");

    saveDataIstoric(u2_1);
    saveDataIstoric(u3_1);
    saveDataIstoric(u3_2);
    saveDataIstoric(u4_1);
    saveDataIstoric(u4_2);
  }

  Future<String> get_last_sange(int userId) async {
    // populate_istoric();
    // getIstoricUser(userId);
    var dbClient = await db;
    var res = await dbClient.rawQuery("SELECT data FROM $Table_istoric WHERE "
        "$C_UserID = '$userId' AND tip = 'Sange' ORDER BY data DESC");
    // print("Ba ceva crapa garv, $res");
    if (res.length != 0) {
      var ceva = res.first['data'] as String;
      return ceva;
    } else {
      return "2030-03-03";
    }
  }

  Future<String> get_last_trombocite(int userId) async {
    // print("otelul galati");
    var dbClient = await db;
    var res = await dbClient.rawQuery("SELECT data FROM $Table_istoric WHERE "
        "$C_UserID = '$userId' AND tip = 'Trombocite' ORDER BY data DESC");
    print("Ma mai enervezi mult ??? $res");
    if (res.length != 0) {
      var ceva1 = res.first['data'] as String;
      print(ceva1);
      return ceva1;
    } else {
      print("NU avem date returneaza ok");
      return "2030-03-03";
    }
  }
}
