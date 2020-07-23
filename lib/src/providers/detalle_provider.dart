import 'package:sqflite/sqflite.dart';
import 'package:supermarket/src/models/detalle_prod_carrito_model.dart';
export 'package:supermarket/src/models/detalle_prod_carrito_model.dart';

import 'db_provider.dart';

class DetalleProvider {
  Database db;

  insert(Detalle detalle) async {
    db = await DBProvider.db.database;
    final res = await db.insert('Detalle', detalle.toJson());
    return res;
  }

  Future<Detalle> getDetalleId(int id) async {
    db = await DBProvider.db.database;
    final res = await db.query('Detalle', where: 'id=?', whereArgs: [id]);
    return res.isNotEmpty ? Detalle.fromJson(res.first) : null;
  }

  Future<List<Detalle>> getDetalleIdCarrito(int id) async {
    db = await DBProvider.db.database;
    final res = await db.query('Detalle', where: 'idcarrito=?', whereArgs: [id]);
    List<Detalle> list =
        res.isNotEmpty ? res.map((e) => Detalle.fromJson(e)).toList() : null;
    return list;
  }

  Future<List<Detalle>> getAll() async {
    db = await DBProvider.db.database;
    final res = await db.query('Detalle');
    List<Detalle> list =
        res.isNotEmpty ? res.map((e) => Detalle.fromJson(e)).toList() : null;
    return list;
  }

  updateDetalle(Detalle detalle) async {
    db = await DBProvider.db.database;
    final res = db.update('Detalle', detalle.toJson(),
        where: 'id = ?', whereArgs: [detalle.id]);
    return res; // retorna el numero de id,s actualizados
  }

  deleteDetalle(int id) async {
    db = await DBProvider.db.database;
    final res = db.delete('Detalle', where: 'id=?', whereArgs: [id]);
    return res; // retorna el numero de filas eliminadas
  }

  
}
