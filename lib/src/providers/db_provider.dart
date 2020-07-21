import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supermarket/src/providers/bd2.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    // print('base de datos iniciando creacion!');
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ComVoz1.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      String str = scriptBD2();
      var arr = str.split(';');
      arr.forEach((element)async {
        // print('ejecutando:   $element');
        if (element != '') {
          await db.execute(element);  
        }
        
      });
      
    });
  }
}
