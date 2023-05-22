import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/user_model.dart';

class DatabaseHelper {
  static final nombreBD = 'USERSSBD';
  static final versionDB = 1;

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    return _database = await _initDatabase();
  }

  _initDatabase() async {
    Directory carpeta = await getApplicationDocumentsDirectory();
    String rutaBD = join(carpeta.path, nombreBD);
    return await openDatabase(
      rutaBD,
      version: versionDB,
      onCreate: _crearTablas,
    );
  }

  _crearTablas(Database db, int version) {
    String query =
        "CREATE TABLE tblUser(id_Usuario INTEGER PRIMARY KEY, imagen VARCHAR(100), nombre VARCHAR(100), correo VARCHAR(100), numero  VARCHAR(12), urlGit VARCHAR(200))";
    db.execute(query);
  }

  Future<int> insertar(Map<String, dynamic> row, String nomTabla) async {
    var conexion = await database;
    return conexion.insert(nomTabla, row);
  }

  Future<List<UsersDAO>> getAllTareas() async {
    var conexion = await database;
    var result = await conexion.query('tblUser');
    return result.map((mapUser) => UsersDAO.fromJson(mapUser)).toList();
  }
}
