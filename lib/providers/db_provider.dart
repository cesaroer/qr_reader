import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import "package:path/path.dart";
import 'package:qr_reader/models/scan_model.dart';
export 'package:qr_reader/models/scan_model.dart';

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
          );
        ''');
      },
    );
  }

  Future<int> nuevoScanRaw(ScanModel nuevoScan) async {
    final id = nuevoScan.id;
    final tipo = nuevoScan.tipo;
    final valor = nuevoScan.valor;

    //Verificar la base de datos
    final db = await dataBase;

    final res = await db.rawInsert(''' 
        INSERT INTO scans ( id, tipo, valor) 
          VALUES ($id,'$tipo','$valor');
    ''');

    return res;
  }

  Future<int> nuevoScan(ScanModel nuevoScan) async {
    final db = await dataBase;
    final res = await db.insert("scans", nuevoScan.toJson());
    print(res);

    // res es el id del ultimo registro insertado
    return res;
  }

  Future<ScanModel> getScanByID(int id) async {
    final db = await dataBase;
    final res = await db.query("Scans", where: "id = ?", whereArgs: [id]);

    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getTodosScans() async {
    final db = await dataBase;
    final res = await db.query("Scans");

    return res.isNotEmpty
        ? res.map((scan) => ScanModel.fromJson(scan)).toList()
        : [];
  }

  Future<List<ScanModel>> getScansPorTipo(String tipo) async {
    final db = await dataBase;
    final res = await db.rawQuery(''' 
      SELECT * FROM Scans WHERE tipo = "$tipo"
    ''');

    return res.isNotEmpty
        ? res.map((scan) => ScanModel.fromJson(scan)).toList()
        : [];
  }
}
