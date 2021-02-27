import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import "package:path/path.dart";

class DBProvider {
  static Database _dataBase;

  // Singleton
  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future<Database> get dataBase async {
    if (_dataBase != null) {
      return _dataBase;
    }

    _dataBase = await initDB();

    return _dataBase;
  }

  Future<Database> initDB() async {
    //Path de donde alamacenaremos la base de datos
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "ScansDB.db");
    print(path);

    //Crear base de datos
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE scans(
            id INTEGER PRIMARY KEY,
            tipo TEXT,
            valor TEXT
          )
        ''');
      },
    );
  }
}
