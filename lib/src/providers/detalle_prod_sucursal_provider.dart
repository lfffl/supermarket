import 'package:sqflite/sqflite.dart';
import 'package:supermarket/src/models/detalle_prod_sucursal_model.dart';
import 'db_provider.dart';

class DetProdSucursalProvider {
  Database db;

  insert(DetProdSucursal detProdSucursal) async {
    db = await DBProvider.db.database;
    final res = await db.insert('DetProdSucursal', detProdSucursal.toJson());
    return res;
  }

  Future<DetProdSucursal> getDetProdSucursalId(int id) async {
    db = await DBProvider.db.database;
    final res = await db.query('DetProdSucursal', where: 'id=?', whereArgs: [id]);
    return res.isNotEmpty ? DetProdSucursal.fromJson(res.first) : null;
  }

  Future<List<DetProdSucursal>> getDetProdSucursalIdCarrito(int id) async {
    db = await DBProvider.db.database;
    final res = await db.query('DetProdSucursal', where: 'idcarrito=?', whereArgs: [id]);
    List<DetProdSucursal> list =
        res.isNotEmpty ? res.map((e) => DetProdSucursal.fromJson(e)).toList() : null;
    return list;
  }

  Future<List<DetProdSucursal>> getAll() async {
    db = await DBProvider.db.database;
    final res = await db.query('DetProdSucursal');
    List<DetProdSucursal> list =
        res.isNotEmpty ? res.map((e) => DetProdSucursal.fromJson(e)).toList() : null;
    return list;
  }

  updateDetProdSucursal(DetProdSucursal detProdSucursal) async {
    db = await DBProvider.db.database;
    final res = db.update('DetProdSucursal', detProdSucursal.toJson(),
        where: 'id = ?', whereArgs: [detProdSucursal.id]);
    return res; // retorna el numero de id,s actualizados
  }

  deleteDetProdSucursal(int id) async {
    db = await DBProvider.db.database;
    final res = db.delete('DetProdSucursal', where: 'id=?', whereArgs: [id]);
    return res; // retorna el numero de filas eliminadas
  }

  
}
