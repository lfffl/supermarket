import 'package:sqflite/sqflite.dart';

import 'db_provider.dart';
import 'package:supermarket/src/pages/models/supermercado_model.dart';
export 'package:supermarket/src/pages/models/supermercado_model.dart';


class SupermercadoProvider {
  Database db;

  //  SupermercadoProvider() {
  //   iniciarbd();
  // }

  // void iniciarbd() async {
  //   db = await DBProvider.db.database;
  // }
  insert(Supermercado supermercado) async {
     db = await DBProvider.db.database;
    final res = await db.insert('supermercado', supermercado.toJson());
    return res;
  }

  Future<Supermercado> getSupermercadoId(int id) async {
     db = await DBProvider.db.database;
    final res = await db.query('supermercado', where: 'id=?', whereArgs: [id]);
    return res.isNotEmpty ? Supermercado.fromJson(res.first) : null;
  }

  Future<List<Supermercado>> getAll() async {
     db = await DBProvider.db.database;
    final res = await db.query('supermercado');
    List<Supermercado> list =
        res.isNotEmpty ? res.map((e) => Supermercado.fromJson(e)).toList() : null;
    return list;
  }

  updateSupermercado(Supermercado supermercado) async {
     db = await DBProvider.db.database;
    final res = db.update('supermercado', supermercado.toJson(),
        where: 'id = ?', whereArgs: [supermercado.id]);
    return res; // retorna el numero de id,s actualizados
  }

  deleteSupermercado(int id) async {
     db = await DBProvider.db.database;
    final res = db.delete('supermercado', where: 'id=?', whereArgs: [id]);
    return res; // retorna el numero de filas eliminadas
  }
}
