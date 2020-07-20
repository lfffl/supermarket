import 'package:sqflite/sqflite.dart';

import 'db_provider.dart';
import 'package:supermarket/src/pages/models/detalle_prod_carrito_model.dart';
export 'package:supermarket/src/pages/models/detalle_prod_carrito_model.dart';

class DetalleProvider {
  Database db;

   DetalleProvider() {
    iniciarbd();
  }

  void iniciarbd() async {
    db = await DBProvider.db.database;
  }


  insert(Detalle detalle) async {
    final res = await db.insert('Detalle', detalle.toJson());
    return res;
  }

  Future<Detalle> getDetalleId(int id) async {
    final res = await db.query('Detalle', where: 'id=?', whereArgs: [id]);
    return res.isNotEmpty ? Detalle.fromJson(res.first) : null;
  }

  Future<List<Detalle>> getAll() async {
    final res = await db.query('Detalle');
    List<Detalle> list =
        res.isNotEmpty ? res.map((e) => Detalle.fromJson(e)).toList() : null;
    return list;
  }

  updateDetalle(Detalle detalle) async {
    final res = db.update('Detalle', detalle.toJson(),
        where: 'id = ?', whereArgs: [detalle.id]);
    return res; // retorna el numero de id,s actualizados
  }

  deleteDetalle(int id) async {
    final res = db.delete('Detalle', where: 'id=?', whereArgs: [id]);
    return res; // retorna el numero de filas eliminadas
  }

  
}
