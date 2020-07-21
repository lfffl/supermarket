import 'package:sqflite/sqflite.dart';
import 'package:supermarket/src/models/producto_model.dart';
export 'package:supermarket/src/models/producto_model.dart';

import 'db_provider.dart';



class ProductoProvider {
  Database db;

   ProductoProvider() {
    iniciarbd();
  }

  void iniciarbd() async {
    db = await DBProvider.db.database;
  }

  insert(Producto producto) async {
    db = await DBProvider.db.database;
    final res = await db.insert('Producto', producto.toJson());
    return res;
  }

  Future<Producto> getProductoId(int id) async {
    db = await DBProvider.db.database;
    final res = await db.query('Producto', where: 'id=?', whereArgs: [id]);
    return res.isNotEmpty ? Producto.fromJson(res.first) : null;
  }
  Future<List<Producto>> getProductosCategoria(int id) async {
    db = await DBProvider.db.database;
    final res = await db.query('Producto', where: 'idcategoria=?', whereArgs: [id]);
    List<Producto> list =
        res.isNotEmpty ? res.map((e) => Producto.fromJson(e)).toList() : null;
    return list;
  }

  Future<List<Producto>> getAll() async {
    db = await DBProvider.db.database;
    final res = await db.query('Producto');
    List<Producto> list =
        res.isNotEmpty ? res.map((e) => Producto.fromJson(e)).toList() : null;
    return list;
  }

  updateProducto(Producto producto) async {
    db = await DBProvider.db.database;
    final res = db.update('Producto', producto.toJson(),
        where: 'id = ?', whereArgs: [producto.id]);
    return res; // retorna el numero de id,s actualizados
  }

  deleteProducto(int id) async {
    db = await DBProvider.db.database;
    final res = db.delete('Producto', where: 'id=?', whereArgs: [id]);
    return res; // retorna el numero de filas eliminadas
  }
}
